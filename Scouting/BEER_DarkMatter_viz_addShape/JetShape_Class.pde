class JetShape {

  PShape path;
  PVector loc;

  float alpha = 255;
  float xSpeed = random(0.01, 0.004)*1;
  float ySpeed = random(0.011, 0.014)*1;
  float zSpeed = random(0.011, 0.0014)*1;

  float x = random(width)-width/2;
  float y = random(height)-height/2;
  float z = random(height)-height;

  float randFac = random(1024);
  Boolean isFading = false;
  Boolean isDead = false;
  Boolean isFlashing = false;
  int flashStartT;
  int rot = 1;
  
  JetShape() {

    loc = new PVector(x, y, z);
    path = createShape();
    path.beginShape();
    //path.noStroke();
    path.vertex(loc.x, loc.y, loc.z);
  }

  void addVertex(float x_, float y_, float z_, float r, float g, float b) {
    path.stroke(255,90);
    path.fill(r, g, b, 140);
    path.vertex(x_, y_, z_);
  }

  void doneShape() {
    path.vertex(loc.x, loc.y, loc.z);
    path.endShape();
  }
  
  void flash(){
    isFlashing = true;
    flashStartT = millis();
    //rot = 1;
    path.setVisible(false);
  }

  void flashing(){
    if(millis()-flashStartT > 50){
    path.setVisible(true);
    };
    
  }

  void run() {
    pushMatrix();
    
    //scale(cos((frameCount+randFac)*0.01*PI)*3);
    scale(0.1);
    rotateX(frameCount*xSpeed * rot);
    rotateY(frameCount*ySpeed * rot);
    rotateZ(frameCount*zSpeed * rot);
    //translate(x*0.8, y*0.8, z-4000);
    shape(path);
    if (isFading == true) {
      fadeOut();
    }
    popMatrix();
    if (alpha <= 0){
    isDead = true;
    }
    if(isFlashing == true){
    flashing();
    }
  }

  void fadeOut() {
    path.setFill(color(0,alpha));
    alpha -= 10;
   }
}