Grid grid;

void setup() {
  size(640,360, P3D);
  
  fill(255, 255, 255);
  noStroke();
  grid = new Grid();
}

void draw() {
  background(0);
  grid.draw(new PVector(mouseX, mouseY, 0));
}

void keyPressed(){
  if(key == ENTER) saveFrame("screen-####.png");
}
