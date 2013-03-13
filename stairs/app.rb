class CirclesApp < Processing::App
  # load_library :control_panel

  def setup
    size(400, 400, P3D);
    smooth();
    frame_rate(4)

    stroke(color(0,0,0))
  end

  def draw
    fill random_color

    pushMatrix
      translate width/2, height/2
      rotate rotation
      rect -400, 0, 800, 400
    popMatrix

    step_rotate
  end

  def mouse_clicked
  end

  def key_pressed
  end

  def random_color
    colors[random(0, colors.length).to_i]
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

  def step_rotation_distance
    @step_rotation_distance ||= PI * 0.15
  end

  def step_rotate
    # set new target if we got close enough
    @target_rotation = generate_target_rotation if (target_rotation-rotation).abs < step_rotation_distance
    # decrease the distance form current rotation to target rotation with 10%
    # @rotation += (target_rotation - rotation) * 0.2
    @rotation += target_rotation > rotation ? step_rotation_distance : -step_rotation_distance
  end

  def target_rotation
    @target_rotation ||= generate_target_rotation
  end

  def generate_target_rotation
    random(-TWO_PI, TWO_PI)
  end
end

CirclesApp.new
