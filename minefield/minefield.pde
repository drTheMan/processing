Grid grid;
Sprite flipSprite;

ArrayList<Cursor> cursors;

static int COLS = 35;
static int ROWS = 25;

static int CELLW = 27;
static int CELLH = 27;

void setup() {
  size(1000,800, P3D);
//  ortho(0, width, 0, height);
  fill(255, 255, 255);
  noStroke();

  cursors = new ArrayList<Cursor>();
  
  for(int i = 0; i < 3; i++){
    cursors.add(new Cursor());
  }

  cursors.add(new Cursor(new PVector(mouseX, mouseY, 0), new PVector(0,0,0)));

  grid = new Grid(COLS, ROWS, CELLW, CELLH, cursors);

  grid.pos.x = (width - CELLW * COLS + CELLW) / 2 ;
  grid.pos.y = (height - CELLH * ROWS + CELLH) / 2;

  flipSprite = new Sprite("flipFrame", 31);
}

void draw() {
  background(0);
  
  
  grid.cursors.get(grid.cursors.size()-1).position = new PVector(mouseX, mouseY, 0);
  grid.cursors.get(grid.cursors.size()-1).radius = mousePressed ? 200 : 30;
  grid.draw();
  grid.moveCursors(new PVector(width, height,0));
}

void keyPressed(){
  if(key == ENTER) saveFrame("screen-####.png");
}


