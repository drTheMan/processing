
import g4p_controls.*;
 
  
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
  seed = random(600);
  setupControls();
}

void update(){
  // seed += 0.01;
  randomSeed((int)seed);
}


void draw(){
  update();

  background(255);
  
  seed = sdr5.getValueF() + sdr6.getValueF() * millis();

  for(int i=0; i<pcount; i++){
    points[i] = new PVector(i * sdr3.getValueF() + (noise(seed + 40000 + i * 30)-0.46) * sdr4.getValueF() , (noise(seed+i*10)-0.46)*20);
  }

  cx = 0; //width/2;
  cy = 50; //height/2;

  for(int l=0; l<sdr2.getValueI(); l++){

    for(int i=0; i<pcount; i++){
      points[i].x += (noise(seed+1000+l*300+i*10)-0.46) * sdr8.getValueF();
      points[i].y += (noise(seed+1000+l*300+i*10)-0.46) * sdr7.getValueF();
    }
//  
    beginShape();
    for(int i=0; i<pcount; i++){
      curveVertex(cx+points[i].x, cy+points[i].y); 
    }
    endShape();
    
    // cx += 1;
    cy += sdr1.getValueF();
  }
}

void keyPressed() {
  if(key == 'c'){
    sdr1.setVisible(!sdr1.isVisible());
    sdr2.setVisible(!sdr2.isVisible());
    sdr3.setVisible(!sdr3.isVisible());
    sdr4.setVisible(!sdr4.isVisible());
    sdr5.setVisible(!sdr5.isVisible());
    sdr6.setVisible(!sdr6.isVisible());
    sdr7.setVisible(!sdr7.isVisible());
    sdr8.setVisible(!sdr8.isVisible());
//    sdr9.setVisible(!sdr9.isVisible());
  }
}

int sliderCount=0;
GCustomSlider sdr1, sdr2, sdr3, sdr4,sdr5,sdr6,sdr7,sdr8,sdr9;

void setupControls(){
  sdr1 = newSlider();
  sdr2 = newSlider();
  sdr2.setNumberFormat(GCustomSlider.INTEGER);
  sdr2.setLimits(100, 1, 500);
  sdr3 = newSlider();
  sdr3.setLimits(100, 0, 500);  
  sdr4 = newSlider();
  sdr4.setLimits(10, 0, 1000);
  sdr5 = newSlider();
  sdr5.setLimits(0, -1000, 1000);
  sdr6 = newSlider();
  sdr6.setLimits(0.001, 0, 0.01);    
  sdr7 = newSlider();
  sdr7.setLimits(5, 0, 100);    
  sdr8 = newSlider();
  sdr8.setLimits(0, 0, 100);    

}

GCustomSlider newSlider(){
   //new GCustomSlider(this, 0, 0, 260, 80, null);
  GCustomSlider sdr = new GCustomSlider(this, 0, sliderCount*40, 260, 80, null);
  // show          opaque  ticks value limits
  sdr.setShowDecor(false, true, true, false);
  sdr.setNumberFormat(GCustomSlider.DECIMAL, 2);
  sdr.setLimits(5.0f, 0f, 20.0f);
  sdr.setNbrTicks(6);
  // sdr.setStickToTicks(true);  //false by default
  sliderCount++;
  return sdr;
}


  
