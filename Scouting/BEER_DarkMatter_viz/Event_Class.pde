class Event {
  Jet[] jets;
  int eventNum;
  int numJets;
  Boolean isDead = false;

  Event(int eventNum_, int numJets_) {
    eventNum = eventNum_;
    numJets = numJets_;
    jets = new Jet[numJets];
  }

  void disable() {
    numJets = 0;
  }

  void run() {
    //println(numJets);
    
    for (int i = 0; i < numJets; i++) {
     jets[i].run();
      if (jets[i].isDead == false) {
       jets[i].run();
      }
      if (jets[i].isDead == true){
       isDead = true;
      }
    }
 }

  void flash() {
    for (int i = 0; i < numJets; i++) {
      jets[i].flash();
    }
  }
  
  void fadeOut(){
    for (int i = 0; i < numJets; i++) {
      jets[i].fadeOut();
    }
  }
  
}