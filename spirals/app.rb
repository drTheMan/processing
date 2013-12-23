require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'class_options'))
require 'rubygems'
# require 'bundler/setup'
# require 'sketch_control'
# require 'sketch_control/control_panel'


class SpiralsApp < Processing::App
  # load_library :control_panel

  attr_reader :options

  def setup
    size(400, 400, P3D);

    smooth
    background bgcolor
    noStroke
    frameRate(5)
    @options = {:steps => 200, :min_size => 10, :max_size => 390}
  end    

  def key_pressed
    # screenshot
    save_frame if key_code == ENTER
  end

  def current_step
    @current_step ||= 0
  end

  def random_color
    color(random(255), random(255), random(255))
  end

  def step_color
    # color(*([current_step*2]*3))
    random_color
  end

  def step_delta_size
    (options[:max_size] - options[:min_size]) * 1.0 / options[:steps]
  end

  def step_size
    options[:max_size] - step_delta_size * current_step
  end

  def step_delta_angle
    TWO_PI * 1.0 / options[:steps]
  end

  def step_min_angle
    0
  end

  def step_max_angle
    TWO_PI - step_delta_angle * current_step
  end

  def bgcolor
    color(255,255,255)
  end

  def draw
    drawCurrentStep
    @current_step = current_step + 1
  end

  def drawCurrentStep
    return if current_step >= options[:steps]
    fill(step_color)
    arc(
      width * 0.5,
      height * 0.5,
      step_size,
      step_size,
      step_min_angle,
      step_max_angle)
  end
end

SpiralsApp.new