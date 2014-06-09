class TracerVisual extends Visual{
  class Element{
    public int x,y,size;
    
    Element(){
    }
    
    Element(int _x, int _y, int _size){
      x = _x;
      y = _y;
      size = _size;
    }

    Element clone(){
      Element clone = new Element();
      clone.x = x;
      clone.y = y;
      clone.size = size;
      return clone;
    }
  }

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
      Element el = new Element();
      el.size = (int)random(minSize, maxSize);
      el.y = (int)random(height);
      el.x = (int)(hypotheticalX % (width+maxSize)) - el.size;
      
      Element el1 = el.clone();

      while(el1.x < width){
        // and define all next pixel's required properties
        float tmp = height*0.1;

        Element el2 = new Element(
          el1.x+(int)random(width*0.3),
          el1.y+(int)random(-tmp, tmp),
          (int)random(minSize, maxSize)
         );
           
        // and draw
  //      rect(posX, posY, size, size);
        // ellipse(posX, posY, size, size);
        line(el1.x, el1.y, el2.x, el2.y);
        
        el1 = el2;
      }

      el1 = el.clone();

      while(el1.x > 0){
        // and define all next pixel's required properties
        float tmp = height*0.1;

        Element el2 = new Element(
          el1.x-(int)random(width*0.3),
          el1.y+(int)random(-tmp, tmp),
          (int)random(minSize, maxSize)
         );
           
        // and draw
  //      rect(posX, posY, size, size);
        // ellipse(posX, posY, size, size);
        line(el1.x, el1.y, el2.x, el2.y);
        
        el1 = el2;
      }
    }
  }
  
  
}
