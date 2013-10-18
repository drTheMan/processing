require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'class_options'))
require 'rubygems'
require 'bundler/setup'
require 'sketch_control'
require 'sketch_control/control_panel'


class CirclesApp < Processing::App
  # load_library :control_panel

  attr_reader :options

  def initialize(_opts = {})
    super
    @options = _opts.is_a?(Hash) ? _opts : {}
  end

  def setup
    size(400, 400, P3D);
    sketch_control
    # smooth();
  end    

  def key_pressed
    # screenshot
    save_frame if key_code == ENTER
  end

  def sketch_control
    @sketch_control ||= SketchController.new
  end

  def bgcolor
    sketch_control.bgcolor || color(255,255,255)
  end

  def strokecolor
    sketch_control.strokecolor || color(0,0,0)
  end

  def draw
    background bgcolor
    drawSquares
  end

  def squareWidth
    sketch_control.squarewidth.to_i < 1 ? 30 : sketch_control.squarewidth.to_i
  end

  def squareHeight
    sketch_control.squareheight.to_i < 1 ? 30 : sketch_control.squareheight.to_i
  end

  def squareoffset
    sketch_control.squareoffset.to_i
  end

  def drawSquare(x,y)
    no_fill
    stroke(strokecolor)

    rect(x - random(squareoffset), y - random(squareoffset), squareWidth + random(squareoffset), squareHeight + random(squareoffset))
  end
  def drawSquares
    0.upto(height / squareHeight) do |y|
      0.upto(width / squareWidth) do |x|
        drawSquare(x * squareWidth, y * squareHeight)
      end
    end
  end
end

class SketchController
  include Processing::Proxy
  include SketchControl

  attr_reader :options
  attr_reader :bgcolor, :strokecolor, :squarewidth, :squareoffset, :squareheight

  def initialize(_opts = {})
    @options = _opts || {}
    setup_controls
  end

  def setup_controls
    sketch_controls do |c|
      c.title = "Sketch Controls Panel"

      c.slider :label => :squarewidth, :min => 0, :max => 300
      c.slider :label => :squareheight, :min => 0, :max => 300
      c.slider :label => :squareoffset, :min => 0, :max => 300


      c.rgb :background do |value|
        @bgcolor = value #puts "Sketch got: #{value} from background slider"
      end

      c.rgb :stroke do |value|
        @strokecolor = value #puts "Sketch got: #{value} from background slider"
      end

    end
  end
end

opts = {}
# if ARGV.include?('--squares')
# opts[:pattern => :squares]
CirclesApp.new(opts)
