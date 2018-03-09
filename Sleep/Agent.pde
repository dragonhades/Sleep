import de.looksgood.ani.*;

class Agent {

  // current position
  float x = randX;
  float y = randY;

  // curve parameters
  float l = 1;
  float t;

  // stroke weight and shade
  float weight; 
  float shade;
  float hue;
  float myProbTurn;
  float myMaxStep;
  
  // base colour
  float baseHue = random(0, 359);
  
  int count=5;

  boolean useMODE2;

  // create a new agent
  Agent() {
    reset();
  }

  void update() {
    int mode;
    if(useMODE2) mode = MODE2;
    else mode = MODE;
    
    setseed();
    
    float px = x;
    float py = y;

    if(mode==3)l += random(maxStep, 2*maxStep);
    else if(mode==5)l += random(-myMaxStep, myMaxStep);
    else l += random(-maxStep, maxStep);
    x = x + l * cos(t);
    y = y + l * sin(t);

    //line(px, py, x, y);
    
    if(mode==5) t += myProbTurn;
    t += probTurn;

    // draw the line
    strokeWeight(weight);
    stroke(hue, 100, shade, 33);
    line(px, py, x, y);
    
    float cx = width/2;
    float cy = height/2;
    float dx = x - cx;
    float dy = y - cy;
    float newx = dx * cos(radians(theta)) - dy * sin(radians(theta));
    float newy = dx * sin(radians(theta)) + dy * cos(radians(theta));
    dx = cx + newx;
    dy = cy + newy;
    
    // reset the agent if it leaves the canvas
    if (dx < 0 || dx > width - 1 || dy < 0 || dy > height - 1) {
      reset();
    }

    // reset the agent if it gets too big
    //if (weight > 0.25 * height) {
      //reset();
    //}
  }

  void reset() {
    count++;
    
    int mode;
    if(useMODE2) mode = MODE2;
    else mode = MODE;
    
    switch(mode){
      case 1:
        x = randX;
        y = randY;
        setseed();
        weight = random(0, 10)+1;
        //setseed();
        probTurn = random(0.02, 0.07);
        //setseed();
        maxStep = random(0.1, 0.2);
        break;
      case 2:
        x = randX;
        y = randY;
        maxWeight = 60;
        weight = random(10, maxWeight);
        probTurn = random(0.01, 0.1);
        maxStep = random(0.05, 0.15);
        break;
      case 3:
        x = randX;
        y = randY;
        weight = random(1, 8);
        probTurn = 0.05;
        maxStep = 0.07;
        break;
      case 4:
        x = randX;
        y = randY;
        maxWeight = 30;
        weight = random(3, maxWeight);
        probTurn = random(0.01, 0.1);
        maxStep = random(0.1, 0.2);
        break;
      case 5:
        x = randX;
        y = randY;
        setseed();
        weight = random(0, 8)+1;
        myProbTurn = random(0.01, 0.1);
        myMaxStep = random(0.1, 0.3);
        break;
    }
    t = random(TWO_PI);

    
    //setseed();
    
    // pick a hue
    if(mode!=3){
      if(mode==2)shade = random(100, 254)+1;
      else shade = random(150, 254)+1;
      if(count % 10 == 0)baseHue = (baseHue + random(20, 30)) % 360; 
      hue = (baseHue + random(-15, 15)) % 360;
    }
  }

  void draw() {
  }
}