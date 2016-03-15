class Event {
  Jet[] jets;
  JetShape[] jetShapes;
  int eventNum;
  int numJets;
  Boolean isDead = false;
  int vizMode = 0;

  Event(int eventNum_, int numJets_, int vizMode_) {
    eventNum = eventNum_;
    numJets = numJets_;
    vizMode = vizMode_;
    if (vizMode == 0) {
      jets = new Jet[numJets];
    }
    if (vizMode == 1) {
      jetShapes = new JetShape[numJets];
    }
  }

  void disable() {
    numJets = 0;
  }

  void run() {
    //println(numJets);
    if (vizMode == 0) {
      for (int i = 0; i < numJets; i++) {
        jets[i].run();
        if (jets[i].isDead == false) {
          jets[i].run();
        }
        if (jets[i].isDead == true) {
          isDead = true;
        }
      }
    }
    if (vizMode == 1) {
      for (int i = 0; i < numJets; i++) {
        if (jetShapes[i].isDead == false) {
          jetShapes[i].run();
        }
      }
    }
  }

  void flash() {
    if (vizMode == 0) {
      for (int i = 0; i < numJets; i++) {
        jets[i].flash();
      }
    }
    if (vizMode == 1) {
      for (int i = 0; i < numJets; i++) {
        jetShapes[i].flash();
      }
    }
  }

  void fadeOut() {
    if (vizMode == 0) {
      for (int i = 0; i < numJets; i++) {
        jets[i].fadeOut();
      }
    }
    if (vizMode == 1) {
      for (int i = 0; i < numJets; i++) {
        jetShapes[i].isFading = true;
      }
    }
  }
}