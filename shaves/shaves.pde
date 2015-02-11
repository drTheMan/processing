
/*

 GLSL Texture Mix by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon
 
 Creating a smooth mix between multiple textures in the fragment shader.
 
 MOUSE PRESS = toggle between three mix types (Subtle, Regular, Obvious)
 
 Built with Processing 2.0b8 / 2.0b9 / 2.0 Final
 
 Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.
 
*/

PShader shader; // PShader that - given it's content - can be applied to textured geometry
PImage image = new PImage(); // array to hold 3 images

void setup() {
  size(800, 800, P2D); // use the P2D OpenGL renderer

  // load the images from the _Images folder (relative path from this sketch's folder) into the GLTexture array
  image = loadImage("Texture01.jpg");

  // load the PShader with a fragment and a vertex shader
  shader = loadShader("shaderFrag.glsl", "shaderVert.glsl");

  // set the images as respective textures for the fragment shader
  shader.set("tex0", image);
}

void draw() {
  background(0); // black background

  //mouseX
  shader.set("time", millis()/1000.0); // feed time to the PShader
  shader.set("radius", ((float)mouseX) / (float)(width) * 0.5); // [0.0 ... 1.0] based on mouse's horizontal position

  shader(shader); // apply the shader to subsequent textured geometry
  image(image, 0, 0, 800, 800); // display any image as a 'textured geometry canvas' for the PShader

  // write the fps and the current mixType (in words through some ?: trickery) in the top-left of the window
  frame.setTitle(" " + int(frameRate));
}

