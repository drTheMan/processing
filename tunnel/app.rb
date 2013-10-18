require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'class_options'))

class TunnelApp < Processing::App

  def setup
    size(1400, 900, P3D);
    smooth();
    frame_rate(12)
  end

  def swirlies
    @swirlies ||= [Swirly.new(:x => width*0.5, :y => height*0.5, :w => width, :h => height)]
  end

  def generate_swirly
    Swirly.new(:x => random(0,width), :y => random(0,height), :w => random(0, width), :h => random(0, height))
  end

  def draw
    if @reset
      background(color(255,255,255))
      @reset = false
    end

    swirlies.each(&:animate)
    # draw_overlay if draw_overlay?
  end

  def mouse_clicked
  end

  def key_pressed
    # screenshot
    save_frame if key_code == ENTER

    # add new swirly to the scene
    @swirlies = swirlies + [generate_swirly] if key == ' '

    # @overlay = !@overlay if key_code == TAB
    @reset = true if key_code == TAB
    # @target_y = target_y - 10 if key_code == UP
    # @target_y = target_y + 10 if key_code == DOWN
    # @target_x = target_x - 10 if key_code == LEFT
    # @target_x = target_x + 10 if key_code == RIGHT

    swirlies.each do |swirly|
      swirly.randomize_color = !swirly.randomize_color? if key == 'c'
      swirly.randomize_gap = !swirly.randomize_gap? if key == 'g'
      swirly.opacity = swirly.opacity + 5 if key == '='
      swirly.opacity = swirly.opacity - 5 if key == '-'
      swirly.render = swirly.render + 1 if key == '/'
      swirly.randomize_x = !swirly.randomize_x? if key == 'x'
      swirly.randomize_y = !swirly.randomize_y? if key == 'y'
    end
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

    def w
      options[:w]
    end

    def h
      options[:h]
    end

    def gap
      options[:gap]
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

    def step
      step_rotate
    end

    def animate
      draw
      step
    end

    #
    # alpha
    #

    def opacity=(new_opacity)
      @opacity = new_opacity < 0 ? 0 : new_opacity > 255 ? 255 : new_opacity
    end

    def opacity
      @opacity ||= options[:opacity] || 30
    end

    #
    # gap
    #

    def get_gap
      @gap ||= random(10, height*0.5)
      # randomize_gap? ? @gap - @gap * (target_rotation_distance % TWO_PI) / TWO_PI : @gap
      randomize_gap? ? (@gap = random(0, h * 0.5)) : @gap
    end

    attr_writer :randomize_gap

    def randomize_gap?
      @randomize_gap.nil? ? @randomize_gap = (options[:randomize_gap] == true) : @randomize_gap
    end

    #
    # color
    #

    def current_color
      @current_color ||= random_color
      return @current_color = color(red(@current_color), green(@current_color), blue(@current_color), opacity)
    end

    def get_color
      randomize_color? ? @current_color = random_color : current_color
    end

    # gives a random color, incorporating the current alpha-level
    def random_color
      color(random(0,255), random(0,255), random(0,255), opacity)
    end

    attr_writer :randomize_color

    def randomize_color?
      @randomize_color.nil? ? @randomize_color = (options[:randomize_color] != false) : @randomize_color
    end

    #
    # render mode
    #

    attr_writer :render

    def render
      (@render || 0) % 4
    end

    #
    # pos
    #

    attr_writer :randomize_x, :randomize_y

    def randomize_x?
      @randomize_x.nil? ? @randomize_x = (options[:randomize_x] == true) : @randomize_x
    end

    def randomize_y?
      @randomize_y.nil? ? @randomize_y = (options[:randomize_y] == true) : @randomize_y
    end


    private

    def draw_layer(layer)
      pushMatrix
        translate x, y
        rotate layer.rotation

        stroke(color(255,255,255))
        fill color(layer.color)

        case render
        when 3
          rect -(layer.w*0.5), layer.gap, layer.w, (layer.h*0.5-layer.gap)
          rect -(layer.w*0.5), -layer.gap, layer.w, -(layer.h*0.5-layer.gap)
        when 2
          ellipse -(layer.w*0.5), layer.gap, layer.w, layer.h*0.5-layer.gap
          ellipse -(layer.w*0.5), -layer.gap, layer.w, -(layer.h*0.5-layer.gap)
        when 1
          ellipse 0, layer.gap+layer.h*0.25, layer.w, (layer.h*0.5)
          ellipse 0, -layer.gap-layer.h*0.25, layer.w, -(layer.h*0.5-layer.gap)
        else
          rect -(layer.w*0.5), layer.gap, layer.w, (layer.h*0.5-layer.gap)
          rect -(layer.w*0.5), -layer.gap, layer.w, -(layer.h*0.5-layer.gap)
        end
      popMatrix
    end

    # generates a layer object with random/calculated attributes
    def generate_layer
      step_rotate
      step_x if randomize_x?
      step_y if randomize_y?

      # use current rotation and color and the widht/height of the window to create a new layer
      Layer.new(:rotation => rotation, :color => get_color, :w => w, :h => h, :gap => get_gap)
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
      target_rotation_distance * 0.1
    end

    # generate a new target_rotation (5 full turns left, or 5 full turns right from starting rotation)
    def generate_target_rotation
      random(-(TWO_PI*20), (TWO_PI*20))
    end

    #
    # dimensions
    #

    def w
      options[:w] || 100
    end

    def h
      options[:h] || 100
    end

    #
    # position stuff
    #

    # gives the current position's x-coordinate
    def x
      @x ||= options[:x] || 0
    end

    def y
      @y ||= options[:y] || 0
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

  end # of class Swirly
end

TunnelApp.new
