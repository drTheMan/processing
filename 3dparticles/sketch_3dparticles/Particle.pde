// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  Panel panel;

  Particle(PVector l) {
    acceleration = new PVector(0,0,0); //new PVector(0,0.05);
    velocity = new PVector(0,0,-20); // new PVector(random(-1,1),random(-2,0));
    location = l.get();
    location.add(new PVector(random(width/-2, width/2), random(30)));
    lifespan = 255.0;
    panel = new Panel(location.get(), new PVector(random(50, 300), random(10, 20), random(50, 300)));
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    panel.position = location;
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
//    stroke(255,lifespan);
//    fill(255,lifespan);
//    ellipse(location.x,location.y,8,8);
    panel.display();
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

