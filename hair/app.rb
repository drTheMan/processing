require 'rubygems'
require 'bundler/setup'
require 'perlin_noise'

SETTINGS = [
  # {:total_points => 500, :step_size => 50},
  # {:total_points => 1000, :step_size => 50},
  # {:total_points => 1000, :step_size => 50},
  # {:total_points => 500, :step_size => 50, :factor => 3},
  # {:total_points => 1000, :step_size => 50, :factor => 3},
  # {:total_points => 1000, :step_size => 50, :factor => 3},
  # {:total_points => 500, :step_size => 50, :factor => 10},
  # {:total_points => 1000, :step_size => 50, :factor => 10},
  # {:total_points => 1000, :step_size => 50, :factor => 10},
  # {:total_points => 500, :step_size => 1},
  # {:total_points => 500, :step_size => 50, :cycle => 1},
  # {:total_points => 1000, :step_size => 50, :cycle => 1},
  # {:total_points => 1000, :step_size => 50, :cycle => 1},
  # {:total_points => 500, :step_size => 50, :cycle => PI},
  # {:total_points => 1000, :step_size => 50, :cycle => PI},
  # {:total_points => 1000, :step_size => 50, :cycle => PI},
  # {:total_points => 500, :step_size => 50, :cycle => TWO_PI * 2.0},
  # {:total_points => 1000, :step_size => 50, :cycle => TWO_PI * 2.0},
  # {:total_points => 1000, :step_size => 50, :cycle => TWO_PI * 2.0},
  # {:total_points => 5000, :step_size => 10}
  # {:total_points => 5000, :step_size => 500, :factor => 10}
  {:total_points => 5000, :step_size => 500, :factor => 1},
  {:total_points => 5000, :step_size => 500, :factor => 2},
  {:total_points => 5000, :step_size => 500, :factor => 3},
  {:total_points => 5000, :step_size => 500, :factor => 4},
  {:total_points => 5000, :step_size => 500, :factor => 5},
  {:total_points => 5000, :step_size => 500, :factor => 6},
  {:total_points => 5000, :step_size => 500, :factor => 7},
  {:total_points => 5000, :step_size => 500, :factor => 8},
  {:total_points => 5000, :step_size => 500, :factor => 9}
]

def setup
  size(800, 600)
  background(255)
  smooth #(8)
  noise_detail(8,0)
end

def current_settings
  SETTINGS[@sketch_index ||= 0]
end

def sketch
  @sketch ||= HairSketch.new(current_settings)

  if @sketch.finished?
    clearCanvas
    @sketch_index += 1

    if current_settings == nil
      puts 'done'
      return nil 
    end

    puts 'next sketch'
    @sketch = HairSketch.new(current_settings)
  end

  return @sketch    
end

def draw
  return exit if !sketch
  sketch.draw
  saveFrame("######-ttl5000-finished#{sketch.finished_points_count}.png") if frameCount % 50 == 0
  puts "Sketch: #{(@sketch_index || 0)+1}/#{SETTINGS.length} - Progress: #{sketch.finished_points_count}/#{sketch.total_points}"
end



def clearCanvas
  background(255)
end

def keyPressed
  if key_code == ENTER
    clearCanvas
    sketch.reset_points
  end

  sketch.add_points if key == 'm'
end


class HairSketch
  include Processing::Proxy

  def initialize(_opts = {})
    @options = _opts
    add_points
  end

  def options
    @options || {}
  end

  def noise
    @noise_cache ||= Perlin::Noise.new 2, :curve => Perlin::Curve::CUBIC
  end

  def step_size
    options[:step_size] || 500
  end

  def add_point
    @points ||= []
    @points << Point.new(:x => rand(width), :y => rand(height), :max_speed => 1, :factor => options[:factor], :cycle => options[:cycle])
  end

  def add_points(amount = nil)
    (amount || step_size).times do
      add_point
    end

  end

  def reset_points
    @points = []
  end

  def points
    @points || []
  end

  def active_points_count
    points.length
  end

  def finished_points_count
    @finished_points_count ||= 0
  end

  def idle?
    active_points_count == 0
  end

  def total_points
    options[:total_points] || (step_size * 10)
  end

  def finished?
    finished_points_count >= total_points
  end

  def draw
    points.each_with_index do |point, i|
      point.update noise
      if point.finished?
        points.delete_at(i)
        @finished_points_count = finished_points_count+1
      end
    end

    if idle?
      # saveFrame("######-factor#{options[:factor] || 1}-cycle#{options[:cycle] || TWO_PI}-ttl#{total_points}-finished#{finished_points_count}.png")
      add_points if !finished?
    end
  end

end # of class HairSketch


class Point
  include Processing::Proxy

  MAX_SPEED = 3000000

  def initialize(_opts = {})
    @options = _opts
  end

  def options
    @options || {}
  end

  def x 
    @x ||= options[:x] || 0
  end

  def y
    @y ||= options[:y] || 0
  end

  def xv
    @xv ||= 0
  end

  def yv
    @yv ||= 0
  end

  def finished?
    x > width || x < 0 || y < 0 || y > height
  end

  def width
    options[:width] || $app.width
  end

  def height
    options[:height] || $app.height
  end

  def max_speed
    options[:max_speed] || MAX_SPEED
  end

  def update n2d
    step n2d
    draw
  end

  def step n2d
    @xv = cos(n2d[x * 0.01, y * 0.01] * (options[:cycle] || TWO_PI)) * (options[:factor] || 1)
    @yv = sin(n2d[x * 0.01, y * 0.01] * (options[:cycle] || TWO_PI)) * (options[:factor] || 1)

    @xv = max_speed if xv > max_speed
    @xv = -max_speed if xv < -max_speed
    @yv = max_speed if (yv>max_speed)
    @yv = -max_speed if (yv < -max_speed)

    @x = x + xv
    @y = y + yv
  end

  def draw
    stroke(0, 16)
    line(x + xv, y + yv, x, y )
  end

  # this doesn't work very smooth
  def complete(n2d, max_frames = 300)
    i = 0
    while !finished? && i < max_frames
      step n2d
      draw
      i+=1
    end
  end
end