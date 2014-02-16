class Vision { 
  PImage _image;
  PImage image;
  int ix, iy;

  // source dimensions
  int sx,sy,sw,sh;
  // destination dimensions
  int dx,dy,dw,dh;

  Vision(PImage img){
    init(img);
  }

  void init(PImage img){
    _image = img;

    sw = (int)random(10, _image.width);
    sh = (int)random(10, _image.height);
    sx = (int)random(0, _image.width-sw);
    sy = (int)random(0, _image.height-sh);
    dx = sx + (int)random(-10, 10);
    dy = dy + (int)random(-10, 10);
    dw = sw + (int)random(-10, 10);
    dh = sh + (int)random(-10, 10);

    image = _image.get(sx, sy, sw, sh);
    image.resize(dw,dh);
  }

  void draw(){
   image(image, dx, dy);
  }
}
