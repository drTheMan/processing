
class Sprite{
  String sequenceName;
  int numFrames;
  PImage[] images;

  Sprite(){
    init("missing", 0);
  }
    
  Sprite(String _sequenceName, int _numFrames){
    init(_sequenceName, _numFrames);
  }

  void init(String _sequenceName, int _numFrames){
    sequenceName = _sequenceName;
    numFrames = _numFrames;
    imageMode(CENTER);
    load();
  }

  void load(){
    images = new PImage[numFrames];
    for(int i = 0; i < numFrames; i++){
      String file = filename(i);
      println("loading sprite image: "+file);
      images[i] = loadImage(file);
    }
  }

  String filename(int frame){
    return sequenceName + nf(frame, 4) + ".png";
  }
  
  PImage getImage(int frame){
    return images[frame];
  }

  PImage getImage(float percentage){
    return getImage((int)(percentage * (numFrames-1)));
  }

  void draw(int frame, int x, int y){
    drawImage(getImage(frame), x, y);
  }

  void draw(float frame, int x, int y){
    drawImage(getImage(frame), x, y);
  }
  
  void drawImage(PImage img, int x, int y){
    image(img, x, y);
  }
}
