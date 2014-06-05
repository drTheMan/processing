class Dreamer {
  float DISPLACEMENT = 2f;
  float ROTATIONING = 0.2f;
  float SCALING = 0.02f;
  
  float BRIGHTENING = 200.0f;
  float DARKENING = 200.0f;

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
    resized.resize(400, 0);

    size(winW(), winH());    

//    H.add(new HImage(resized)).loc(posX(), posY()).alpha(100); //.scale(0.5f);
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

  void update(){
    addDream();
  }

  void draw(){
    H.drawStage();
  }
 
  void addDream(){
    Vision vision = new Vision(resized);
    H.add( 
        new HImage(vision.image)
          .tint(#ffffff, 255-(int)random(BRIGHTENING))
    )
      .loc(posX()+random(-DISPLACEMENT, DISPLACEMENT), posY()+random(-DISPLACEMENT, DISPLACEMENT))
//      .alpha(200)
      .rotation(random(-ROTATIONING, ROTATIONING))
      .scale(random(1-SCALING, 1+SCALING));
  }
}
    
