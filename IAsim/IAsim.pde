import interfascia.*;
GUIController c;
IFButton b1, b2, b3, b4, b5, b6;
IFLabel l;
int ballNum = 0; //number of balls 
int ball_r = 15; //radius of gravity balls
int beginSim = 0; //determines status of program (opening scene, runSim, pause...)
boolean openingBallMovement = false; //determines whether opening scene balls should be redrawn in starting spots
int singleBall = 0; //makes sure only one ball is being dragged at once
ArrayList<Ball> ballList = new ArrayList<Ball>();
int counter = 0; //determines which planet's velocity is being altered

void setup()
{
  size(750, 750);
  background(0);

  c = new GUIController (this);

  b1 = new IFButton ("Play", 690, 15, 50, 20);
  b2 = new IFButton ("+", 20, 15, 20, 20);
  b3 = new IFButton ("-", 50, 15, 20, 20);
  b4 = new IFButton ("Pause", 690, 45, 50, 20);
  b5 = new IFButton ("Reset", 690, 75, 50, 20);
  b6 = new IFButton ("Velocity", 690, 105, 50, 20);
  b1.addActionListener(this);
  b2.addActionListener(this);
  b3.addActionListener(this);
  b4.addActionListener(this);
  b5.addActionListener(this);
  b6.addActionListener(this);
  c.add (b1);
  c.add (b2);
  c.add (b3);
  c.add (b4);
  c.add (b5);
  c.add (b6);
}

void actionPerformed (GUIEvent e) {
  if (e.getSource() == b1) { //play
    beginSim = 1; //begins simulation
  } else if (e.getSource() == b2) { //+
    if (ballNum < 8) {
      ballNum ++;
      openingBallMovement = false;
    }
  } else if (e.getSource() == b3) {//-
    if (ballNum > 0) {
      ballNum --;
      openingBallMovement = false;
    }
    openingBallMovement = false;
  } else if (e.getSource() == b4) { //pause
    beginSim = 2; //pauses simulation
  }
  else if (e.getSource() == b5){ //resets sim
    beginSim = 0; //maintains original ball points and velocities
    counter = 0;
    for (int i = 0; i < ballList.size(); i++){
      ballList.get(i).xpos = ballList.get(i).ixpos;
      ballList.get(i).ypos = ballList.get(i).iypos;
      ballList.get(i).xvel = ballList.get(i).ixvel;
      ballList.get(i).yvel = ballList.get(i).iyvel;
      ballList.get(i).xacl = ballList.get(i).ixacl;
      ballList.get(i).yacl = ballList.get(i).iyacl;
      ballList.get(i).xLoc.clear();
      ballList.get(i).yLoc.clear();
    }
  }
  else if (e.getSource() == b6){//velocity
    beginSim = 3; //goes to initial velocity function
  }
}

class Ball {
  //class used for each defined mass in simulation
  double xpos, ypos, xvel, yvel, xacl, yacl;
  double ixpos, iypos, ixvel, iyvel, ixacl, iyacl; //used for reset button
  int rval, gval, bval;
  ArrayList<Float> xLoc = new ArrayList<Float>();
  ArrayList<Float> yLoc = new ArrayList<Float>();
  Ball(double x, double y, double xv, double yv, double xa, double ya) {
    xpos = x;
    ixpos = x;
    ypos = y;
    iypos = y;
    xvel = xv;
    ixvel = xv;
    yvel = yv;
    iyvel = yv;
    xacl = xa;
    ixacl = xa;
    yacl = ya;
    iyacl = ya;
  }
}

