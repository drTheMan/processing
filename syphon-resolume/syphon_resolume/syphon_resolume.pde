//Tells Processing we're going to utilize the syphon library
import codeanticode.syphon.*;
 
//Declares the canvas we will draw to, necessary for Syphon
PGraphics canvas;
 
//Declares the Syphon Server
SyphonServer server;
 
void setup() {
  //typical size function, with added argument that is necessary for Syphon
  size(400,400, P3D);
   
  //Sets up the canvas, make it match the desired size of your sketch
  canvas = createGraphics(400, 400, P3D);
   
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
}
 
void draw() {
  //Tell processing to begin drawing to the canvas instead of to the sketch
  canvas.beginDraw();
 
  //Typical drawing functions, but applied to canvas instead of the sketch itself
  canvas.background(100);
  canvas.stroke(255);

  canvas.ellipse(width * 0.5, height * 0.5, random(width), random(height));
  canvas.line(50, 50, mouseX, mouseY);
 
  //Tell processing we're done drawing to canvas
  canvas.endDraw();
 
  //Draws contents of canvas to our sketch so we can see whats going on
  image(canvas, 0, 0);
 
  //Sends contents of canvas through Syphon Server to MadMapper! Yay!
  server.sendImage(canvas);
}
