Grid grid;

ArrayList<PVector> cursors;
ArrayList<PVector> velocities;

static int COLS = 32;
static int ROWS = 24;

static int CELLW = 30;
static int CELLH = 30;

void setup() {
  size(1000,800, P3D);
//  ortho(0, width, 0, height);
  fill(255, 255, 255);
  noStroke();

  grid = new Grid(COLS, ROWS, CELLW, CELLH);
  grid.pos.x = (width - CELLW * COLS + CELLW) / 2 ;
  grid.pos.y = (height - CELLH * ROWS + CELLH) / 2;
  
  cursors = new ArrayList<PVector>();
  velocities = new ArrayList<PVector>();
  
  for(int i = 0; i < 3; i++){
    cursors.add(new PVector(random(width), random(height), 0));
    velocities.add(new PVector(5.0 - random(10.0), 5.0 - random(10.0), 0));
  }
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
