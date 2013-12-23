
// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<ObjectParticle> particles;
  PVector origin;

  ParticleSystem(){
    init(new PVector(width/2, 50));
  }

  ParticleSystem(PVector location) {
    init(location);
  }

  void init(PVector location){
    origin = location.get();
    particles = new ArrayList<ObjectParticle>();
  }

  void addParticle() {
    particles.add(new ObjectParticle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
