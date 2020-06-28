import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress supercollider;

int i = 0;
int j = 0;
int k = 0;
String currentScene;
int ballFps = 3;
int fallFps = 1;
float ballPosX = 200.0;
int ballPosy;
int ballSize = 800;
float golfClubPosX=0.0;
PShape golfClub, golfFlag, clubStick, flagStick, flag, clubSquare;

//Condiciones de la pantalla al cargar
void setup() {
 size(1200, 800);
 background(0);
 smooth();
 
 //Configuracion osc
 osc = new OscP5(this, 12000);
 supercollider = new NetAddress("127.0.0.1", 57120);
 
 //osc.plug(this, "moveBall", "/moveBallX");
}

//Hilo principal de la pantalla
void draw() {
  //Fondo verde
  background(79, 121, 66);
  
  //Revisar escena actual
  if(currentScene != "ballFalling"){
    //Dibujar bola en posicion x, 700 
    drawBall(ballPosX);
    
    //Dibujar hoyo
    drawHole();
  
    //Dibujar banderilla
    drawGolfFlag();
  
    //Dibujar palo de golf
    drawGolfClub();
    
    if(golfClubPosX+55 < 145){
        golfClubPosX = golfClubPosX+1;
    }
  }
  else if(currentScene == "ballFalling"){
    //Pintar fondo negro
    background(0, 0, 0);
    
    //Si la bola no ha desaparecido
    if(ballSize > 0){
      //Dibujar bola cayendo
      fallBall(ballSize);
     }
  }
}

//Mover posicion X de la bola
void moveBall(float posx){
  if(posx > 0)
  {
    ballPosX = (posx * 500.0) + 500;
  }
  else
  {
    ballPosX = (posx + 1) * 500;
  }
}

//Dibujar bola
void drawBall(float posX){
  fill(255,255,255);
  circle(posX, 700, 30);
}

//Dibujar hoyo
void drawHole(){
  fill(0,0,0);
  circle(1000, 700, 55);
}

//Dibujar palo de golf
void drawGolfClub(){
  golfClub = createShape(GROUP);

  // Make two shapes
  clubSquare = createShape(RECT, 50+golfClubPosX, 690, 55, 30);
  clubSquare.setFill(color(169,169,169));
  
  clubStick = createShape(LINE, 55+golfClubPosX, 400, 55+golfClubPosX, 690);  
  clubStick.setStroke(200);
  clubStick.setStrokeWeight(5);

  golfClub.addChild(clubSquare);
  golfClub.addChild(clubStick);

  shape(golfClub);
}

//Dibujar banderilla
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

//Dibujar bola cayendo... Asignar tamano que se pasa por parametro
void fallBall(float size){
  println(size);
  int newSize = (int)size * 100;
  fill(255,255,255);
  circle(600, 400, newSize);
  ballSize = ballSize - fallFps;
}

//Funcion que escucha mensajes osc
void oscEvent(OscMessage msg) {
  //Revisa el tipo de mensaje
  if (msg.checkAddrPattern("/sc3p5")) {
    //x = msg.get(0).floatValue(); // receive floats from sc
  }
  else if(msg.checkAddrPattern("/moveBallX")){
    //Asignar escena actual y ejecutar acciones
    currentScene = "ballMoving";
    moveBall(msg.get(2).floatValue());
  }
  else if(msg.checkAddrPattern("/ballFall")){
    //Asignar escena actual y ejecutar acciones
    currentScene = "ballFalling";
    fallBall(msg.get(2).floatValue());
  }
  else{
    println("THIS IS THE MESSAGE: ", msg);
    println("THIS IS THE CONTENT type: ", msg.typetag());
  }
}
