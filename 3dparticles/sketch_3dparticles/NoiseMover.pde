class NoiseMover{
  PVector pos;
  PVector velocity;

  NoiseMover(PVector p, PVector v){
    pos = p.get();
    velocity = v.get();
  } 

  void move(){
    PVector noiseForce = new PVector(0, 10.0*noise(pos.x, pos.y));
    PVector gravityForce = new PVector(0, -9.81, 0.0);
    PVector force = velocity.get();
    force.add(noiseForce);
    if(pos.y > 0) force.add(gravityForce);
    pos.add(force);
  }
}
