require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'class_options'))
require 'rubygems'
require 'bundler/setup'
require 'sketch_control/control_panel'

class CirclesApp < Processing::App
  # load_library :control_panel

  def setup
    size(400, 400, P3D);
    sketch_control
    # smooth();
  end    

  def sketch_control
    @sketch_control ||= SketchController.new
  end

  def bgcolor
    color(sketch_control.bgcolorr.to_i,255,255)
  end

  def draw
    # clear screen
    background bgcolor

    pushMatrix
      # translate to center of screen so rotation happens within the view-port
      translate(width*0.5, height*0.5, -100)

      # rotate 
      rotate_y(rot_y + pull_distance_x*0.01)
      rotate_x(rot_x + pull_distance_y*0.01)

      # translate back to the original position as we are aligned with cursor actions
      # but also incorporate the custom translate_x and translate_y position
      translate(width*-0.5 + translate_x, height*-0.5 + translate_y, 100 + translate_z)

      # draw all painted rings
      rings.each(&:animate)

      # draw cursor
      cursor_bubble.animate
    popMatrix   

    if draw_console?
      pushMatrix
        translate(10, 15, 0)
        debug_console.draw
      popMatrix
    end
  end

  # right mouse button causes rotation dragging
  def mouse_pressed
    super

    if mouse_button == RIGHT
      @right_mouse_down_x = mouseX
      @right_mouse_down_y = mouseY
    end
  end

  def pulling?
    mouse_button == RIGHT
  end

  def pull_distance_x
    pulling? ? mouseX - (@right_mouse_down_x || 0) : 0.0
  end

  def pull_distance_y
    pulling? ? mouseY - (@right_mouse_down_y || 0) : 0.0
  end

  # left mouse button paints a new ring at the current mouse position
  def mouse_clicked
    super
    ring_size = random(50, 150)
    rings << Ring.new(:x => mouseX, :y => mouseY, :width => ring_size, :height => ring_size, :length => random(24, 48).to_i)
  end

  def key_pressed
    # screenshot
    save_frame if key_code == ENTER

    # rotate
    @rot_y = rot_y + TWO_PI * 0.01 if key_code == RIGHT
    @rot_y = rot_y - TWO_PI * 0.01 if key_code == LEFT
    @rot_x = rot_x + TWO_PI * 0.01 if key_code == UP
    @rot_x = rot_x - TWO_PI * 0.01 if key_code == DOWN

    # translate
    @translate_x = translate_x - 10.0 if key == 'j'
    @translate_x = translate_x + 10.0 if key == 'l'
    @translate_y = translate_y - 10.0 if key == 'i'
    @translate_y = translate_y + 10.0 if key == 'k'
    @translate_z = translate_z - 10.0 if key == '['
    @translate_z = translate_z + 10.0 if key == ']'

    # reset view-port (translation and rotation)
    if key == '0'
      @rot_x = nil
      @rot_y = nil
      @translate_x = nil
      @translate_y = nil
      @translate_z = nil
    end

    # toggle console on/off
    @draw_console = !@draw_console if key_code == TAB
  end

  def draw_console?
    @draw_console == true
  end

  def cursor_bubble
    @cursor_bubble ||= Bubble.new
    @cursor_bubble.x = mouseX
    @cursor_bubble.y = mouseY
    return @cursor_bubble
  end

  def rings
    @rings ||= []
  end


  def rot_x
    @rot_x || 0.0
  end

  def rot_y
    @rot_y || 0.0
  end

  def translate_x
    @translate_x || 0.0
  end

  def translate_y
    @translate_y || 0.0
  end

  def translate_z
    @translate_z || 0.0
  end

  def debug_console
    @debug_console = Console.new(:app => self)
  end


  class Bubble
    attr_writer :x, :y

    def initialize(opts = {})
      @options = opts
    end

    def app
      options[:app]
    end

    def options
      @options || {}
    end

    def current_frame
      @current_frame ||= options[:current_frame] || 0
    end

    def x
      @x || options[:x] || 0
    end

    def y
      @y || options[:y] || 0
    end

    def width
      options[:width] || @width ||= 100
    end

    def height
      options[:height] || @height ||= 100
    end

    def fill_color
      @fill_color ||= options[:fill_color] || color(0, 0, 0)
    end

    def length
      @length || options[:length] || 48
    end

    def step
      @current_frame = current_frame + 1
    end

    def draw
      no_stroke
      fill fill_color
      size_factor = sin(PI*0.7*current_frame/length)

      pushMatrix
        translate x, y
        ellipse 0, 0, width * size_factor, height * size_factor  
      popMatrix      
    end

    def animate
      draw
      step
    end
  end # of class Bubble


  class Ring
    def initialize(_opts = {})
      @options = _opts
    end

    def options
      @options || {}
    end

    def x
      @x || options[:x] || 100
    end

    def y
      @y || options[:y] || 100
    end

    def width
      @width || options[:width] || 100
    end

    def height
      @height || options[:height] || 100
    end

    def length
      @length || options[:length] || 48
    end

    def thickness
      @thickness ||= random(5,15)
    end

    def inner_bubble
      @inner_bubble ||= Bubble.new( :x => x,
                                    :y => y,
                                    :width => outer_bubble.width - thickness,
                                    :height => outer_bubble.height - thickness,
                                    :current_frame => outer_bubble.current_frame - 10,
                                    :fill_color => color(255,255,255),
                                    :length => outer_bubble.length)
    end

    def outer_bubble
      @outer_bubble ||= Bubble.new(:x => x, :y => y, :width => width, :height => height, :length => length)
    end

    def step
      inner_bubble.step
      outer_bubble.step
    end

    def draw
      outer_bubble.draw
      inner_bubble.draw
    end

    def animate
      draw
      step
    end
  end # of class Ring


  class Console
    include ClassOptions

    PREFERRED_FONTS = ['Consolas', 'Helvetica']

    def app
      options[:app]
    end

    def lines
      [
        "translate: #{app.translate_x.inspect}, #{app.translate_y.inspect}, #{app.translate_z.inspect}",
        "rotation: #{app.rot_x.inspect}, #{app.rot_y.inspect}",
        # "font: #{font_name.inspect}"
      ]
    end

    def draw
      text_font font
      lines.each_with_index do |line, index|
        text(line, 0, index*font_size*1.5)
      end
    end

    private

    def self.available_font_names
      @available_font_names ||= PFont.list
    end

    def preferred_fonts
      [options[:font_name], PREFERRED_FONTS].flatten.compact.uniq
    end

    def font_name
      preferred_fonts.find{|font| self.class.available_font_names.include?(font)} || self.class.available_font_names.first
    end

    def font_size
      options[:font_size] || 12
    end

    def font
      @font ||= create_font(font_name, font_size)
    end

  end
end

class SketchController
  include Processing::Proxy
  # Processing::App.send :include, ControlPanel::InstanceMethods
  include SketchControl::ControlPanel::InstanceMethods



  attr_reader :options
  attr_reader :bgcolorr

  def initialize(_opts = {})
    @options = _opts || {}
    setup_controls
  end

  def setup_controls
    control_panel do |c|
      c.title = "Control Panel"
      # this automatically writes to the processing's main app class instance variable...
      c.slider :bgcolorr, 0..255, 255 do |value|
        @bgcolorr = value 
      end
    end
  end
end
CirclesApp.new