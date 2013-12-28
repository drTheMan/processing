// A simple Panel (3D box) class

class Panel {
  PVector position;
  PVector dimensions;
  PVector rotation;

  Panel(PVector _position, PVector _dimensions) {
    position = _position;
    dimensions = _dimensions;
    rotation = new PVector(random(0.1), random(0.1), random(0.1));
  }

  void display() {
//    stroke(255,lifespan);
//    fill(255,lifespan);
    pushMatrix();
      translate(position.x, position.y, position.z);
      rotateX(rotation.x);
      rotateY(rotation.y);
      rotateZ(rotation.z);
      box(dimensions.x, dimensions.y, dimensions.z);
    popMatrix();
  }
}

