/**
filechooser taken from http://processinghacks.com/hacks:filechooser
@author Tom Carden
*/

import javax.swing.*; 

//final JFileChooser fc;
Dreamer dreamer;

void setup(){
  frameRate(4);

  // set system look and feel 
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); 
  } catch (Exception e) { 
    e.printStackTrace();
  } 
 
  // create a file chooser 
  JFileChooser fc = new JFileChooser();

  dreamer = new Dreamer(chooseFile());

  background(255);
  dreamer.drawImage();
  for(int i=0; i<10; i++){
    dreamer.drawDream();
  }
}

String chooseFile(){
  // create a file chooser 
  final JFileChooser fc = new JFileChooser();

  // in response to a button click: 
  int returnVal = fc.showOpenDialog(this); 
 
  String result = "";

  if (returnVal == JFileChooser.APPROVE_OPTION) {
     try {
       result = fc.getSelectedFile().getPath();
     } catch (Exception e) {
       e.printStackTrace();
     }
  }
   
   return result;
}

void draw(){
  dreamer.drawDream();
}

