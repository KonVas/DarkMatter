class Jet {
  Particle[] particles;
  int numParticles;
  int nextID = 0;
  Boolean isDead = false;
  PVector translation;

  Jet(int numParticles_, PVector translation_) {
    numParticles = numParticles_;
    particles = new Particle[numParticles_];
    translation = translation_;
  }

  void addParticle(float r, float g, float b, float x, float y, float z, float size_, int id_) {
    particles[nextID] = new Particle(r, g, b, x, y, z, translation.x, translation.y, translation.z, size_, id_);
    nextID += 1;
  }

  void run() {
    for (int i = 0; i < nextID; i++) {
      if (particles[i].isDead == false) {
        //println(numParticles);
        particles[i].run();
      }
      if (particles[i].isDead == true) {
        isDead = true;
      }
    }
  }


  void spin() {
    for (int i = 0; i < numParticles; i++) {
      if (particles[i].isSpinning == false) {
        particles[i].spin();
      }
    }
  }
  
  void fadeOut(){
    for (int i = 0; i < numParticles; i++){
      particles[i].toFade = true;
    }
  }
  
}