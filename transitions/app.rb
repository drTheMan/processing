require 'rubygems'
require 'bundler/setup'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'class_options'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'processing_animation'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'processing_object'))

class TunnelApp < Processing::App

  def setup
    size(800, 600, P3D);
    smooth();
    frame_rate(24)
    background color(0,0,0)
  end

  def next_color
    @next_color = @next_color == nil || blue(@next_color) == 0 ? color(255,255,255) : color(0,0,0)
  end

  def generate_breakers
    clr = next_color

    [
      Breaker.new(:object => {:x => 0, :y => 0, :width => width*0.5, :height => height}, :fill_color => clr),
      Breaker.new(:object => {:x => width * 0.5, :y => 0, :width => width*0.5, :height => height, :rotation => PI}, :fill_color => clr)
    ]
  end

  def breakers
    @breakers ||= generate_breakers
  end

  def draw
    breakers.reject!(&:done?)
    breakers.each(&:animate)
    # @breakers = generate_breakers if breakers.reject(&:done?).empty?
    if frameCount % 36 == 0
      @breakers += generate_breakers
    end
  end


  class Breaker
    include ProcessingAnimation
    include ProcessingObject

    def step
      move_vertices
    end

    def draw
      no_stroke
      fill fill_color

      pushMatrix
        translate object.x + object.width*0.5, object.y + object.height*0.5
        rotateZ object.rotation
        translate -0.5 * object.width, -0.5 * object.height
  
        begin_shape
          vertex object.width, 0
          vertices.each{|vertex| vertex vertex.x, vertex.y}
          vertex object.width, object.height-1
        end_shape
      popMatrix
    end

    def unfinished_vertices
      vertices.find_all{|vertex| vertex.x >= 0 && vertex.y >= 0 && vertex.x <= object.width && vertex.y <= object.height}
    end

    def done?
      unfinished_vertices.empty?
    end

    # options

    def vertex_count
      @vertex_count ||= options[:vertex_count] || random(2, 25)
      return @vertex_count < 2 ? 2 : @vertex_count
    end

    def fill_color
      @fill_color ||= options[:fill_color] || color(random(0, 255), random(0, 255), random(0, 255))
    end

    def vertices
      @vertices ||= generate_vertices
    end

    private

    def generate_vertices
      [0, 2.upto(vertex_count-1).to_a.map{|y| random(1, object.height-1).to_i}.sort, object.height-1].flatten.map{|y| Vertex.new(:x => object.width-1, :y => y)}
    end

    def move_vertices
      # vertices.each(&:move_left)

      if vertex = unfinished_vertices[random(0, unfinished_vertices.length).to_i]
        vertex.move_left
      end
    end
  end # of class Breaker



  class Vertex

    include ClassOptions

    def x
      @x ||= options[:x] || 0
    end

    def y
      @y ||= options[:y] || 0
    end

    attr_writer :x, :y

    def move_left
      # @x = random(0, x - 1)
      @x = x - random(100)
      # @x = 0 if @x < 0
    end

  end # of class Vertex
end

TunnelApp.new
