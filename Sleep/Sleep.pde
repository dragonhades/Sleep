/*
 * Agents move around the canvas leaving a trail.
 * 
 *
 */

Gui gui;

int MODE = 3;
int MODE2 = 3;

// list of agents
ArrayList<Agent> agents;
ArrayList<Agent> agents2;

int agentsCount;

// maximum step size to take
float maxStep = 0.2;
// the probability % to turn
float probTurn;

int maxWeight = 5;
PImage bkgd;

int randX;
int randY;

// controls if agents interact with each other
// which creates other interesting effects
boolean interact = false;

int starttime;
float timeScale = 1/50.0;

SleepData sleep;

int levelIndex=0;

void setup() {
  starttime = millis();

  //size(1280, 720);
  fullScreen();

  if (sleep == null) sleep = new SleepData("2018-03-03");

  if (levelIndex==0) {
    background(255);
    randX = (int)random(width*0.35, width*0.65);
    randY = (int)random(height*0.35, height*0.65);
  }

  setseed();

  agentsCount = height / 3;

  //Ani.init(this);
  //Ani.setDefaultEasing(Ani.CUBIC_IN_OUT);

  // setup the simple Gui
  //gui = new Gui(this);

  //gui.addSlider("MODE", 1, 5);
  //gui.addSlider("Presentation", 1, 2);

  colorMode(HSB, 360, 100, 100, 100);

  createAgents();
}

float theta = 0;

void draw() {
  theta-=0.3;
  translate(width/2, height/2);
  rotate(radians(theta));
  translate(-width/2, -height/2);


  if (millis() - starttime >= levelTimeSec()*1000) {  //5min
    nextLevel();
  }
  
  if (MODE==4 || MODE==2) background(bkgd);

  strokeWeight(0);
  ellipse(randX, randY, 14, 14);
  for (Agent a : agents) {
    //setseed();
    a.update();
  }  
  //if(MODE2==1||MODE2==3){
  //  for (Agent a : agents2) {
  //    //setseed();
  //    a.update();
  //  }
  //}


  // draw Gui last
  //gui.draw();

  // interactively adjust agent parameters
  //maxStep = map(mouseX, 0, width, 0.1, 3);
  //probTurn = map(mouseY, 0, height, 0.01, 0.1);
}

void nextLevel() {
  for (Agent a : agents){
    a.baseHue += 50;
  }
  
  starttime = millis();
  levelIndex++;
  String level = "";
  if (levelIndex!=sleep.getData().size()) {
    level = sleep.getData().getJSONObject(levelIndex).getString("level");
  } else {
    MODE = 3;
    for (Agent a : agents){
      a.hue = 0;
      a.shade = 0;
      a.reset();
    }
  }
  int MODEtmp = MODE;


  switch(level) {
  case "wake":
    MODE=3;
    for (Agent a : agents) {
      a.shade = 0;
      //a.reset();
    }
    break;
  case "light":
    MODE=4;
    if (MODEtmp==1) bkgd = get();
    if (MODEtmp==3) {
      bkgd = get();
      for (Agent a : agents) {
        //setseed();
        a.l = 1;
        a.reset();
        //a.update();
      }
    }
    break;
  case "deep":
    MODE=2;
    if (MODEtmp==1) bkgd = get();
    if (MODEtmp==3) {
      bkgd = get();
      for (Agent a : agents) {
        //setseed();
        a.l = 1;
        a.reset();
        //a.update();
      }
    }
    break;
  case "rem":
    MODE=1;
    if (MODEtmp==3) bkgd = get();
    break;
  }
}

int levelTimeSec() {
  if(levelIndex==sleep.getData().size()){
    return 100000000;
  }
  return (int)(sleep.getData().getJSONObject(levelIndex).getInt("seconds")*timeScale);
}

public void setseed() {
  randomSeed(System.currentTimeMillis());
}

void createAgents() {
  agents = new ArrayList<Agent>();
  agents2 = new ArrayList<Agent>();
  for (int i = 0; i < agentsCount; i++) {
    setseed();
    Agent a = new Agent();
    a.useMODE2=true;
    agents2.add(a);
    setseed();
    Agent b = new Agent();
    b.useMODE2=false;
    agents.add(b);
  }
}