void oscEvent(OscMessage msg) {
  //String typetag;
  //typetag = msg.typetag();
  //println(typetag);
  //println(typetag.length());

  if (msg.checkAddrPattern("/codeRelay")==true) {
    println("new code");
    if (msg.checkTypetag("ss")==true) {
      String string = msg.get(0).stringValue() + "\n" + msg.get(1).stringValue();
      float x = random(-width/2, width/2)*0.5;
      float y = random(-height/2, height/2)*0.5;
      color c = color(50);
      codes.add(new CodeDisplay(string, sin(frameCount * 0.1)*width/2, cos(frameCount*0.1)*height/2, c));
    }
  }



  if (msg.checkAddrPattern("/newEvent")==true) {
    int eventNum, numJets;
    String userName;
    float[][][] constituents;
    int[] numConstituents;
    int index = 3;
    int vizMode = 0;


    eventNum = msg.get(0).intValue();
    userName = msg.get(1).stringValue();
    numJets = msg.get(2).intValue();
    numConstituents = new int[numJets];
    constituents = new float[numJets][1000][7];



    for (int i = 0; i < numJets; i++) {
      numConstituents[i] = msg.get(index).intValue();
      index += 1;
      for (int j = 0; j < numConstituents[i]; j++) {
        for (int k = 0; k < 7; k++) {
          //println(msg.get(index).floatValue());
          constituents[i][j][k] = msg.get(index).floatValue();
          index += 1;
        }
      }
    }



    if ((userToEvent.hasKey(userName)) && (vizMode == 0)) {
      events[eventNumDict.get(str(userToEvent.get(userName)))].fadeOut();
    }


    if (!userVizMode.hasKey(userName)) {
      userVizMode.set(userName, 0);
    }

    vizMode = userVizMode.get(userName);

    userToEvent.set(userName, eventNum);
    eventNumDict.set(str(eventNum), nextEventIndex);

    events[nextEventIndex] = new Event(eventNum, numJets, vizMode);



    for (int i = 0; i < numJets; i++) {
      events[nextEventIndex].addJet(i, numConstituents[i]);
      for (int j = 0; j < numConstituents[i]; j++) {
        float pt, eta, phi, m, r, g, b, x, y, z, size;
        x = constituents[i][j][0]*500;
        y = constituents[i][j][1]*500;
        z = constituents[i][j][2]*500;
        eta = constituents[i][j][3];
        pt = constituents[i][j][4];
        phi = constituents[i][j][5];
        m = constituents[i][j][6];
        if(vizMode == 0 ) {
          r = constrain(abs(eta)/7*255, 0, 255);
          g = constrain(abs(phi)/10*255, 0, 255);
          b = constrain(abs(pt)/10*255, 0, 255);
        } else {
          r = random(0.0, 255.0);
          g = random(0.0, 255.0);
          b = random(0.0, 255.0);
        }
        size = abs(m)*1000;

        events[nextEventIndex].addParticle(i, r, g, b, x, y, z, size, j);
      }
    }

    nextEventIndex += 1;
  }


  if (msg.checkAddrPattern("/eventUsed") == true) {
    int eventNum = msg.get(0).intValue();
    int eventIndex = eventNumDict.get(str(eventNum));
    int numElementsUsed = msg.get(1).intValue();
    Event eventUsed = events[eventIndex];
    int ind = 2;
    for(int i = 0; i < numElementsUsed; i++) {
      int jetNum = msg.get(ind).intValue();
      int constNum = msg.get(ind + 1).intValue();
      ind += 2;
      if(constNum == -1) {
        eventUsed.flashJet(jetNum);
      } else {
        eventUsed.flash(jetNum, constNum);
      }
    }
  }

  if (msg.checkAddrPattern("/changeVizMode") == true) {
    if (msg.checkTypetag("si")==true) {
      String userName;
      int mode;

      userName = msg.get(0).stringValue();
      mode = msg.get(1).intValue();
      println(userName + " " + mode);
      userVizMode.set(userName, constrain(mode, 0, 1));
    }
  }
}