class Event {
  Jet[] jets;
  BeamJet[] beamjets;
  int eventNum;
  int numJets;
  Boolean isDead = false;
  int visMode; 
  PVector translation;
  PVector rotation;
  PVector origRotation;

  Event(int eventNum_, int numJets_, int visMode_) {
    eventNum = eventNum_;
    numJets = numJets_;
    visMode = visMode_;
    if(visMode == 0) {
      jets = new Jet[numJets];
    } else {
      beamjets = new BeamJet[numJets];
      rotation = PVector.random3D().mult(0.01);
      //origRotation = rotation.copy();
    }
   translation = PVector.random3D();
   translation.x *= (width * 0.5) + 0.2;
   translation.y *= (height * 0.5) + 0.2;
   translation.z *= width + height;
  }
  
  void addJet(int index, int numConstituents) {
   if(visMode == 0) {
     jets[index] = new Jet(numConstituents, translation);
   } else {
     beamjets[index] = new BeamJet(numConstituents, translation);
   }
  }
  
  void addParticle(int jetindex, float r, float g, float b, float x, float y, float z, float size, int constituentNum) {
    if(visMode == 0) {
      jets[jetindex].addParticle(r, g, b, x, y, z, size, constituentNum);
    } else {
      beamjets[jetindex].addParticle(r, g, b, x, y, z, size, constituentNum);
    }
  }

  void disable() {
    numJets = 0;
  }

  void run() {
    //println(numJets);
    if(visMode == 0) {
      for (int i = 0; i < numJets; i++) {
       jets[i].run();
        if (jets[i].isDead == false) {
         jets[i].run();
        }
        if (jets[i].isDead == true){
         isDead = true;
        }
      }
    } else {
      pushMatrix();
      translate(translation.x, translation.y, translation.z);
      rotateX(rotation.x);
      rotateY(rotation.y);
      rotateZ(rotation.z);
      for (int i = 0; i < numJets; i++) {
       beamjets[i].run();
        if (beamjets[i].isDead == false) {
         beamjets[i].run();
        }
        if (beamjets[i].isDead == true){
         isDead = true;
        }
      }
      rotation.y += 0.01;
      //rotation.x += origRotation.x;
      //rotation.y += origRotation.y;
      //rotation.z += origRotation.z;
      popMatrix();
    }
  }

  void flashJet(int jetNum) {
    if(visMode == 0) {
      jets[jetNum].spin();
    } else {
      beamjets[jetNum].flash();
    }
  }
  
  void flash(int jetNum, int constNum) {
    if(visMode == 0) {
      jets[jetNum].particles[constNum].flash();
    } else {
      beamjets[jetNum].particles[constNum].spin();
    }
  }
  
  void fadeOut(){
    if(visMode == 0) {
      for (int i = 0; i < numJets; i++) {
        jets[i].fadeOut();
      }
    } else {
      for (int i = 0; i < numJets; i++) {
        beamjets[i].fadeOut();
      }
    }
  }
  
}