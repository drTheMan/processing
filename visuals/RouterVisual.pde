class RouterVisual extends Visual{

  int seed, minSize, maxSize, count;
  float speed;
  ArrayList<Line> lines;

  RouterVisual(){
    init(); 
  }

  // create custom init methods that -unlike the constructor-
  // can be called at any moment in time
  void init(){
    init(
      30, // count
      10 // speed
    );
  }

  void init(int _count, float _speed){
    count = _count;
    speed = _speed;

    lines = new ArrayList<Line>();

    for(int i=0; i<count; i++){
      lines.add(new Line());
    }

//    smooth();
  }

  void update(){
    for(int i=lines.size()-1; i>=0; i--){
      println(speed);
      lines.get(i).moveX((int)-speed);
    }
  }

  void draw(){
    // clear screen
    background(255);
    
    for(int i=lines.size()-1; i>=0; i--){
      lines.get(i).draw();
    }
  }
  
  class Dot{
    public int x,y,size;
    
    Dot(){
      init();
    }

    Dot(int _x, int _y, int _size){
      init(_x, _y, _size);
    }

    void init(){
      init(width, (int)random(height), (int)random(8, 12));
    }
    
    void init(int _x, int _y, int _size){
      x = _x;
      y = _y;
      size = _size;
    }

    Dot clone(){
      return new Dot(x, y, size);
    }
    
    void draw(){
      noStroke();
      fill(0);

      ellipse(x, y, size, size);
//        int dotSize = 0;
//        if(dot.x < width - 100)
//          dotSize = 20;
//        else if(dot.x < width){
//         dotSize = (int)map(dot.x, width-100, width, 0, 100);
//        }
//       
//       if(dotSize > 0){
//         ellipse(dot.x, dot.y, dotSize, dotSize);
//       } 
//      }
    }
  }
 
  
  class Line{
    ArrayList<Dot> dots;

    Line(){
      init();
    }
    
    void init(){
      dots = new ArrayList<Dot>();
      for(int x=0; x < width*1.5; x+=random(width*0.3, width*0.7)){
        addDot(x);
      }
    }
    
    void draw(){
      stroke(0);
       noFill();

      for(int i=dots.size()-1; i>0; i--){
        Dot dot = dots.get(i);
        line(dot.x, dot.y, dots.get(i-1).x, dots.get(i-1).y);
      }

      for(int i=dots.size()-1; i>=0; i--){
        Dot dot = dots.get(i);
        dot.draw();
      }
    }
    
    void moveX(int dx){
      for(int i=dots.size()-1; i>=0; i--){
        dots.get(i).x += dx; 
      }
      
      // need a new dot at the end
      if(dots.get(dots.size()-1).x < width){
        addDot(width + (int)random(width*0.5));
      }

      // need to remove the first dot(s)
      for(int i=0; i<dots.size()-2; i++){
        if(dots.get(i+1).x < 0){
          dots.remove(i);
        }
      }
    }
    
    void addDot(int x){
      Dot d = new Dot();
      d.x = x;
      int prevY = 0;
      if(dots.size() > 0){
       prevY = dots.get(dots.size()-1).y;
      } else {
       prevY = (int)(random(height));
      }
      d.y = (int)(prevY + sin(random(TWO_PI))*height*0.1);
      dots.add(d);
    }
  }
}
