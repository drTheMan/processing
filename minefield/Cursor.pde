class Cursor{
  PVector position, velocity;
  float radius = 20;

  Cursor(){
    init(new PVector(0,0,0), new PVector(random(5.0), random(5.0), 0));
  }

  Cursor(PVector pos, PVector vel){
    init(pos, vel);
  }

  void init(PVector pos, PVector vel){
    position = pos;
    velocity = vel;
    radius = random(20, 200);
  }

  void move(PVector boundaries){
    position.add(velocity);
        
    if((position.x < 0 && velocity.x < 0) || (position.x > boundaries.x && velocity.x > 0)) velocity.x = -velocity.x;
    if((position.y < 0 && velocity.y < 0) || (position.y > boundaries.y && velocity.y > 0)) velocity.y = -velocity.y;
  }

  float getProgression(GridCell cell){
    float distance = position.dist(cell.pos);
    float dist = min(distance, radius);
    return 1.0 - sin(PI - map(dist, 0.0, radius, 0.0, PI*0.5));
  }
}
