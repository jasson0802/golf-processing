int i = 0;
int j = 0;
int k = 0;
boolean condition1;
boolean condition2;
int ballFps = 3;
int fallFps = 1;
int ballPosX = 200;
int ballPosy;
int ballSize = 800;
PShape golfClub, golfFlag, clubStick, flagStick, flag, clubSquare;


void setup() {
 size(1200, 800);
 background(0);
 smooth();
}

void draw() {
  background(79, 121, 66);
  
  drawHole();
  
  drawGolfFlag();
  drawGolfClub();
  if(ballPosX <= 1000){
    ballPosX = ballPosX+ballFps;
    drawBall(ballPosX);
  }
  else{
      background(0, 0, 0);
      if(ballSize > 0){
        fallBall(ballSize);
      }
  }
}


void drawBall(int posX){
  fill(255,255,255);
  circle(posX, 700, 30);
}

void drawHole(){
  fill(0,0,0);
  circle(1000, 700, 55);
}

void drawGolfClub(){
  golfClub = createShape(GROUP);

  // Make two shapes
  clubSquare = createShape(RECT, 200, 750, 55, 55);
  clubSquare.setFill(color(255, 40, 0));
  
  clubStick = createShape(LINE, 500, 400, 200, 670);  

  golfFlag.addChild(clubSquare);
  golfFlag.addChild(clubStick);

  shape(golfClub);
}

void drawGolfFlag(){
      // Create the shape group
  golfFlag = createShape(GROUP);

  // Make two shapes
  flag = createShape(TRIANGLE, 900, 425, 1000, 400, 1000, 450);
  flag.setFill(color(255, 40, 0));
  
  flagStick = createShape(LINE, 1000, 400, 1000, 670);  

  // Add the two "child" shapes to the parent group
  golfFlag.addChild(flagStick);
  golfFlag.addChild(flag);

  shape(golfFlag);
}


void fallBall(int size){
  fill(255,255,255);
  circle(600, 400, size);
  ballSize = ballSize - fallFps;
}