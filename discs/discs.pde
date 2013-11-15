PGraphics pg, pgDiscs;
PImage darkImage, brightImage;

void setup() {
  size(800, 600);
//  frameRate(8);
  smooth();
  darkImage = loadImage("dark.png");
  brightImage = loadImage("bright.png");
  pg = createGraphics(darkImage.width, darkImage.height);
  pgDiscs = createGraphics(width, height);

  // fill screen with bright image texture
  image(brightImage, 0, 0);
  // start with already some discs on the screen
}

void keyPressed(){
  if(keyCode == ENTER) saveFrame();
}

void draw() {
  pgDiscs.background(0,0,0, 1.7);
//  pgDiscs.fill(0,0,0,1.5);
//  pgDiscs.rect(0,0, pgDiscs.width, pgDiscs.height);
//  pgDiscs.tint(100);
  drawDiscs(1);
  image(pgDiscs, 0 ,0);
}

void drawDiscs(int amount){
  pgDiscs.beginDraw();
  
  for(int i=0; i<amount; i++){
    pushMatrix();
      drawDisc(
        random(-pgDiscs.width*0.5, pgDiscs.width*0.5),
        random(pgDiscs.height*-0.25, pgDiscs.height*0.25),
        random(100, 200),
        random(5, 20), random(3,10));
    popMatrix();
  }
  
  pgDiscs.endDraw();
}

void drawDisc(float x, float y, float size, float stroke1, float stroke2){
  pg.beginDraw();
    drawDiscBrightMask(pg, size, stroke1, stroke2);
  pg.endDraw();

  darkImage.mask(pg);  

  pg.beginDraw();
    drawDiscDarkMask(pg, size, stroke1, stroke2);
  pg.endDraw();
  
  brightImage.mask(pg);
  
  pgDiscs.image(darkImage, x,y);
  pgDiscs.image(brightImage, x,y);
}

void drawDiscBrightMask(PGraphics pg, float size, float stroke1, float stroke2){
  pg.background(0);
  pg.fill(255);
  pg.ellipse(pg.width*0.5, pg.height*0.5, size, size);
}

void drawDiscDarkMask(PGraphics pg, float size, float stroke1, float stroke2){
  pg.background(0);

  while(true){
    size -= stroke1;
    if(size < stroke2) return;
    pg.fill(255);
    pg.ellipse(pg.width*0.5, pg.height*0.5, size, size);
    
    size -= stroke2;
    if(size < stroke1) return;
    pg.fill(0);
    pg.ellipse(pg.width*0.5, pg.height*0.5, size, size);    
  }
}


