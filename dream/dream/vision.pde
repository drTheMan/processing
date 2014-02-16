class Vision { 
  PImage _image;
  PImage image;
  PGraphics mask;

  // source dimensions
  int sx,sy,sw,sh;
  // destination dimensions
  int dx,dy,dw,dh;

  Vision(PImage img){
    init(img);
  }

  void init(PImage img){
    _image = img;
    mask = createGraphics(_image.width,_image.height); //, P2D);
    initImage();
  }

  void draw(){
   image(image, dx, dy);
  }

  void initDimensions(){
    sw = (int)random(10, _image.width);
    sh = (int)random(10, _image.height);
    sx = (int)random(0, _image.width-sw);
    sy = (int)random(0, _image.height-sh);
    dx = sx + (int)random(-10, 10);
    dy = dy + (int)random(-10, 10);
    dw = sw + (int)random(-10, 10);
    dh = sh + (int)random(-10, 10);
  }

  void initMask(){
    mask.beginDraw();
      mask.background(#000000); 
      mask.noStroke();
      mask.fill(#ffffff);
      mask.rect(random(-200, _image.width-100), random(-200, _image.height-100), random(230, 260), random(170,200));
    mask.endDraw();
  }

  void initImage(){
    image = _image.get(0, 0, _image.width, _image.height);
    //    image.resize(dw,dh);
    initMask();
    image.mask(mask);
  }
}
