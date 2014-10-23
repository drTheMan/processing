int pcount = 10;
float cx,cy;
PVector[] points;

void setup(){
  
  size(800,600);
  background(255);
  // color(0);
  stroke(100);
  noFill();
  
  
    points = new PVector[pcount];

  for(int i=0; i<pcount; i++){
    points[i] = new PVector(i *(width*1.0 / pcount), sin(i*0.5+random(2.5)) * 20);
  }
  
  cx = 0; //width/2;
  cy = 0; //height/2;

}

void update(){
  // cx += (mouseX-cx)*0.003;
  cy += 1; //(mouseY-cy)*0.3;
  
  for(int i=0; i<pcount; i++){
    points[i].y += random(3.5);
    
  }
}

void draw(){
  update();

  beginShape();
  for(int i=0; i<pcount; i++){
    curveVertex(cx+points[i].x, cy+points[i].y); 
  }
  endShape();
}
  
