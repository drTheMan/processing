class TunnelApp < Processing::App
  # load_library :control_panel
  MAX_LAYERS = 10.0

  def setup
    size(400, 400, P3D);
    smooth();
    frame_rate(12)

    stroke(color(0,0,0))
  end

  def draw

    pushMatrix
      translate width/2, height/2
      draw_layer(generate_layer)
    popMatrix

    step_rotate
  end

  def draw_layer(layer)
    pushMatrix
      rotate layer.rotation
      fill red(layer.color), green(layer.color), blue(layer.color), random(50, 150))
      gap = target_rotation_distance * 50
      rect -400, gap, 800, 400
      rect -400, -400-gap, 800, 400
    popMatrix
  end


  def mouse_clicked
  end

  def key_pressed
  end

  def generate_layer
    Layer.new(:rotation => rotation, :color => random_color, :z => layers.length)
  end

  def random_color
    # colors[random(0, colors.length).to_i]
    color(random(0,255), random(0,255), random(0,255))
  end

  def colors
    @colors ||= [
      color(255, 0, 0),
      color(0, 255, 0),
      color(0, 0, 255)
    ]
  end

  def rotation
    @rotation ||= 0
  end

  def step_rotate
    # set new target if no target set yet, or target is reached
    @target_rotation = generate_target_rotation if @target_rotation.nil? || target_rotation_distance.abs < 0.1
    # "rotate"
    @rotation += step_rotation_distance
  end

  def target_rotation
    @target_rotation ||= generate_target_rotation
  end

  def target_rotation_distance
    target_rotation ? target_rotation - rotation : 0.0
  end

  def step_rotation_distance
    # @step_rotation_distance ||= PI * 0.1
    target_rotation_distance * 0.4
  end

  def generate_target_rotation
    random(-TWO_PI, TWO_PI)
  end


  class Layer
    def initialize(_opts = {})
      @options = _opts
    end

    def options
      @options || {}
    end

    def rotation
      options[:rotation]
    end

    def color
      options[:color]
    end

    def z
      options[:z]
    end
  end # of class Layer
end

TunnelApp.new