void arrow(float pointOfOriginX, float pointOfOriginY, float arrowSize, float xDest, float yDest) {
  line(pointOfOriginX, pointOfOriginY, xDest, yDest);
  // draw a triangle at (mouseX, mouseY)
  if (xDest==pointOfOriginX) {
    if (yDest>pointOfOriginY) {
      triangle(xDest+arrowSize/2, yDest, xDest-arrowSize/2, yDest, xDest, yDest+arrowSize*1.732/2);
    } else {
      triangle(xDest+arrowSize/2, yDest, xDest-arrowSize/2, yDest, xDest, yDest-arrowSize/2*1.732);
    }
  } else if (yDest == pointOfOriginY) {
    if (xDest>pointOfOriginX) {
      triangle(xDest, yDest+arrowSize/2, xDest, yDest-arrowSize/2, xDest+arrowSize/2*1.732, yDest);
    } else {
      triangle(xDest, yDest+arrowSize/2, xDest, yDest-arrowSize/2, xDest-arrowSize/2*1.732, yDest);
    }
  } else {
    double SlopeX = (xDest-pointOfOriginX)/Math.pow((xDest-pointOfOriginX)*(xDest-pointOfOriginX)+(yDest-pointOfOriginY)*(yDest-pointOfOriginY), 0.5);
    double SlopeY = (yDest-pointOfOriginY)/Math.pow((xDest-pointOfOriginX)*(xDest-pointOfOriginX)+(yDest-pointOfOriginY)*(yDest-pointOfOriginY), 0.5);
    triangle((float)(xDest+arrowSize/2*1.732*SlopeX), (float)(yDest+arrowSize/2*1.732*SlopeY), (float)(xDest-arrowSize/2*SlopeY), (float)(yDest+arrowSize/2*SlopeX), (float)(xDest+arrowSize/2*SlopeY), (float)(mouseY-arrowSize/2*SlopeX));
  }
}

void openingScene() {
  if (openingBallMovement == false) {
    background(0);
    ballList.clear();
    for (int i = 0; i<ballNum; i++) {
      Ball tempBall = new Ball((double)(i+1)*(750)/(ballNum+1), (double)750/2, (double)0, (double)0, (double)0, (double)0);
      tempBall.rval = (int)(Math.random()*255) + 1;
      tempBall.gval = (int)(Math.random()*255) + 1;
      tempBall.bval = (int)(Math.random()*255) + 1;
      ballList.add(tempBall);
    }
    openingBallMovement = true;
  }
  if (openingBallMovement) {
    background(0);
    for (int i = 0; i < ballList.size(); i++) {
      ellipse((float)ballList.get(i).xpos, (float)ballList.get(i).ypos, (float)2*ball_r, (float)2*ball_r);
      if (((Math.sqrt((ballList.get(i).xpos-mouseX)*(ballList.get(i).xpos-mouseX) + (ballList.get(i).ypos-mouseY)*((ballList.get(i).ypos-mouseY))) < 20) && (singleBall < 1)) && mousePressed) {
        singleBall += 1;
        ballList.get(i).xpos = mouseX;
        ballList.get(i).ixpos = mouseX;
        ballList.get(i).ypos = mouseY;
        ballList.get(i).iypos = mouseY;
        //adds previous points to an arrayList
      }
    }
    singleBall = 0;
  }
}

void pause() {

}

void play() {
  background(0);
  if (ballList.size() > 0){
    for (int i = 0; i < ballList.get(0).xLoc.size(); i++) {
      for(int b = 0; b < ballList.size(); b ++){
        stroke(ballList.get(b).rval, ballList.get(b).gval, ballList.get(b).bval);
        point((float)ballList.get(b).xLoc.get(i), (float)ballList.get(b).yLoc.get(i));
      }
    }
  }

  stroke(0);
  for(int b = 0; b < ballList.size();b++){
    ballList.get(b).xacl = 0;
    ballList.get(b).yacl = 0;
    for(int i = 0; i < ballList.size();i++){
      if (b != i){
        ballList.get(b).xacl += accelerationx(ballList.get(b), ballList.get(i)); 
        ballList.get(b).yacl += accelerationy(ballList.get(b), ballList.get(i)); 
      }
    }
  }
  for(int b = 0; b < ballList.size();b++){
    pointUpdate(ballList.get(b));
    ellipse((float)ballList.get(b).xpos, (float)ballList.get(b).ypos, ball_r*2, ball_r*2);
  }
}

