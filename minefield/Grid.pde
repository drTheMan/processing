class Grid{
  PVector pos, cellDimensions;
  PVector dimensions;
  ArrayList<PVector> cursors;
  
  Grid(){
    init(10, 10, 30, 30);
  }

  Grid(int columns, int rows, int colWidth, int rowHeight){
    init(columns, rows, colWidth, rowHeight);
  }

  void init(int columns, int rows, int colWidth, int rowHeight){
    cellDimensions = new PVector(colWidth, rowHeight, 2);
    dimensions = new PVector(columns, rows, 1);

    pos = new PVector(cellDimensions.x*0.5,cellDimensions.y*0.5, 0);
    cursors = new ArrayList<PVector>();
  }

  void draw(ArrayList<PVector> _cursors){
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

      float progression = 0.0;
      
      for (int i = cursors.size()-1; i >= 0; i--) {
        PVector cursor = cursors.get(i);
        progression = max(distanceToProgression(cellPos.dist(cursor)), progression);
      }
      
      new GridCell(cellPos, cellDimensions, progression).draw();
    }}}   
  }

  float distanceToProgression(float distance){
    float dist = min(distance, 100);
    return 1.0 - sin(PI - dist*0.01*PI*0.5);
  }   
}

class GridCell{
  PVector pos, dimensions;
  color clr;
  float progression;

  GridCell(PVector _pos, PVector _dimensions){
    init(_pos, _dimensions, 0.0);
  }

  GridCell(PVector _pos, PVector _dimensions, float _prog){
    init(_pos, _dimensions,  _prog);
  }
  
  void init(PVector _pos, PVector _dimensions, float _progression){
    pos = _pos;
    dimensions = _dimensions;
    clr = color(255,255,255);
    progression = _progression;
  }

  void draw(){ 
    fill(clr);
//    PVector d = dimensions.get();
//    d.mult(progression);
    pushMatrix();
      translate(pos.x, pos.y, pos.z - 100.0 * progression);
      rotateZ(progression*PI);
      box(dimensions.x, dimensions.y, dimensions.z);
    popMatrix();
  }
}
