class EffectSprite extends Sprite{
  boolean flipHorizontal = false;
  boolean flipVertical = false;

  EffectSprite(){
    init("missing", 0);
  }
    
  EffectSprite(String _sequenceName, int _numFrames){
    init(_sequenceName, _numFrames);
  }

  void drawImage(PImage img, int x, int y){
    if(!(flipHorizontal || flipVertical)){
     image(img, x, y);
     return;
    }

    pushMatrix();
      scale(flipHorizontal ? -1 : 1, flipVertical ? -1 : 1);
      image(img, flipHorizontal ? -x : x, flipVertical ? -y : y);
    popMatrix();
  }
}
         
         
         
   
