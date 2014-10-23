
import g4p_controls.*;
 
  
int pcount = 10;
int maxcount = 200;

PVector[] points;

float seed;

void setup(){
  size(1280,720);
  // color(0);
  stroke(100);
  noFill();
  
  points = new PVector[maxcount];
  seed = 0; // random(600);
  setupControls();
}

void draw(){
  float cx,cy,ly;
 
  background(255);
 
  pcount = sdr9.getValueI();
  seed = sdr5.getValueF() + sdr6.getValueF() * millis();

  for(int i=0; i<pcount; i++){
    points[i] = new PVector(i * sdr3.getValueF() + (noise(seed + 40000 + i * 30)-0.46) * sdr4.getValueF() , (noise(seed+i*10)-0.46)*20);
  }

  cx = -80; //width/2;
  cy = 10; //height/2;

  for(int l=0; l<sdr2.getValueI(); l++){

    ly = noise(seed+40000+l*10) * sdr10.getValueF();
    
    for(int i=0; i<pcount; i++){
      points[i].x += (noise(seed+1000+l*300+i*10)-0.46) * sdr8.getValueF();
      points[i].y += (noise(seed+1000+l*300+i*10)-0.46) * sdr7.getValueF();
    }
//  
    beginShape();
    for(int i=0; i<pcount; i++){
      curveVertex(cx+points[i].x, ly+cy+points[i].y); 
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
    sdr9.setVisible(!sdr9.isVisible());
    sdr10.setVisible(!sdr10.isVisible());
  }
}

int sliderCount=0;
GCustomSlider sdr1, sdr2, sdr3, sdr4,sdr5,sdr6,sdr7,sdr8,sdr9,sdr10;

void setupControls(){
  // spacing between lines
  sdr1 = newSlider();
  sdr1.setLimits(4.0f, 0f, 20.0f);
  // number of lines
  sdr2 = newSlider();
  sdr2.setNumberFormat(GCustomSlider.INTEGER);
  sdr2.setLimits(175, 1, 500);
  // x-stretch
  sdr3 = newSlider();
  sdr3.setLimits(105, 0, 500);
  // x-displacement  first line
  sdr4 = newSlider();
  sdr4.setLimits(144, 0, 1000);
  // seed
  sdr5 = newSlider();
  sdr5.setLimits(0, -1000, 1000);
  // deltaseed/frame
  sdr6 = newSlider();
  sdr6.setLimits(0.0, 0, 0.01);
  // y-displacement
  sdr7 = newSlider();
  sdr7.setLimits(30, 0, 100);
  // x-displacement every line
  sdr8 = newSlider();
  sdr8.setLimits(12, 0, 100);
  // points/line  
  sdr9 = newSlider();
  sdr9.setNumberFormat(GCustomSlider.INTEGER);
  sdr9.setLimits(14, 0, maxcount-2);
  // variation in spacing between lines
  sdr10 = newSlider();
  sdr10.setLimits(5, -200, 200);
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


  
