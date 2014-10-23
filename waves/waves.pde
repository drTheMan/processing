int pcount = 10;
float cx,cy;
PVector[] points;

float seed;
void setup(){
  size(1000,800);
  // color(0);
  stroke(100);
  noFill();
  
  points = new PVector[pcount];
  seed = 0;
}

void update(){
  seed += 0.1;
  randomSeed((int)seed);
}


void draw(){
  update();
 
  background(255);

  for(int i=0; i<pcount; i++){
    points[i] = new PVector(i * 110, sin(i*0.5+random(2.5)) * 20);
  }
  
  cx = 0; //width/2;
  cy = 0; //height/2;

  for(int l=0; l<300; l++){
    
    for(int i=0; i<pcount; i++){
      points[i].y += random(3.5);
    }
  
    beginShape();
    for(int i=0; i<pcount; i++){
      curveVertex(cx+points[i].x, cy+points[i].y); 
    }
    endShape();
    
    // cx += 1;
    cy += 1;
  }
}
  
