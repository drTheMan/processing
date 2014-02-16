class Dreamer {
  String path;
  PImage original;
  PImage resized;

  final int MAXW = 800;
  final int MAXH = 600;

  Dreamer(){
    init(null);
  }

  Dreamer(String _path){
    init(_path);
  }

  void init(String _path){
    if((path = _path) == null || path == "") return;
    if((original = loadImage(path)) == null) return;
 
   resized = loadImage(path);
   //resized.copy(original, 0,0, original.width, original.height, 0, 0, (int)(original.width * resizeFactor()), (int)(original.height * resizeFactor()));
   // resized.resize(floor(original.width * resizeFactor()), floor(original.height * resizeFactor()));
   resized.resize(400, 0);

    size(winW(), winH());    
    // resized = 
    // canvasWidth = resized.width * 1.2;
    // canvasHeight = resized.height * 1.2;
  }

  float resizeFactor(){
    float x = ((float)MAXW) / ((float)original.width);
    float y = ((float)MAXH) / ((float)original.height);
    float factor = (x < y ? x : y);
    println("Resize factor: "+factor);
    return factor < 1.0 ? factor : 1.0;
  }
     
  int winW(){
    return floor(resized.width * 1.2);
  }
  
  int winH(){
    return floor(resized.height * 1.2);
  }

  int posX(){
    return floor((winW() - resized.width)/2.0);
  }

  int posY(){
    return floor((winH() - resized.height)/2.0);
  }

  void drawImage(){
    image(resized, posX(), posY());
  }

  void drawDream(){
    new Vision(resized, posX(), posY()).draw();
  }
}
    