void initialVelocity(){
  background(0);
  for(int i = 0; i < ballList.size(); i ++){
    stroke(0);
    ellipse((float)ballList.get(i).xpos, (float)ballList.get(i).ypos, (float)2*ball_r, (float)2*ball_r);
  }
  stroke(100);
  if (counter < ballList.size()){
    //arrowMouse((float)ballList.get(counter).xpos, (float)ballList.get(counter).ypos, 5.0);
    arrow((float)ballList.get(counter).xpos, (float)ballList.get(counter).ypos, 5.0, mouseX ,mouseY);
  }
  if (mousePressed){
    if (counter < ballList.size()){
      ballList.get(counter).xvel = (mouseX-ballList.get(counter).xpos)/400;
      ballList.get(counter).ixvel = (mouseX-ballList.get(counter).xpos)/400;
      ballList.get(counter).yvel = (mouseY-ballList.get(counter).ypos)/400;
      ballList.get(counter).iyvel = (mouseY-ballList.get(counter).ypos)/400;
      counter ++;
    }
    mousePressed = false;
  }
}

double accelerationx(Ball b1, Ball b2) {
  //calculates force that b2 exerts on b1
  if (Math.sqrt((b1.xpos - b2.xpos)*(b1.xpos - b2.xpos) + (b1.ypos - b2.ypos)*(b1.ypos - b2.ypos)) > ball_r) {
    return (b2.xpos-b1.xpos)/Math.pow(((b2.xpos-b1.xpos)*(b2.xpos-b1.xpos)+(b2.ypos-b1.ypos)*(b2.ypos-b1.ypos)), 1.5);
  }
  else {
    return ((b1.xpos - b2.xpos)*(b1.xpos - b2.xpos) + (b1.ypos - b2.ypos)*(b1.ypos - b2.ypos))*(b2.xpos-b1.xpos)/Math.pow(((b2.xpos-b1.xpos)*(b2.xpos-b1.xpos)+(b2.ypos-b1.ypos)*(b2.ypos-b1.ypos)), 1.5)/(ball_r*ball_r);
  }
}

double accelerationy(Ball b1, Ball b2) {
  //calculates force that b2 exerts on b1
  if (Math.sqrt((b1.xpos - b2.xpos)*(b1.xpos - b2.xpos) + (b1.ypos - b2.ypos)*(b1.ypos - b2.ypos)) > ball_r*2) {
    return (b2.ypos-b1.ypos)/Math.pow(((b2.xpos-b1.xpos)*(b2.xpos-b1.xpos)+(b2.ypos-b1.ypos)*(b2.ypos-b1.ypos)), 1.5);
  }
  else {
    return ((b1.xpos - b2.xpos)*(b1.xpos - b2.xpos) + (b1.ypos - b2.ypos)*(b1.ypos - b2.ypos))*(b2.ypos-b1.ypos)/Math.pow(((b2.xpos-b1.xpos)*(b2.xpos-b1.xpos)+(b2.ypos-b1.ypos)*(b2.ypos-b1.ypos)), 1.5)/(ball_r*ball_r);
  }
}

void pointUpdate(Ball b1) {
  b1.xvel += 100*b1.xacl;
  b1.yvel += 100*b1.yacl;
  b1.xLoc.add(new Float(b1.xpos));
  b1.yLoc.add(new Float(b1.ypos));
  if (b1.xLoc.size() > 1600) {
    b1.xLoc.remove(0);
    b1.yLoc.remove(0);
  }
  b1.xpos += b1.xvel;
  b1.ypos += b1.yvel;
}

void draw()
{
  if (beginSim == 1) {
    play();
  } else if (beginSim == 0) {
    openingScene();
  } else if (beginSim == 2) {
    pause();
  } else if (beginSim == 3) {
    initialVelocity();
  }
}