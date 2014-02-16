class Vision {
  PImage image;
  PImage vision;
  int ix, iy;

  // source dimensions
  int sx,sy,sw,sh;
  // destination dimensions
  int dx,dy,dw,dh;

  Vision(PImage img, int posX, int posY){
    init(img, posX, posY);
  }
  
  void init(PImage img, int posX, int posY){
    image = img;
    ix = posX;
    iy = posY;

    sw = (int)random(10, image.width);
    sh = (int)random(10, image.height);
    sx = (int)random(0, image.width-sw);
    sy = (int)random(0, image.height-sh);
    dx = sx + (int)random(-10, 10);
    dy = dy + (int)random(-10, 10);
    dw = sw + (int)random(-10, 10);
    dh = sh + (int)random(-10, 10);

    vision = image.get(sx, sy, sw, sh);
    vision.resize(dw,dh);
  }

  void draw(){
   image(vision, dx+ix, dy+iy);
  }
}
