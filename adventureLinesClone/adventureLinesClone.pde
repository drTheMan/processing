/*
adventureLine01
 2011-07-31 - Eric Pavey
 www.akeric.com
 
 After complete and filter is applied, press LMB to draw another sequence on top.
 Press 's' to save a frame.
 Sketch is designed to run in "Present" (fullscreen) mode.
 */

//--------------------------------------------
// GLOBALS

// user globals:
int gStartWidth = 6;
int gBirthRate = 30;
int gStartPoints = 1;
color gDrawColor = color(0);
color gBackground = color(255);


// sustem globals:
int gStarted = 0;
ArrayList gAdventurePoints = new ArrayList();
PImage _gCollisionImage;
PImage gCollisionImage;
PImage gVignette;
int gVigWidth;
int gVigHeight;

//--------------------------------------------
void setup() {
  size((int)(displayWidth*0.8), (int)(displayHeight*0.8), P2D);
  smooth();
  background(gBackground);
  noStroke();
  // it's too slow to make a fullscreen vignette, so we make a smaller
  // version that is later scaled up, which softenes it as well, which
  // is desirable:
  gVigWidth = width/4;
  gVigHeight = height/4;
  // Create a background image we'll later duplicate during restarts.
  _gCollisionImage = get(0, 0, width, height);
  gVignette = makeVignette(gVigWidth, gVigHeight);
}

//--------------------------------------------
void draw() {
  for (int i=0; i<gAdventurePoints.size(); i++) {
    AdventurePoint ap = (AdventurePoint) gAdventurePoints.get(i);
    ap.update();
    ap.draw();
    ap.update();
    ap.draw();
    ap.update();
    ap.draw();
    ap.update();
    ap.draw();
  }
//  for (int i=0; i<gAdventurePoints.size(); i++) {
//    AdventurePoint ap = (AdventurePoint) gAdventurePoints.get(i);
//    ap.draw();
//  }
  // if there is nothing else to draw, process the scene:
  if (gAdventurePoints.size() == 0 && gStarted == 1) {
    fill(255, 32);
    rect(0, 0, width, height);    
    filter(BLUR, 2);
    filter(DILATE);
    filter(DILATE);
    // apply the vignette:
    blend(gVignette, 0, 0, gVigWidth, gVigHeight, 0, 0, width, height, MULTIPLY);
    noLoop();
  }
}

//--------------------------------------------
// UTILS:

// Used to restart tbe system:
void restart() {
  gCollisionImage = _gCollisionImage.get(0, 0, width, height);
  for (int i=0; i<gStartPoints; i++) {
    PVector p = new PVector(float(mouseX), float(mouseY));
    gAdventurePoints.add(i, new AdventurePoint(p, gStartWidth));
  }
  loop();
}

// Press the mouse, restart the system:
void mousePressed() {
  gStarted = 1;
  restart();
}

// Press s to save an image.
void keyPressed() {
  if (key == 's') {
    saveFrame("adventureLine####.png");
    println("Saved frame " + frameCount);
  }
}

// Create a vignette for our image.
PImage makeVignette(int w, int h) {
  PGraphics vig = createGraphics(w, h, P2D);
  vig.beginDraw();
  vig.background(64);
  vig.fill(255);
  vig.noStroke();
  vig.ellipse(w/2.0, h/2.0, w, h);
  vig.filter(BLUR, 20);
  vig.endDraw();
  return vig;
}

//--------------------------------------------
// OBJECTS:

// Create the point that will wander around and draw.
class AdventurePoint {
  float w; // width
  PVector pos; // position
  PVector dir; // direction
  color col; // color
  int age; // age
  float rot; // rotation
  int birthRate; // how often to birth new lines

  AdventurePoint(PVector p, float wid) {
    pos = p;
    dir = new PVector(0, 1);
    dir.rotate(random(180));
    col = gDrawColor;
    w = wid;
    birthRate = int(random(gBirthRate-10, gBirthRate+10));
    age = 0;
    rot = random(-1, 1);
  }

  void update() {
    // Update position, age, birth new points...
    pos = PVector.add(pos, dir);
    age += 1;
    dir.rotate(radians(rot));
    rot = rot + rot * .01;    
    birthDetect();

    // Detect for edge-death, size-death:
    PVector checkPos = PVector.add(pos, dir); // the position in front
    color underColor = gCollisionImage.get(int(checkPos.x), int(checkPos.y));

    // many ways to die...
    if (underColor == col ||
      (pos.x < -w/2 || pos.x > width+w/2) ||
      (pos.y < -w/2 || pos.y > height+w/2) ||
      w == 0) {
      // if death is detected, kill:
      gAdventurePoints.remove(this);
    }
  }

  void draw() {
    // Draw the pretty points:
    fill(col);
    ellipse(pos.x, pos.y, w, w);
    // Update the collision detection image with the current location:
    gCollisionImage.set(int(pos.x), int(pos.y), gDrawColor);
  }

  void birthDetect() {
    // See if a new particle should be birthed:
    if (age%birthRate==0) {
      PVector p = new PVector(pos.x, pos.y);
      gAdventurePoints.add(0, new AdventurePoint(p, w));
      w = w - .5;
    }
  }
}

