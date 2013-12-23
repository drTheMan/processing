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
    @paused = (@paused != true) if key == ' '
    @variation = @variation.to_i + 1 if key == '/'
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

  def shapeColor
    sketch_control.shapecolor || color(255,255,255)
  end

  def draw
    if @paused != true
      background bgcolor
      drawPattern
    end
  end

  def shapeWidth
    sketch_control.shapeWidth.to_i < 1 ? 30 : sketch_control.shapeWidth.to_i
  end

  def shapeHeight
    sketch_control.shapeHeight.to_i < 1 ? 30 : sketch_control.shapeHeight.to_i
  end

  def shapeOffset
    sketch_control.shapeOffset.to_i
  end

  def shapeName
    shapes = [:rectangle, :circle, :triangle, :triangle2]
    return shapes[@variation.to_i % shapes.length]
  end

  def drawPattern
    # no_fill
    fill(shapeColor)
    stroke(strokecolor)

    0.upto(height / shapeHeight) do |row|
      0.upto(width / shapeWidth) do |col|
        x = col * shapeWidth - random(shapeOffset)
        y = row * shapeHeight - random(shapeOffset)
        w = shapeWidth + random(shapeOffset)
        h = shapeHeight + random(shapeOffset)

        if shapeName == :rectangle
          rect(x, y, w, h)
        elsif shapeName == :circle
          ellipse(x, y, w, h)
        elsif shapeName == :triangle
          triangle(x,y, x+w,y+h, x,y+h)
          x = col * shapeWidth - random(shapeOffset)
          y = row * shapeHeight - random(shapeOffset)
          w = shapeWidth + random(shapeOffset)
          h = shapeHeight + random(shapeOffset)
          triangle(x,y, x+w,y+h, x+w,y)
        elsif shapeName == :triangle2
          if col.odd?
            triangle(x,y, x+w,y,  x+w*0.5,y+h)
          else
            triangle(x,y+h, x+w,y+h,  x+w*0.5,y)
          end
        end
      end
    end
  end
end

class SketchController
  include Processing::Proxy
  include SketchControl

  attr_reader :options
  attr_reader :bgcolor, :strokecolor, :shapecolor, :shapeWidth, :shapeOffset, :shapeHeight

  def initialize(_opts = {})
    @options = _opts || {}
    setup_controls
  end

  def setup_controls
    sketch_controls do |c|
      c.title = "Sketch Controls Panel"

      c.slider :label => :shapeWidth, :min => 0, :max => 300
      c.slider :label => :shapeHeight, :min => 0, :max => 300
      c.slider :label => :shapeOffset, :min => 0, :max => 300


      c.rgb :background do |value|
        @bgcolor = value #puts "Sketch got: #{value} from background slider"
      end

      c.rgb :stroke do |value|
        @strokecolor = value #puts "Sketch got: #{value} from background slider"
      end

      c.rgb :shape do |value|
        @shapecolor = value #puts "Sketch got: #{value} from background slider"
      end
    end
  end
end

opts = {}
# if ARGV.include?('--squares')
# opts[:pattern => :squares]
CirclesApp.new(opts)
