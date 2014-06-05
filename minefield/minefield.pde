Grid grid;

ArrayList<PVector> cursors;
ArrayList<PVector> velocities;


void setup() {
  size(600,450, P3D);
//  ortho(0, width, 0, height);
  fill(255, 255, 255);
  noStroke();

  grid = new Grid();
  cursors = new ArrayList<PVector>();
  velocities = new ArrayList<PVector>();
  
  cursors.add(new PVector(0,0,0));
  velocities.add(new PVector(random(5.0), random(5.0), 0));
  
  cursors.add(new PVector(random(width), random(height), 0));
  velocities.add(new PVector(5.0 - random(10.0), 5.0 - random(10.0), 0));
}

void draw() {
  background(0);

  ArrayList<PVector> pvecs = (ArrayList<PVector>)cursors.clone();
  pvecs.add(new PVector(mouseX, mouseY, 0));
  grid.draw(pvecs);

  for (int ic = cursors.size()-1; ic >= 0; ic--) {
    PVector cursor = cursors.get(ic);
    PVector velocity = velocities.get(ic);
    cursor.add(velocity);
    
    if((cursor.x < 0 && velocity.x < 0) || (cursor.x > width && velocity.x > 0)) velocity.x = -velocity.x;
    if((cursor.y < 0 && velocity.y < 0) || (cursor.y > height && velocity.y > 0)) velocity.y = -velocity.y;
  }
}

void keyPressed(){
  if(key == ENTER) saveFrame("screen-####.png");
}
