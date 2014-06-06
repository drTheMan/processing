class Grid{
  PVector pos, cellDimensions;
  PVector dimensions;
  ArrayList<Cursor> cursors;
  Sprite sprite;
  
  Grid(){
    init(10, 10, 30, 30, new ArrayList<Cursor>(), new Sprite());
  }

  Grid(int columns, int rows, int colWidth, int rowHeight, ArrayList<Cursor> _cursors, Sprite _sprite){
    init(columns, rows, colWidth, rowHeight, _cursors, _sprite);
  }

  void init(int columns, int rows, int colWidth, int rowHeight, ArrayList<Cursor> _cursors, Sprite _sprite){
    cellDimensions = new PVector(colWidth, rowHeight, 2);
    dimensions = new PVector(columns, rows, 1);

    pos = new PVector(cellDimensions.x*0.5,cellDimensions.y*0.5, 0);
    cursors = _cursors;
    sprite = _sprite;
  }

  void draw(ArrayList<Cursor> _cursors){
    cursors = _cursors;
    draw();
  }

  void draw(){
    for(int z = 0; z < dimensions.z; z++){
    for(int y = 0; y < dimensions.y; y++){
    for(int x = 0; x < dimensions.x; x++){
      PVector cellPos = new PVector(
          pos.x + cellDimensions.x * x,
          pos.y + cellDimensions.y * y,
          pos.z + cellDimensions.z * z);

      GridCell cell = new GridCell(cellPos, cellDimensions, sprite);

      float progression = 0.0;
      
      for (int i = cursors.size()-1; i >= 0; i--) {
        Cursor cursor = cursors.get(i);
        progression = max(cursor.getProgression(cell), progression);
      }
      
      cell.progression = progression;
      
      cell.draw();
    }}}   
  }
  
  void moveCursors(PVector bounds){
    for (int i = cursors.size()-1; i >= 0; i--) {
      cursors.get(i).move(bounds);
    }
  }
}

class GridCell{
  PVector pos, dimensions;
//  color clr;
  float progression;
  Sprite sprite;

  GridCell(PVector _pos, PVector _dimensions, Sprite _sprite){
    init(_pos, _dimensions, _sprite, 0.0);
  }

  GridCell(PVector _pos, PVector _dimensions, Sprite _sprite, float _prog){
    init(_pos, _dimensions, _sprite, _prog);
  }

  void init(PVector _pos, PVector _dimensions, Sprite _sprite, float _progression){
    pos = _pos;
    dimensions = _dimensions;
//    clr = color(255,255,255);
    sprite = _sprite;
    progression = _progression;
  }

  void draw(){ 
//    PVector d = dimensions.get();
//    d.mult(progression);

//    fill(clr);
//    pushMatrix();
//      translate(pos.x, pos.y, pos.z - 100.0 * progression);
//      rotateZ(progression*PI);
//      box(dimensions.x, dimensions.y, dimensions.z);
//    popMatrix();

//    if(progression > 1.0){
//      sprite.draw(progression-1.0, (int)pos.x+10, (int)pos.y);
//      return;
//    }

    sprite.draw(progression, (int)pos.x, (int)pos.y);
  }
}
