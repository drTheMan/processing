require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'class_options'))
require 'rubygems'
require 'bundler/setup'
require 'sketch_control'
require 'sketch_control/control_panel'


class PyramidApp < Processing::App
  # load_library :control_panel

  attr_reader :options

  def initialize(_opts = {})
    super
    @options = _opts.is_a?(Hash) ? _opts : {}
  end

  def setup
    frameRate(2)
    size(800, 800, P3D);
    sketch_control
    # smooth();
  end    

  def key_pressed
    # screenshot
    # save_frame if key_code == ENTER
    saveFrame("line-###.png") if key_code == ENTER
    @paused = (@paused != true) if key == ' '
    @variation = @variation.to_i + 1 if key == '/'
  end

  def sketch_control
    @sketch_control ||= SketchController.new
  end

  def bgcolor
    sketch_control.bgcolor || color(255,255,255)
  end

  def pyramids
    [Pyramid.new(
      :layer_count => sketch_control.layer_count,
      :fatness => sketch_control.fatness,
      :squareSize => sketch_control.squareSize,
      :deltaZ => sketch_control.deltaZ,
      :spacing => sketch_control.spacing,
      :layerRotation => sketch_control.layerRotation,
      :shape => sketch_control.shape
      )]
  end

  def draw
    if @paused != true
      background bgcolor

      noFill
      noStroke

      pyramids.each(&:draw)
    end
  end


  class Pyramid
    attr_reader :options

    def initialize(_opts = {})
      @options = _opts.is_a?(Hash) ? _opts : {}
    end

    def layer_count
      options[:layer_count] || 5
    end

    def layers
      @layers ||= layer_count.downto(1).to_a.map{|no| PyramidLayer.new(options.merge(:layer => no))}
    end

    def draw
      layers.each(&:draw)
    end
  end

  class PyramidLayer
    attr_reader :options

    def initialize(_opts = {})
      @options = _opts.is_a?(Hash) ? _opts : {}
    end

    def layer
      options[:layer] || 1
    end

    def index
      layer - 1
    end

    def cols
      options[:cols] || layer
    end

    def rows
      options[:rows] || layer
    end

    def fatness
      options[:fatness] || 1
    end

    def squareSize
      options[:squareSize] || 100
    end

    def zPos
      (options[:deltaZ] || 0) * index
    end

    def squareWidth
      squareSize
    end

    def squareHeight
      squareSize
    end

    def squareSpacing
      options[:spacing] || 10
    end

    def bounding_width
      cols * squareWidth + (cols - 1) * squareSpacing
    end

    def bounding_height
      rows * squareHeight + (rows - 1) * squareSpacing
    end

    def draw
      pushMatrix
        translate(width/2, height/2)
        rotate(options[:layerRotation] * index) if options[:layerRotation]
        translate(-bounding_width * 0.5, -bounding_width * 0.5, zPos)

        0.upto(rows-1) do |row|
          0.upto(cols-1) do |col|
            if (options[:shape] || 1) == 1
              drawSquare(row, col)
            elsif options[:shape].to_i == 2
              drawCircle(row, col)
            end
          end
        end

      popMatrix
    end

    def drawSquare(row, col)
      x = (squareWidth + squareSpacing) * col
      y = (squareHeight + squareSpacing) * row
      f = fatness
      f = squareWidth if squareWidth < f
      f = squareHeight if squareHeight < f

      fill(0,0,0)
      rect(x, y, squareWidth, squareHeight)
      fill(255,255,255)
      rect(x+f, y+f, squareWidth-f*2, squareHeight-f*2)
    end

    def drawCircle(row, col)
      x = (squareWidth + squareSpacing) * col + squareWidth/2
      y = (squareHeight + squareSpacing) * row + squareHeight/2
      f = fatness
      f = squareWidth if squareWidth < f
      f = squareHeight if squareHeight < f

      fill(0,0,0)
      ellipse(x, y, squareWidth, squareHeight)
      fill(255,255,255)
      ellipse(x, y, squareWidth-f*2, squareHeight-f*2)
    end
  end


end



class SketchController
  include Processing::Proxy
  include SketchControl

  attr_reader :options
  attr_reader :bgcolor, :fatness, :squareSize, :layer_count, :deltaZ, :spacing, :layerRotation, :shape

  def initialize(_opts = {})
    @options = _opts || {}
    setup_controls
  end

  def setup_controls
    sketch_controls do |c|
      c.title = "Sketch Controls Panel"

      c.slider :label => :shape, :min => 1, :max => 2
      c.slider :label => :layer_count, :min => 1, :max => 50
      c.slider :label => :fatness, :min => 0, :max => 300
      c.slider :label => :squareSize, :min => 0, :max => 500
      c.slider :label => :deltaZ, :min => -300, :max => 300
      c.slider :label => :spacing, :min => -100, :max => 300
      c.slider :label => :layerRotation, :min => 0, :max => TWO_PI
      # c.slider :label => :spacingY, :min => 0, :max => 300
      # c.slider :label => :shapeOffset, :min => 0, :max => 300
      # c.slider :label => :rotation, :min => 0, :max => 360
      # c.slider :label => :rotateVariation, :min => 0, :max => 360

      c.rgb :background do |value|
        @bgcolor = value #puts "Sketch got: #{value} from background slider"
      end

      # c.rgb :stroke do |value|
      #   @strokecolor = value #puts "Sketch got: #{value} from background slider"
      # end

      # c.rgb :shape do |value|
      #   @shapecolor = value #puts "Sketch got: #{value} from background slider"
      # end
    end
  end
end

opts = {}
# if ARGV.include?('--squares')
# opts[:pattern => :squares]
PyramidApp.new(opts)
