require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'class_options'))

class TunnelApp < Processing::App

  def setup
    size(800, 600, P3D);
    smooth();
    frame_rate(12)
  end

  def draw
    # "remember" original position and rotation
    pushMatrix
      draw_layer(generate_layer)
    popMatrix

    draw_overlay if draw_overlay?
  end

  def draw_layer(layer)
    pushMatrix
      translate x, y
      rotate layer.rotation

      stroke(color(255,255,255))
      fill color(layer.color)
      gap = get_gap

      case render
      when 3
        rect -(layer.width*0.5), gap, layer.width, (layer.height*0.5-gap)
        rect -(layer.width*0.5), -gap, layer.width, -(layer.height*0.5-gap)
      when 2
        ellipse -(layer.width*0.5), gap, layer.width, layer.height*0.5-gap
        ellipse -(layer.width*0.5), -gap, layer.width, -(layer.height*0.5-gap)
      when 1
        ellipse 0, gap+layer.height*0.25, layer.width, (layer.height*0.5)
        ellipse 0, -gap-layer.height*0.25, layer.width, -(layer.height*0.5-gap)
      else
        rect -(layer.width*0.5), gap, layer.width, (layer.height*0.5-gap)
        rect -(layer.width*0.5), -gap, layer.width, -(layer.height*0.5-gap)
      end
    popMatrix
  end

  def render
    (@render || 0) % 4
  end

  def mouse_clicked
  end

  def key_pressed
    save_frame if key_code == ENTER
    @overlay = !@overlay if key_code == TAB
    @target_y = target_y - 10 if key_code == UP
    @target_y = target_y + 10 if key_code == DOWN
    @target_x = target_x - 10 if key_code == LEFT
    @target_x = target_x + 10 if key_code == RIGHT

    @randomize_color = !@randomize_color if key == 'c'
    @randomize_gap = !@randomize_gap if key == 'g'
    @alpha = (@alpha || 30)+5 if key == '='
    @alpha = (@alpha || 30)-5 if key == '-'
    @randomize_x = !@randomize_x if key == 'x'
    @randomize_y = !@randomize_y if key == 'y'
    @render = (@render || 0) + 1 if key == '/'
  end

  def generate_layer
    step_rotate
    step_x if randomize_x?
    step_y if randomize_y?

    # pick a new color if color randomization is enabled, otherwise use existing previous color
    @color = (randomize_color? ? nil : @color) || random_color
    # use current rotation and color and the widht/height of the window to create a new layer
    Layer.new(:rotation => rotation, :color => @color, :width => width, :height => height)
  end

  #
  # gap
  #

  def get_gap
    @gap ||= random(25, 100)
    randomize_gap? ? @gap - target_rotation_distance * 5 : @gap
  end

  def randomize_gap?
    @randomize_gap == true
  end

  #
  # color / alpha
  #

  def alpha
    @alpha ||= 30
  end

  def randomize_color?
    @randomize_color == true
  end

  # gives a random color
  def random_color
    color(random(0,255), random(0,255), random(0,255), alpha)
  end

  #
  # rotation
  #

  # gives the current rotation
  def rotation
    @rotation ||= 0
  end

  # changes the current rotation, towards the target_rotation
  def step_rotate
    # set new target if no target set yet, or target is reached
    @target_rotation = generate_target_rotation  if @target_rotation.nil? || target_rotation_distance.abs < 0.1
    # "rotate" by increasing the current roation with step_rotation_distance
    @rotation = rotation + step_rotation_distance
  end

  # gives the target rotation (and generates one if necessary)
  def target_rotation
    @target_rotation ||= generate_target_rotation
  end

  # gives the rotation distance from the current rotation to the target rotation
  def target_rotation_distance
    target_rotation ? target_rotation - rotation : 0.0
  end

  # gives the rotation-length of the next step towards the target_rotation (40% of rotation distance)
  def step_rotation_distance
    # @step_rotation_distance ||= PI * 0.1
    target_rotation_distance * 0.2
  end

  # generate a new target_rotation (5 full turns left, or 5 full turns right from starting rotation)
  def generate_target_rotation
    random(-(TWO_PI*10), (TWO_PI*10))
  end

  #
  # position
  #

  # gives the current position's x-coordinate
  def x
    @x ||= width * 0.5
  end

  def y
    @y ||= height * 0.5
  end

  # gives a random x coordinate to move the center of the spiral to
  def random_x
    random(10, width-10)
  end

  def random_y
    random(10, height-10)
  end

  def step_x
    @target_x = random_x if @target_x.nil? || target_x_distance.abs <= 3.0
    @x = x + step_x_distance
  end

  def step_y
    @target_y = random_y if @target_y.nil? || target_y_distance.abs <= 3.0
    @y = y + step_y_distance
  end

  def target_x
    @target_x ||= random_x
  end

  def target_y
    @target_y ||= random_y
  end

  def target_x_distance
    target_x ? target_x - x : 0.0
  end

  def target_y_distance
    target_y ? target_y - y : 0.0
  end

  def step_x_distance
    target_x_distance > 0 ? 3 : -3
    # target_x_distance * 0.01
  end

  def step_y_distance
    target_y_distance > 0 ? 3 : -3
    # target_y_distance * 0.01
  end

  def randomize_x?
    @randomize_x == true
  end

  def randomize_y?
    @randomize_y == true
  end

  #
  # overlay
  #

  def draw_overlay?
    @overlay == true
  end

  PREFERRED_FONTS = ['Consolas', 'Helvetica']

  def available_font_names
    @available_font_names ||= PFont.list
  end

  def font_name
    PREFERRED_FONTS.find{|font| self.available_font_names.include?(font)} || self.available_font_names.first
  end

  def font_size
    18
  end

  def overlay_font
    @font ||= create_font(font_name, font_size)
  end

  def draw_overlay
    # draw a vertical red lign at target_x-coordinate
    if randomize_x?
      stroke(color(255,0,0))
      line(target_x, 0, target_x, height)
    end

    # draw a horizontal red line at target_y-coordinate
    if randomize_y?
      stroke(color(255,0,0))
      line(0, target_y, width, target_y)
    end

    # draw a little circle at the target position
    stroke(color(0,0,0))
    fill(255,0,0)
    ellipse(target_x, target_y, 10, 10)

    # write info in top left corner
    messages = [
      "position: #{"%5.2f" % x}, #{"%5.2f" % y}",
      "target: #{"%5.2f" % target_x}, #{"%5.2f" % target_y}",
      "alpha: #{alpha}"
    ]

    # black background
    no_stroke
    fill color(0, 0, 0, 150)
    rect(10, 10, 300, messages.length * font_size + 10)

    # white text
    fill color(255, 255, 255)
    text_font overlay_font
    messages.each_with_index{|msg, index| text(msg, 20, 10 + (index+1)*font_size)}
  end


  # a wrapper class for the layers that are drawn on top of each other
  # (doesn't really do anything right now, only a container for the attributes)

  class Layer
    include ClassOptions

    def rotation
      options[:rotation]
    end

    def color
      options[:color]
    end

    def width
      options[:width]
    end

    def height
      options[:height]
    end
  end # of class Layer


  class Swirly
    include ClassOptions

    def draw
      # "remember" original position and rotation
      pushMatrix
        draw_layer(generate_layer)
      popMatrix
    end

  end # of class Swirly
end

TunnelApp.new
