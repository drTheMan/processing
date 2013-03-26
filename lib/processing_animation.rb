require File.expand_path(File.join(File.dirname(__FILE__), 'class_options'))

module ProcessingAnimation

	include ClassOptions

  def draw
    # pushMatrix
      # do whatever to get on the screen
    # popMatrix
  end

  def step
    # do whatever to get to the next frame
    @current_frame = current_frame + 1
  end

  # convenient method
  def animate
    draw
    step
  end

  def current_frame
  	@current_frame ||= options[:current_frame] || 0
  end

end # of module ProcessingAnimation