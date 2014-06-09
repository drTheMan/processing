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
      2, // count
      0.03 // speed
    );
  }

  void init(int _seed, int _minSize, int _maxSize, int _count, float _speed){
    seed = _seed;
    minSize = _minSize;
    maxSize = _maxSize;
    count = _count;
    speed = _speed;

//    smooth();
  }

  void update(){
    // nothing
  }

  void draw(){
    // clear screen
    background(255);

    drawBG();    
    drawFG();
  }

  void drawFG(){
    stroke(0);
    noFill();

    int timer = millis();
    float cursor = timer * speed;

    for(int i= 0; i<count; i++){
      noiseSeed(seed + i);
      randomSeed(seed + i * 1000);
      
      Element el = new Element(
        (int)(width*0.5) + (int)(random(width*0.1)),
        getY(timer), //(int)(noise(cursor*speed, sin(timer*0.0001)*0.01) * height * 2) - height,
        10
      );

      while(el.x > 0){
        Element el2 = new Element(
          el.x - (int)(random(width*0.4)),
          getY(timer),
          10
        );

        line(el.x, el.y, el2.x, el2.y);
        el = el2;
      }
    }
  }
  
  int getY(int time){
    float cursor = time * speed;
    return (int)(noise(cursor*speed, sin(cursor*0.0001)+random(TWO_PI)*1000) * height);
  }
    
  void drawBG(){
    noStroke();
    fill(230);

    int timer = millis();
    float cursor = timer * speed*3;
    int size = 20;

    for(int x=-(int)(cursor % size*2); x<width; x+=size*2){
      rect(x, 0, size, height);
    }
  }
}
