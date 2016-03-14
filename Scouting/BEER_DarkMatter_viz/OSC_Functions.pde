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
      color c = color(255);
      codes.add(new CodeDisplay(string, sin(frameCount * 0.1)*width/2, cos(frameCount*0.1)*height/2, c));
    }
  }



  if (msg.checkAddrPattern("/newEvent")==true) {
    int eventNum, numJets;
    String userName;
    float[][][] constituents;
    int[] numConstituents;
    int index = 3;


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

    //println(eventNum);
    //println(userName);
    //println(numJets);



    if (nextEventIndex > 0) {
      if(userToEvent.hasKey(userName)) {
        events[eventNumDict.get(str(userToEvent.get(userName)))].fadeOut();
      }
    }


    userToEvent.set(userName, eventNum);
    eventNumDict.set(str(eventNum), nextEventIndex);

    events[nextEventIndex] = new Event(eventNum, numJets);
    for (int i = 0; i < numJets; i++) {
      events[nextEventIndex].jets[i] = new Jet(numConstituents[i]);
    }

    println(userToEvent.get(userName));
    println(str(eventNum));


    for (int i = 0; i < numJets; i++) {
      for (int j = 0; j < numConstituents[i]; j++) {
        float pt, eta, phi, m, r, g, b, x, y, z, size;
        x = constituents[i][j][0]*500;
        y = constrain(constituents[i][j][1]*100,-width/2, 0);
        z = constituents[i][j][2]*-300-2300;
        eta = constituents[i][j][3];
        pt = constituents[i][j][4];
        phi = constituents[i][j][5];
        m = constituents[i][j][6];
        r = constrain(abs(eta)/7*255, 0, 255);
        g = constrain(abs(phi)/10*255, 0, 255);
        b = constrain(abs(pt)/10*255, 0, 255);
        size = abs(m)*600;

        events[nextEventIndex].jets[i].addParticle(r, g, b, x, y, z, size, j);
      }
    }
    nextEventIndex += 1;
  }

  //if (msg.checkAddrPattern("/flashEvent")==true) {
  //  int eventNum, eventIndex;
  //  eventNum = msg.get(0).intValue();
  //  eventIndex = eventNumDict.get(str(eventNum));
  //  events[eventIndex].flash();
  //}
  
  if (msg.checkAddrPattern("/eventUsed") == true) {
    int eventNum = msg.get(0).intValue();
    int eventIndex = eventNumDict.get(str(eventNum));
    events[eventIndex].flash();
  }
  
}