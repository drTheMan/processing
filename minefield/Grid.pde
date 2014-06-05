class Grid{
  PVector pos, cellDimensions;
  PVector dimensions;
  PVector cursor;
  
  Grid(){
    pos = new PVector(0,0,0);
    cellDimensions = new PVector(30, 30, 2);
    dimensions = new PVector(50,30, 1);
    cursor = new PVector(-100, -100, -100);
  }

  void draw(PVector _cursor){
    cursor = _cursor;
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

      new GridCell(cellPos, cellDimensions, distanceToProgression(cellPos.dist(cursor))).draw();

        
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
      translate(pos.x, pos.y, pos.z);
      rotateX(progression*10);
      box(dimensions.x, dimensions.y, dimensions.z);
    popMatrix();
  }
}
