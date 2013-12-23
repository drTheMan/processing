color g_clrBG = #eeeeee;
color g_clrTheme = #1a7ab0;

class Bubble{
  color fillClr = g_clrTheme;
  float w = 100;
  float h = 100;
  int currentFrame = 0;

  Bubble(){
  }

  void step(){
    currentFrame++;
  }

  void draw(){
    noStroke();
    fill(fillClr);

    // length of this sub-animation    
    int outerLength = 48;
    // current frame of this sub-animation
    int outerFrame = currentFrame; // > outerLength ? outerLength : currentFrame;

    float outerSize = sin(PI*0.7*outerFrame/outerLength);
    ellipse(0, 0, w*outerSize, h*outerSize);
  }
}

class Ring{
  float x,y,w,h;
  Bubble inner, outer;
  
  Ring(float _x, float _y, float _w, float _h){
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    inner = new Bubble();
    outer = new Bubble();

    outer.w = w;
    outer.h = h;
    
    inner.fillClr = g_clrBG;
    inner.w = outer.w - random(5,15);
    inner.h = outer.h - random(5,15);
    inner.currentFrame = - 10;
  }
  
  void step(){
    inner.step();
    outer.step();
  }

  void draw(){
    pushMatrix();
      translate(x, y);
      outer.draw();
      inner.draw();
    popMatrix();
  }
}

ArrayList<Ring> g_rings;
Ring ring1;

void setup(){
  size(displayWidth-150, displayHeight-150, P3D);
  //  frameRate(24);
  // enable anti-aliasing
  smooth();

  ring1 = new Ring(0, 0, 100, 100);
  g_rings = new ArrayList<Ring>();
}

void mouseClicked() {
  float size = random(50, 150);
  Ring newRing = new Ring(mouseX, mouseY, size, size);
  g_rings.add(newRing);
}

void draw(){
  background(g_clrBG);

  ring1.x = mouseX;
  ring1.y = mouseY;

  ring1.draw();
  ring1.step();
  
  for(Ring ring : g_rings){
    ring.draw();
    ring.step();
  }
}
