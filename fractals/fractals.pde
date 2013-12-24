void setup() {
  size(640, 360);
  
  frameRate(12);
  background(255, 0 ,0);

  drawSquarer(new PVector(width, height));
}

void mouseClicked(){
  drawSquarer(new PVector(width, height));
}

void draw() {
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  //new Brancher((mouseX / (float) width) * 90f, new PVector(width/2, height), new PVector(0, -120)).draw();
}

void drawSquarer(PVector d){
  if(d.x < 5 || d.y < 5) return;

  for(int i=0; i<5; i++){
    //strokeWeight(1);//(d.x < d.y ? d.x : d.y) * 0.1);
    PVector new_d = new PVector(d.x*random(0.3, 0.5), d.y*random(0.3, 0.5));

    pushMatrix();
      translate(random(d.x-new_d.x),random(d.y-new_d.y));
      int r = (int)random(4);
      if(r == 0) fill(255);
      if(r==1) fill(255, 0, 0);
      if(r == 2) fill(0, 0, 255);
      if(r == 3) fill(255, 255, 0);
      rect(0,0, d.x, d.y);
      drawSquarer(new_d);
    popMatrix();
  }
}

class Brancher{
  float theta;
  PVector origin;
  PVector direction;

  Brancher(float a, PVector _origin, PVector _direction){
    // Convert angle to radians
    theta = radians(a);
    origin = _origin;
    direction = _direction;
  }

  void draw(){
    stroke(255);
    pushMatrix();
      // Start the tree from the bottom of the screen
      translate(origin.x, origin.y);
      // Draw a line 120 pixels
      line(0,0,direction.x,direction.y);
      // Move to the end of that line
      translate(direction.x, direction.y);
      // Start the recursive branching!
      branch(direction);
    popMatrix();
  }

  void branch(PVector d) {
    // Each branch will be 2/3rds the size of the previous one
    //d.mult(0.66); //h *= 0.66;
    d.mult(0.7);
    
    
    // All recursive functions must have an exit condition!!!!
    // Here, ours is when the length of the branch is 2 pixels or less
    if (abs(d.x) <= 2 && abs(d.y) <= 2) return;
  
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
      rotate(theta);   // Rotate by theta
      line(0, 0, d.x, d.y);  // Draw the branch
      translate(d.x, d.y); // Move to the end of the branch
      branch(d.get());       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
      
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
      rotate(-theta);
      line(0, 0, d.x, d.y);
      translate(d.x, d.y);
      branch(d.get());
    popMatrix();
  }
}
    
   
    

