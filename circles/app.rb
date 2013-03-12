class CirclesApp < Processing::App
  
  # load_library :control_panel

  def setup
    size(400, 400, P3D);
    smooth();
  end    

  def draw
    # clear screen
    background color(255,255,255)

    # draw all painted rings
    rings.each(&:animate)

    # draw cursor
    cursor_bubble.animate
  end

  def mouse_clicked
    ring_size = random(50, 150)
    rings << Ring.new(:x => mouseX, :y => mouseY, :width => ring_size, :height => ring_size)
  end

  def key_pressed
    save_frame if key_code == ENTER
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
      @length ||= 48
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

    def thickness
      @thickness ||= random(5,15)
    end

    def inner_bubble
      @inner_bubble ||= Bubble.new( :x => x,
                                    :y => y,
                                    :width => outer_bubble.width - thickness,
                                    :height => outer_bubble.height - thickness,
                                    :current_frame => outer_bubble.current_frame - 10,
                                    :fill_color => color(255,255,255))
    end

    def outer_bubble
      @outer_bubble ||= Bubble.new(:x => x, :y => y, :width => width, :height => height)
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
end

CirclesApp.new
