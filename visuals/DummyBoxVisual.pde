class DummyBoxVisual extends Visual{
  int x,y;
  int currentX, currentY;

  DummyBoxVisual(){
    x = (int)(width * 0.1);
    y = (int)(height * 0.1);

    fill(0);
    noStroke();
    smooth();
  }

  void update(){
    // nothing
    currentX = x + (int)(sin(millis()*0.013) * x * 0.2);
    currentY = y + (int)(cos(millis()*0.02) * y * 0.2);
  }

  void draw(){
    background(255);
    rect(currentX, currentY, width - currentX - currentX, height - currentY - currentY); 
  }
}
