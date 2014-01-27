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
    frameRate(12)
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

  def spacingX
    sketch_control.spacingX.to_i
  end

  def spacingY
    sketch_control.spacingY.to_i
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
    shapes = [:rectangle, :circle, :triangle, :triangle2, :cross, :typo1, :typo2]
    return shapes[@variation.to_i % shapes.length]
  end

  def rotateAngle
    sketch_control.rotation.to_i / 360.0 * TWO_PI
  end

  def rotateVariationAngle
    sketch_control.rotateVariation.to_i / 360.0 * TWO_PI
  end

  def drawPattern
    # no_fill
    fill(shapeColor)
    stroke(strokecolor)


    0.upto(height / (shapeHeight+spacingY)) do |row|
      0.upto(width / (shapeWidth+spacingX)) do |col|
        x = col * (shapeWidth+spacingX) - random(shapeOffset)
        y = row * (shapeHeight+spacingY) - random(shapeOffset)
        w = shapeWidth + random(shapeOffset)
        h = shapeHeight + random(shapeOffset)

        pushMatrix
          translate(x,y, sketch_control.spacingZ.to_i + random(sketch_control.shapeOffsetZ.to_i))
          rotate(rotateAngle+random(rotateVariationAngle))
          
          if shapeName == :rectangle
            rect(0,0 , w, h)
          elsif shapeName == :circle
            ellipse(0,0, w, h)
          elsif shapeName == :triangle
            triangle(0,0, w, h, 0, h)
            x = random(shapeOffset)
            y = random(shapeOffset)
            w = shapeWidth + random(shapeOffset)
            h = shapeHeight + random(shapeOffset)
            triangle(x,y, x+w,y+h, x+w,y)
          elsif shapeName == :triangle2
            if col.odd?
              triangle(0,0, w,0,  w*0.5,h)
            else
              triangle(0,h, w,h,  w*0.5,0)
            end
          elsif shapeName == :typo1
            if col.odd?
              triangle(0,0, w,y,  w*0.5,h)
            else
              triangle(0,h, w,h,  w*0.5,0)
            end
          elsif shapeName == :typo2
            triangle(0,0, w, h, x, h)
            x = random(shapeOffset)
            y = random(shapeOffset)
            w = shapeWidth + random(shapeOffset)
            h = shapeHeight + random(shapeOffset)
            triangle(x,y, x+w,y+h, x+w,y)
          elsif shapeName == :cross
            # noStroke
            stroke(strokecolor)
            ww = w.to_f / 3
            hh = h.to_f / 3
            rect(0, hh, w, hh)
            rect(ww, 0, ww, h)
            noStroke
            rect(1, hh, w-2, hh-1)
          end

        popMatrix
      end
    end
  end
end

class SketchController
  include Processing::Proxy
  include SketchControl

  attr_reader :options
  attr_reader :bgcolor, :strokecolor, :shapecolor, :shapeWidth, :shapeOffset,
    :shapeHeight, :rotation, :rotateVariation, :spacingX, :spacingY, :spacingZ, :shapeOffsetZ

  def initialize(_opts = {})
    @options = _opts || {}
    setup_controls
  end

  def setup_controls
    sketch_controls do |c|
      c.title = "Sketch Controls Panel"

      c.slider :label => :shapeWidth, :min => 0, :max => 300
      c.slider :label => :shapeHeight, :min => 0, :max => 300
      c.slider :label => :spacingX, :min => 0, :max => 300
      c.slider :label => :spacingY, :min => 0, :max => 300
      c.slider :label => :spacingZ, :min => -300, :max => 300
      c.slider :label => :shapeOffset, :min => 0, :max => 300
      c.slider :label => :shapeOffsetZ, :min => 0, :max => 300

      c.slider :label => :rotation, :min => 0, :max => 360
      c.slider :label => :rotateVariation, :min => 0, :max => 360

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
