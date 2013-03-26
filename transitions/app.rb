require 'rubygems'
require 'bundler/setup'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'class_options'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'processing_animation'))

class TunnelApp < Processing::App

  def setup
    size(800, 600, P3D);
    smooth();
    frame_rate(4)
    background color(0,0,0)
  end

  def generate_breaker
    Breaker.new(:w => width, :h => height)
  end

  def breaker
    @breaker ||= generate_breaker
  end

  def draw
    breaker.animate
    @breaker = generate_breaker if breaker.done?
  end


  class Breaker
    include ProcessingAnimation

    def step
      move_vertices
    end

    def draw
      fill fill_color
      stroke color(255,0,0)

      begin_shape
        vertex 0,0
        vertices.each{|vertex| vertex vertex.x, vertex.y}
        vertex 0, h-1
      end_shape
    end

    def unfinished_vertices
      vertices.find_all{|vertex| vertex.x < w}
    end

    def done?
      unfinished_vertices.empty?
    end

    # options

    def vertex_count
      @vertex_count ||= options[:vertex_count] || random(2, 10)
      return @vertex_count < 2 ? 2 : @vertex_count
    end

    def fill_color
      @fill_color ||= options[:fill_color] || color(random(0, 255), random(0, 255), random(0, 255))
    end

    def w
      @w ||= options[:w] || width
    end

    def h
      @h ||= options[:h] || height
    end

    def vertices
      @vertices ||= generate_vertices
    end

    private

    def generate_vertices
      [0, 2.upto(vertex_count-1).to_a.map{|y| random(1, height-1).to_i}, h-1].flatten.map{|y| Vertex.new(:x => 0, :y => y)}
    end

    def move_vertices
      vertices.each{|vertex| vertex.x = random(vertex.x + 1, width)}
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

  end # of class Vertex
end

TunnelApp.new
