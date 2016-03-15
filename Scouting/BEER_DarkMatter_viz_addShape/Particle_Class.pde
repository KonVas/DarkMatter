class Particle {
  float size;
  PVector loc; 
  PVector vel;
  PVector acc;
  color c;
  color cCopy;
  float alpha = 255;
  int id;
  Boolean isDead = false;
  Boolean toFade = false;
  Boolean isFlashing = false;
  float delr, delg, delb, flashStartT = 0, flashDur = 0.4, flashDurFrames;
  float scalePhase = random(TWO_PI);

  Particle(float r, float g, float b, float x, float y, float z, float size_, int id_) {
    size = size_; 
    id = id_;
    loc = new PVector(x, y, z);
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0.002, 0);
    c = color(r, g, b, alpha);
    cCopy = c;
  }

  void run() {
    update();
    display();
    if(toFade == true){
    fadeOut(3);
    }
  }

  void update() {
    move();
    if (isFlashing) {
      flashing();
    }
  }

  void fadeOut(float fadeTime) {
    alpha -= 255/frameRate/fadeTime;
    if (alpha <= 0) {
      isDead = true;
    }
  }

  void display() {
    pushMatrix();
    noStroke();
    fill(c, alpha);
    //scale(cos(frameCount*0.01+ scalePhase)*5);
    translate(loc.x, loc.y, loc.z);
    sphere(size);
    popMatrix();
  }

  void move() {
    vel.add(acc);
    loc.add(vel);
    //if ((loc.x < -width/2)|| (loc.x > width/2)) {
    //  vel.x *= -0.99;
    //}
    if ((loc.y < -height*3/4)|| (loc.y > height*3/4)) {
      vel.y *= -0.999;
      loc.y = height*3/4;
    }
  }

  void flash() {
  isFlashing = true;
  flashStartT = frameCount;
  flashDurFrames = flashDur * frameRate;
  delr = (255.0-red(c))/flashDurFrames;
  delg = (255.0-green(c))/flashDurFrames;
  delb = (255.0-blue(c))/flashDurFrames;
  c = color(255.0,255.0,255.0);
  }

  void flashing() {
  float n = frameCount-flashStartT;
  if (n < flashDurFrames) {
    c = color(255-(delr*(n-1)), 255-(delg*(n-1)), 255-(delb*(n-1)));
  }
  if (n >= flashDurFrames) {
    c = cCopy;
    isFlashing = false;
  }
  }
  
  //void flash(){
  //isFlashing = true;
  //flashStartT = millis();
  //delr = (255.0-red(c))/flashDur/1000;
  //delg = (255.0-green(c))/flashDur/1000;
  //delb = (255.0-blue(c))/flashDur/1000;
  //tempR = red(c);
  //c = color(255,255,255);
  //}
  
  //void flashing(){
  // float n = millis()-flashStartT;
  // //println(n);
  // if(n < (flashDur*1000) && (red(c) > tempR)){
  //   c = color(255-(n*delr),255-(n*delg),255-(n*delb));
  // }
  // if(n >= (flashDur*1000) && (red(c) <= tempR)){
  //   isFlashing = false;
  // }
  //}
  
  
  
}