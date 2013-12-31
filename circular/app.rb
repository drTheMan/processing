require 'rubygems'
require 'bundler/setup'
require 'sketch_control'
require 'sketch_control/control_panel'

class CircularApp < Processing::App
  # load_library :control_panel

  def setup
    # size(400, 400);
    sketch_control
    smooth
  end

  def sketch_control
    @sketch_control ||= SketchController.new
  end

  def bgcolor
    0 # sketch_control.bgcolor || color(255,255,255)
  end

  def path
    @path ||= Circular.new(:origin => PVector.new(width*0.5, height*0.5), :main => self)
  end

  def update
    path.size = sketch_control.size
    path.move(0.05)
  end

  def draw
    update

    # clear screen
    background bgcolor
    path.draw
  end


  def key_pressed
    # screenshot
    save_frame if key_code == ENTER
    # switch shape if key_code == TAB
  end

end

class Circular
  attr_reader :options
  attr_writer :size

  def initialize _opts = {}
    @options = _opts.is_a?(Hash) ? _opts : {}
  end

  def main
    options[:main]
  end

  def origin
    @origin ||= options[:origin] || PVector.new
  end

  def angle
    @angle ||= options[:angle] || 0
  end

  def move(amount)
    @angle = angle + amount
  end

  def calculatePosition
    position = PVector.new(0, -size)
    position.rotate(angle)
    position.add(origin)
    return position
  end

  def size
    @size ||= options[:size] || 100
  end

  def draw(opts = {})
    # pushMatrix
    #   translate(position.x, position.y)
    #   ellipse(10)
    # popMatrix
    p = calculatePosition
    main.ellipse(p.x, p.y, 20, 20)
  end
end # of class Circular


class SketchController
  include Processing::Proxy
  include SketchControl

  attr_reader :options
  attr_reader :size

  def initialize(_opts = {})
    @options = _opts || {}
    setup_controls
  end

  def setup_controls
    sketch_controls do |c|
      c.title = "Sketch Controls Panel"
      c.slider :label => :size, :min => 0, :max => 500
    end
  end
end

CircularApp.new :title => "Circular",  :width => 400,  :height => 400