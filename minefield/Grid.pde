class Grid{
  PVector pos, cellDimensions;
  PVector dimensions;
  PVector cursor;
  
  Grid(){
    pos = new PVector(0,0,0);
    cellDimensions = new PVector(30, 30, 2);
    dimensions = new PVector(10,10, 1);
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

      float distance = cellPos.dist(cursor);
      float cellProgression = max(0.0, 1.0 - distance*0.01);
      
      new GridCell(cellPos, cellDimensions, cellProgression).draw();

        
    }}}   
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
    PVector d = dimensions.get();
    d.mult(progression);
    pushMatrix();
      translate(pos.x, pos.y, pos.z);
//      rotate(random(1.0), random(1.0), random(1.0), 0.0);
      box(d.x, d.y, d.z);
    popMatrix();
  }
}
