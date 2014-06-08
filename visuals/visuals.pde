Visual g_visual;

void setup(){
  size(400, 400);
//  g_visual = new Visual();
  g_visual = new DummyBoxVisual();
}


void draw(){
  g_visual.update();
  g_visual.draw();
}
