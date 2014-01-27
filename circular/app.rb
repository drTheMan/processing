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
    @path ||= Squarer.new(:origin => PVector.new(width*0.5, height*0.5), :main => self)
  end

  def update
    # path.size = sketch_control.size
    path.move(0.05)
  end

  def draw
    update

    # clear screen
    background bgcolor
    path.draw
  end

  def key_pressed
    save_frame if key_code == ENTER # screenshot

    if key_code == TAB
      if path.is_a?(Circular)
        @path = Squarer.new(:origin => path.origin, :position => path.position, :main => path.main)
      elsif path.is_a?(Squarer)
        @path = Circular.new(:origin => path.origin, :position => path.position, :main => path.main)
      end
    end
  end

  module Path
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
      @angle ||= options[:angle] || calculate_angle || 0
    end

    def move(amount)
      @angle = angle + amount
    end

    def size
      @size ||= options[:size] || calculate_size || 100
    end

    def draw
      p = position
      main.ellipse(p.x, p.y, 20, 20)
    end

    def calculate_size
      return nil
    end

    def calculate_angle
      return nil if !options[:position]
      # somewhere on the right half
      if options[:position].x >= origin.x
        if options[:position].y < origin.y
          return atan( (options[:position].x - origin.x) / (origin.y - options[:position].y) )
        end

        return Processing::App::PI*0.5 + atan( (options[:position].y - origin.y) / (options[:position].x - origin.x) )
      end

      if options[:position].y < origin.y
        return Processing::App::TWO_PI*2.0 - atan( (origin.x - options[:position].x) / (origin.y - options[:position].y) )
      end

      return Processing::App::PI + atan( (origin.x - options[:position].x) / (options[:position].y - origin.y) )
    end

  end # of module Path


  class Circular
    include Path

    def position
      position = PVector.new(0, -size)
      position.rotate(angle)
      position.add(origin)
      return position
    end

    def calculate_size
      return nil if !options[:position]
      options[:position].dist(origin)
    end
  end # of class Circular

  class Squarer
    include Path

    def position
      pos = PVector.new(0, -size)
      pos.rotate(angle)
      multiplier = (size / (main.abs(pos.x) > main.abs(pos.y) ? main.abs(pos.x) : main.abs(pos.y)))
      pos.mult(multiplier)
      pos.add(origin)
      return pos
    end

    def calculate_size
      return nil if !options[:position]
      x = main.abs(options[:position].x - origin.x)
      y = main.abs(options[:position].y - origin.y)
      return x > y ? x : y
    end
  end # of class Squarer

  class Triangular
    include Path

    def position
      # pos = PVector.new(0, -size)
      # pos.rotate(angle)
      # multiplier = (size / (main.abs(pos.x) > main.abs(pos.y) ? main.abs(pos.x) : main.abs(pos.y)))
      # pos.mult(multiplier)
      # pos.add(origin)
      # return pos
    end

    def calculate_size
      return nil if !options[:position]
      x = main.abs(options[:position].x - origin.x)
      y = main.abs(options[:position].y - origin.y)
      return x > y ? x : y
    end
  end # of class Squarer

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
end



CircularApp.new :title => "Circular", :width => 400, :height => 400