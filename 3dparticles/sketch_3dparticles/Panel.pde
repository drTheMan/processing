// A simple Panel (3D box) class

class Panel {
  PVector position;
  PVector dimensions;

  Panel(PVector _position, PVector _dimensions) {
    position = _position;
    dimensions = _dimensions;
  }

  void display() {
//    stroke(255,lifespan);
//    fill(255,lifespan);
    pushMatrix();
      translate(position.x, position.y, position.z);
      box(dimensions.x, dimensions.y, dimensions.z);
    popMatrix();
  }
}

