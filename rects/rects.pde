void setup(){
  size(800, 800, P3D);
  rectMode(CENTER);
  noFill();
  //noStroke();
  //fill(255, 37, 195, 1);
  stroke(255, 37, 195, 50);
}

void draw(){
  background(0);
  translate(width/2, height/2);
  // rotateZ(PI/3);
  long t = millis()+20000; 
  float s = sin(t*0.001);
  float r = t*0.0001;

  rotateZ(r);
  
  for(int i=0; i<100; i++){
    rotateZ(r+i*0.0001);
    rotateY(i*0.01);
    rect(0, 0, 450+s*50, 450+s*50);
  }
}
 
void keyPressed(){
  if(key == ENTER) saveFrame("screen-####.png");
}
