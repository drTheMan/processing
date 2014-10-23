

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
  seed += 0.01;
  randomSeed((int)seed);
}


void draw(){
  update();
 
  background(255);

  for(int i=0; i<pcount; i++){
    points[i] = new PVector(i * 110, noise(seed+i*10)*20);
  }

  cx = 0; //width/2;
  cy = 0; //height/2;

  for(int l=0; l<300; l++){

    for(int i=0; i<pcount; i++){
      points[i].y += noise(seed+1000+l*300+i*10) * 3.5;
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
  
