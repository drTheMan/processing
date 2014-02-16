ParticleSystem ps;

void setup() {
  size(640,360);
  ps = new ParticleSystem();
}

void draw() {
  background(0);
  ps.addParticle();
  ps.run();
}

void mouseMoved(){
  ps.origin = new PVector(mouseX, mouseY);
}

void keyPressed(){
  if(keyCode == ENTER) saveFrame("emitter-f###.png");
}
