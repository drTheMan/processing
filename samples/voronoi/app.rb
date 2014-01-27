load_libraries 'mesh', 'control_panel'
import 'megamu.mesh.Voronoi'

attr_reader :voronoi, :img, :ready, :upper, :lower, :lowskip, :highskip, :show, :points, :load_file

def setup() 
 size(600, 600) 
 frame_rate(10)
 #no_cursor()
 @ready = false
 @show = false
 @load_file = true
 setup_control
 @points = Array.new
 puts("done setup")
end

def setup_control
  control_panel do |c|
    c.title = "Control Panel"
    c.slider :upper, 50..255, 200
    c.slider :lower, 0..205, 150
    c.slider :lowskip, 1..20, 1
    c.slider :highskip, 1..20, 7
    c.button :change_image
    c.button :Go
    c.button :view_image
    c.button :save_voronoi
  end
end

def draw() 
  background(0)
  stroke(128)
  if (load_file)
    no_loop
    file = select_input("Choose Image File")
    @img = load_image(file)
    @load_file = false
    loop
  end
  if (ready) 
    display_voronoi
  end
  if(show && img)
    tint(255,100)
    image(img,0,0)
  end
end

def get_all_points()
  x_array = Array.new  # random array of x points
  y_array = Array.new  # random array of y points
  x = 0
  y = 0

  while(x < (width - highskip))
    x_array.push(x)
    x += rand(highskip) + lowskip
  end

  while(y < (height - highskip))
    y_array.push(y)
    y += rand(highskip) + lowskip
  end

  x_array.each do |pos_x|
    y_array.each do |pos_y|
      b = brightness(img.get(pos_x, pos_y))
      if (b <= upper && b >= lower) 
        @points.push([pos_x, pos_y])
      end
    end
  end
  puts("total #{points.size()}")
end

def display_voronoi
  regions = voronoi.get_regions
  stroke(128)
  fill(0)   
  regions.each do |region|
    region_coordinates = region.get_coords
    region.draw(self)
  end

  edges = voronoi.get_edges
   
  edges.each do |edge|
    x0 = edge[0]
    y0 = edge[1]
    x1 = edge[2]
    y1 = edge[3]
    line(x0, y0, x1, y1)
  end

  fill(128)
  no_stroke
end

def mouse_pressed() 
  no_loop 
  b = brightness(img.get(mouse_x, mouse_y)) if img
  puts "Brightness = #{b}"
  loop
end

def Go() 
  no_loop 
  @ready = false
  @points.clear
  get_all_points if img
  @voronoi = Voronoi.new(@points.to_java(Java::float[]))
  @ready = true
  loop
end

def save_voronoi
  no_loop
  save_frame
  puts "finished!"
  loop
end

def change_image
  @load_file = !load_file       
end
def view_image
  @show = !show
end