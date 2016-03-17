class BeamParticle {
  float size;
  float origSize;
  PVector loc; 
  PVector limit; 
  PVector vel;
  PVector acc;
  PVector rot;
  PVector rotShift;
  color c;
  float alpha = 255;
  int id;
  Boolean isDead = false;
  Boolean toFade = false;
  Boolean isFlashing = false;
  float delr, delg, delb, flashStartT = 0, flashDur = 0.5, flashDurFrames;
  Boolean isSpinning = false;
  float spinStartT = 0, spinDur = 0.3, spinDurFrames;


  BeamParticle(float r, float g, float b, float x, float y, float z, float locx, float locy, float locz, float size_, int id_) {
    size = (log(size_ + 0.001/0.001)) / (log(0.157627/0.001)) * (150-10) + 10; 
    origSize = size;
    id = id_;
    loc = new PVector(locx, locy, locz);
    vel = new PVector(x, y, z).mult(0.04);
    limit = new PVector(width, height, width + height * 5);
    acc = new PVector(-0.002, -0.002, -0.002);
    rot = new PVector(0, 0);
    rotShift = PVector.random2D().mult(0.2);
    c = color(r, g, b, alpha);
  }

  void run() {
    update();
    display();
    if(toFade == true){
    fadeOut(3);
    }
  }

  void update() {
    //move();
    if (isFlashing) {
      flashing();
    }
    if (isSpinning) {
      spinning();
    }
  }

  void fadeOut(float fadeTime) {
    alpha -= 255/frameRate/fadeTime;
    if (alpha <= 0) {
      isDead = true;
    }
  }

  void display() {
    //pushMatrix();
    //noStroke();
    //fill(c, alpha);
    //translate(loc.x, loc.y, loc.z);
    //sphere(size);
    //popMatrix();
    pushMatrix();
    //translate(loc.x,loc.y,loc.z);
    stroke(c,alpha);
    line(0, 0, 0, vel.x, vel.y, vel.z);
    pushMatrix();
    translate(vel.x, vel.y, vel.z);
    rotateX(rot.x);
    rotateY(rot.y);
    rotateZ(rot.z);
    stroke(0,alpha);
    box(size, size, size);
    popMatrix();
    popMatrix();
  }

  void move() {
    vel.add(acc);
    loc.add(vel);
    //if ((loc.x < -width/2)|| (loc.x > width/2)) {
    //  vel.x *= -0.99;
    //}
    //if ((loc.y < -height*3/4)|| (loc.y > height*3/4)) {
    //  vel.y *= -0.999;
    //  loc.y = height*3/4;
    //}
    if(abs(loc.x) >= limit.x) {
      vel.x = vel.x * -1.0;
      acc.x = 0.0;
    }
    if(abs(loc.y) >= limit.y) {
      vel.y = vel.y * -1.0;
      acc.y = 0.0;
    }
    if(abs(loc.z) >= limit.z) {
      vel.z = vel.z * -1.0;
      acc.z = 0.0;
    }
  }

  void flash() {
    isFlashing = true;

    flashStartT = frameCount;
    flashDurFrames = flashDur * frameRate;
    delr = (255.0-red(c))/flashDurFrames;
    delg = (255.0-green(c))/flashDurFrames;
    delb = (255.0-blue(c))/flashDurFrames;
  }

  void flashing() {
    float n = frameCount-flashStartT;
    if (n < flashDurFrames) {
      c = color(255-(delr*n), 255-(delg*n), 255-(delb*n)); 
    }
    if (n >= flashDurFrames) {
      isFlashing = false;
    }
  }
  
  void spin() {
    isSpinning = true;
    size = constrain(size * 2.5, origSize, origSize * 2.5);
    spinStartT = frameCount;
    spinDurFrames = flashDur * frameRate;
  }

  void spinning() {
    float n = frameCount-spinStartT;
    if (n < spinDurFrames) {
      //c = color(255-(delr*n), 255-(delg*n), 255-(delb*n));
      rot.x = (rot.x + rotShift.x)%(2 * PI);
      rot.y = (rot.y + rotShift.y)%(2 * PI);
      //rot.z = (rot.z + 0.2)%(2 * PI);
      size = constrain(size * 0.97, origSize, origSize * 2.5);
    }
    if (n >= spinDurFrames) {
      isSpinning = false;
      size = origSize;
    }
  }
}