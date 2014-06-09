Visual g_visual;

void setup(){
  size(800, 600);
//  g_visual = new Visual();
//  g_visual = new DummyBoxVisual();
//  g_visual = new PixelPatternVisual();
  g_visual = new TracerVisual();
}


void draw(){
  g_visual.update();
  g_visual.draw();
}
