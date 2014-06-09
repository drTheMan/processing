class TracerVisual extends Visual{
  int seed, minSize, maxSize, count;
  float speed;

  TracerVisual(){
    init(); 
  }

  // create custom init methods that -unlike the constructor-
  // can be called at any moment in time
  void init(){
    init(
      (int)random(100), // seed
      3, // minSize
      20, // maxSize
      20, // count
      0.3 // speed
    );
  }

  void init(int _seed, int _minSize, int _maxSize, int _count, float _speed){
    seed = _seed;
    minSize = _minSize;
    maxSize = _maxSize;
    count = _count;
    speed = _speed;

    stroke(0);
    noFill();
//    smooth();
  }

  void update(){
    // nothing
  }

  void draw(){
    // clear screen
    background(255);
    
    int timer = millis();
    float cursor = timer * speed;

    for(int i= 0; i<count; i++){
      // make visual configurable by using global seed numbers
      // and give each pixel its own seed
      randomSeed(seed + i * 1000);

      // random screen pos, plus constant cursor movement in one direction
      int hypotheticalX = (int)(random(width + maxSize + maxSize) + cursor);

      // calculate how many times the pixel has left the screen already
      int iteration = (hypotheticalX / (width + maxSize));

      // re-seed based on iteration, so every iteration has a different seed,
      // so every iteration the pixel has a different size and y-position
      randomSeed(seed + i + 1 + (int)random(iteration*10000));

      // now finally define all the pixel's required properties
      int size = (int)random(minSize, maxSize);
      int posY = (int)random(height);
      int posX = (int)(hypotheticalX % (width+maxSize)) - size;

      while(posX < width){
        // and define all next pixel's required properties
        int size2 = (int)random(minSize, maxSize);
        float tmp = height*0.1;
        int posY2 = posY+(int)random(-tmp, tmp);
        int posX2 = posX+(int)random(width*0.3);
  
        // and draw
  //      rect(posX, posY, size, size);
        // ellipse(posX, posY, size, size);
        line(posX, posY, posX2, posY2);
        
        size = size2;
        posX = posX2;
        posY = posY2;
      }
    }
  }
  
  
}
