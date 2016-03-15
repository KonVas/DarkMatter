class CodeDisplay {
  String strg = "";
  float x, y;
  float rotY = frameCount * 0.01 * PI;
  color colr;
  float alpha = 255;
  boolean isRunning = true;
  float lifeSpan = 150;

  CodeDisplay(String thisStrg, float x_, float y_, color colr_) {
    strg = thisStrg;
    x = x_;
    y = y_;
    colr = colr_;
  }

  void display() {
    if (isRunning == true) {
      pushMatrix();
      translate(x, y);
      rotateY(rotY);
      rotateY(0);
      fill(colr, alpha);
      textSize(30);
      //textMode(SHAPE);//very slow!
      text(strg, 0, 0);
      alpha -= (255/lifeSpan/frameRate);
      if (alpha < 10) {isRunning = false;}
      popMatrix();
    }
  }
}