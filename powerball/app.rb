require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'class_options'))

class CirclesApp < Processing::App
  # load_library :control_panel


  def setup
    size(400, 400, P3D);
    # smooth();
    # frame_rate(4)

    stroke(color(0,0,0))
  end

  def draw
    background(0,0,0)

    powerball.draw
    shiners.each(&:draw)

    powerball.rotation_y += PI*0.01
    shiners.each{|shiner| shiner.rotation_y = powerball.rotation_y}
  end

  def mouse_clicked
  end

  def key_pressed
    powerball.line_count += 1 if key_code == UP
    powerball.line_count -= 1 if key_code == DOWN
    shiners.each{|shiner| shiner.line_count = powerball.line_count}
  end

  def powerball
    @powerball ||= Powerball.new(:x => width/2, :y => height/2)
  end

  def shiners
    @shiners ||= [
      Shiner.new(:x => powerball.x, :y => powerball.y-powerball.height/2),
      Shiner.new(:x => powerball.x, :y => powerball.y+powerball.height/2)
    ]
  end


  class Powerball
    include ClassOptions

    def x
      options[:x] || 0
    end

    def y
      options[:y] || 0
    end

    def z
      options[:z] || 0
    end

    def width
      options[:width] || options[:diameter] || 100
    end

    def height
      options[:height] || options[:diameter] || 100
    end

    def rotation_y
      @rotation_y ||= 0
    end

    attr_writer :rotation_y

    def line_count
      @line_count || options[:line_count] || 10
    end

    attr_writer :line_count

    def line_rotate_distance
      PI / line_count
    end

    def clr
      @clr ||= color(255,100,100, 200)
    end

    def draw
      no_fill
      stroke clr

      pushMatrix
        translate x, y, z
        rotate_y rotation_y

        1.upto(line_count-1) do |i|
          rotate_y line_rotate_distance
          ellipse 0, 0, width, height
        end
      popMatrix
    end

  end # of class PowerBall



  class Shiner
    include ClassOptions

    def x
      options[:x] || 0
    end

    def y
      options[:y] || 0
    end

    def z
      options[:z] || 0
    end

    def rotation_y
      @rotation_y ||= 0
    end

    attr_writer :rotation_y

    def clr
      @clr ||= color(255,100,100, 200)
    end

    def line_count
      @line_count || options[:line_count] || 10
    end

    attr_writer :line_count

    def line_rotate_distance
      PI / line_count
    end

    def draw
      no_fill
      stroke clr

      pushMatrix
        translate x, y, z
        rotate_y rotation_y

        1.upto(line_count) do |i|
          rotate_y line_rotate_distance
          line(0, 0, 0, 100, rise_for_line(i-1), 0)
          line(0, 0, 0, -100, rise_for_line(i-1), 0)
        end
      popMatrix
    end

    attr_writer :rrot

    def rise_for_line(line_index)
      sin((rotation_y+line_rotate_distance*line_index)*3+millis/50) * 15
    end

  end # of class Shine

end

CirclesApp.new
