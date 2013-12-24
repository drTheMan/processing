class ObjectParticle extends Particle{
  ObjectParticle(PVector l){
    init(l);
  }

  int shape;

  void init(PVector l){
    super.init(l);
    shape = (int)random(3);
  }
  
  void display() {
    stroke(255,lifespan);
    fill(255,lifespan);

    // circle
    if(shape == 0){  
      ellipse(location.x,location.y, 8,8);
    }
    
    // rect
    if(shape == 1){
      rect(location.x, location.y, 8, 8);
    }
    
    // triangle
    if(shape == 2){
      triangle(location.x, location.y, location.x+8, location.y, location.x, location.y+8);
    }
  }
  
}
