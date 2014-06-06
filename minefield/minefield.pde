Grid grid;

ArrayList<Cursor> cursors;

static int COLS = 35;
static int ROWS = 25;

static int CELLW = 27;
static int CELLH = 27;

void setup() {
  size(1000,800, P3D);
  //  ortho(0, width, 0, height);

  // create list to hold all cursor objects
  // fill the list with a bunch of cursor objects; some autonomoous moving objects
  cursors = new ArrayList<Cursor>();
  for(int i = 0; i < 3; i++) cursors.add(new Cursor());
  // add one more cursor object; this one will follow the user's mouse
  cursors.add(new Cursor(new PVector(mouseX, mouseY, 0), new PVector(0,0,0)));

  // create the grid object and pass it a sprite object for the animations
  grid = new Grid(COLS, ROWS, CELLW, CELLH, cursors, new Sprite("flipFrame", 31));
  // modify the grid's x and y position to center it in our window
  grid.pos.x = (width - CELLW * COLS + CELLW) / 2 ;
  grid.pos.y = (height - CELLH * ROWS + CELLH) / 2;
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


