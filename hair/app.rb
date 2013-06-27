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

def drawSettingSketches
  # return exit if !sketch
  # sketch.draw
  
  # puts "Sketch: #{(@sketch_index || 0)+1}/#{SETTINGS.length} - Progress: #{sketch.finished_points_count}/#{sketch.total_points}"
end


def random_color
  color(rand(255), rand(255), rand(255))
end

def sketchA
  @sketchA ||= HairSketch.new(:total_points => 2000, :color => random_color)
end

def sketchB
  @sketchB ||= HairSketch.new(sketchA.options.merge(:color => random_color, :noise => sketchA.noise, :noise_offset_y => 0.2))
end

def sketches
  [sketchA, sketchB]
end

def drawCombo
  sketches.each do |sketch|
    sketch.draw
  end

  saveFrame("hair-######-#{sketchA.finished_points_count+sketchB.finished_points_count}paths.png") if (frameCount+100) % 500 == 0
end


def drawAnimated
  @animSketch = sketchA if !@animSketch
  @count ||= 1

  if @animSketch.finished?
    saveFrame("hair-######-offset#{@animSketch.options[:pace_shift] || 0}.png")
    clearCanvas
    @animSketch = HairSketch.new(@animSketch.options.merge(:pace_shift => (@animSketch.options[:pace_shift] || 0)+0.1, :noise => @animSketch.noise))
    @count += 1
  end

  @animSketch.draw
  puts "Sketch: #{@count}, Paths finished: #{@animSketch.finished_points_count}"
end

def draw
  drawAnimated
end

def clearCanvas
  background(255)
end

def keyPressed
  if key_code == ENTER
    clearCanvas
    sketch.reset_points
    sketches.each(&:reset_points)
  end

  sketch.add_points if key == 'm'

  saveFrame("hair-f######.png") if key == 'p'
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
    @noise_cache ||= (options[:noise] || Perlin::Noise.new(2, :curve => Perlin::Curve::CUBIC))
  end

  def step_size
    options[:step_size] || 500
  end

  def add_point
    @points ||= []
    @points << Point.new(options.merge(
      :x => rand(width),
      :y => rand(height),
      :max_speed => 1))
      # :factor => options[:factor],
      # :cycle => options[:cycle],
      # :color => options[:color],
      # :noise_factor => options[:noise_factor],
      # :noise_offset => options[:noise_offset],
      # :noise_offset_x => options[:noise_offset_x],
      # :noise_offset_y => options[:noise_offset_y]))
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

  def clr
    options[:color] || 0
  end

  def update n2d
    step n2d
    draw
  end

  def noise_factor
    options[:noise_factor] || 0.01
  end

  def noise_offset_x
    options[:noise_offset_x] || noise_offset
  end

  def noise_offset_y
    options[:noise_offset_y] || noise_offset
  end

  def noise_offset
    options[:noise_offset] || 0
  end

  def cycle_offset
    options[:cycle_offset] || 0
  end

  def cycle_offset_x
    options[:cycle_offset_x] || cycle_offset
  end

  def cycle_offset_y
    options[:cycle_offset_y] || cycle_offset
  end

  def nx
    x * noise_factor + noise_offset_x
  end

  def ny
    y * noise_factor + noise_offset_y
  end

  def noise_value(n2d)
    options[:pace_shift] ? ((n2d[nx, ny] + options[:pace_shift]) % 1) : n2d[nx, ny]
  end

  def step n2d
    @xv = cos(noise_value(n2d) * (options[:cycle] || TWO_PI) + cycle_offset_x) * (options[:factor] || 1)
    @yv = sin(noise_value(n2d) * (options[:cycle] || TWO_PI) + cycle_offset_y) * (options[:factor] || 1)

    @xv = max_speed if xv > max_speed
    @xv = -max_speed if xv < -max_speed
    @yv = max_speed if (yv>max_speed)
    @yv = -max_speed if (yv < -max_speed)

    @x = x + xv
    @y = y + yv
  end

  def draw
    stroke(clr, 16)
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