import netP5.*;
import oscP5.*;
OscP5 osc;
OscProperties oscProps;



//declarations for particles;
IntDict userToEvent = new IntDict();
IntDict userVizMode = new IntDict();
IntDict eventNumDict = new IntDict();
int nextEventIndex = 0;
Event[] events = new Event[3600];

//temp
//int eventNum = 1552065906;
//int numJets = 8;


//declarations for texts;
ArrayList<CodeDisplay> codes = new ArrayList<CodeDisplay>();
int maxNumOfCodes = 120;
int nextIDc = 0;


void setup() {
  size(960, 540, P3D);
  //fullScreen(P3D,);
  smooth();

  oscProps = new OscProperties();
  oscProps.setListeningPort(12000);
  oscProps.setDatagramSize(64000);
  osc = new OscP5(this, oscProps);
}

void draw() {


  background(0);
  //camera(cos(frameCount*0.001) * -716, 0, sin(frameCount*0.001)*613, width/2.08, height/2.00, 0, 0, 1, 0);
  //camera(cos(frameCount*0.01*0.4)*(width/2)+width/2, height/2.0, (height/2.00) / tan(PI*46.7 / 180.0), width/2.00, height/2.00, 0, 0, 1, 0);
  camera(width/2.0*cos(frameCount*0.001), height/2.0, (height/2.0) / tan(PI*30.0 / 180.0)*sin(frameCount*0.001)*5, width/2.0, height/2.0, 0, 0, 1, 0);
  translate(width/2.00, height/2.00, -1000);

  lights();
  directionalLight(150, 150, 150, 0, 300, -300);

  fill(120, 255);

  for (int i = 0; i < codes.size(); i++) {
    codes.get(i).display();
  }


  //pushMatrix();
  //scale(cos(frameCount*0.01)*3);
  rotateX(frameCount * 0.001);
  rotateY(frameCount * 0.0014);
  rotateZ(frameCount * 0.003);
  for (int i = 0; i < nextEventIndex; i++) {
    if (!events[i].isDead) {
      events[i].run();
    }

    //popMatrix();
  }


  //println(frameRate);
}