/**
 * Simple Particle System
 * by Daniel Shiffman.  
 * 
 * Particles are generated each cycle through draw(),
 * fall with gravity and fade out over time
 * A ParticleSystem object manages a variable size (ArrayList) 
 * list of particles. 
 */

ParticleSystem ps;
NoiseMover nm;

void setup() {
  size(640,360, P3D);
  
  fill(200, 200, 200, 100);
  nm = new NoiseMover(new PVector(width/2,height*0.9, 500), new PVector(0.0, 0, 1.0));
  ps = new ParticleSystem(nm.pos.get());
//  noFill();
}

void draw() {
  background(0);
  ps.addParticle();
  
  nm.move();
  ps.origin = nm.pos.get();

  pushMatrix(); 
    rotateX(PI/-5);
    mouseBasedRotation();
    ps.run();
  popMatrix();
}

PVector mouseDownPos = null;
float xmag, ymag = 0;
float xdown, ydown = 0;

void keyPressed(){
  if(key == ENTER) saveFrame("screen-####.jpg");
}
  
void mousePressed(){
  xdown = mouseX;
  ydown = mouseY;
}

void mouseDragged(){
  float newXmag = (mouseX-xdown)/float(width) * TWO_PI;
  float newYmag = (mouseY-ydown)/float(height) * TWO_PI;

  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { 
    xmag -= diff/4.0; 
  }
  
  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { 
    ymag -= diff/4.0; 
  }
}

void mouseBasedRotation(){
  rotateX(ymag); 
  rotateY(xmag);
}


