int i = 0;
int j = 0;
int k = 0;
boolean condition1;
boolean condition2;
int ballFps = 3;
int ballPosX = 200;
int ballPosy;
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
  drawGolfClub(1);
  if(ballPosX <= 1000){
    ballPosX = ballPosX+ballFps;
    drawBall(ballPosX);
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

void drawGolfClub(int inclination){
  golfClub = createShape(GROUP);

  // Make two shapes
  clubSquare = createShape(RECT, 200, 750, 55, 55);
  clubSquare.setFill(color(255, 40, 0));
  
  clubStick = createShape(LINE, 200, 400, 200, 670);  

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



void move(int ellipsecolor1, int ellipsecolor2, int ellipsecolor3, int x1_line, int x2_line, int y1_line,
int y2_line, String name, int textpos_x, int textpos_y,  int x1_triangle, int y1_triagle, int x2_triangle, int y2_triangle, int x3_triangle, int y3_triangle, int x_ellipse, int y_ellipse) {
  stroke(ellipsecolor1, ellipsecolor2, ellipsecolor3);
  strokeWeight(2);
  line(x1_line, x2_line, y1_line, y2_line);
  fill(ellipsecolor1, ellipsecolor2, ellipsecolor3);
  text(name, textpos_x, textpos_y);
  triangle(x1_triangle, y1_triagle, x2_triangle, y2_triangle, x3_triangle, y3_triangle);
  ellipse( x_ellipse, y_ellipse, 10, 10);
} 
