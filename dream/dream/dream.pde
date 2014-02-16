/**
filechooser taken from http://processinghacks.com/hacks:filechooser
@author Tom Carden
*/

import javax.swing.*; 

//final JFileChooser fc;
Dreamer dreamer;

JSONObject jsonSettings;

void setup(){
  H.init(this).background(#ffffff);

  frameRate(2);
  smooth();

  jsonSettings = new JSONObject();
  loadSettings();

  // set system look and feel 
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); 
  } catch (Exception e) { 
    e.printStackTrace();
  } 
 
  // create a file chooser 
  JFileChooser fc = new JFileChooser();

  if(jsonSettings.getString("path", "") != ""){
    dreamer = new Dreamer(jsonSettings.getString("path"));
  } else {
    dreamer = new Dreamer(chooseFile());
  }

//  background(255);
//  dreamer.drawImage();
//  for(int i=0; i<10; i++){
//    dreamer.drawDream();
//  }
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
       jsonSettings.setString("path", result);
       saveSettings();
     } catch (Exception e) {
       e.printStackTrace();
     }
  }
   
   return result;
}

void draw(){
  dreamer.update();
  dreamer.draw();
}

void loadSettings(){
  try{
    jsonSettings = loadJSONObject("settings.json");
    println("loaded value: "+jsonSettings.getString("path", "<none>"));
  } catch (NullPointerException e) {
    println("settings.json could not be found");
  }
}

void saveSettings(){
  saveJSONObject(jsonSettings, "data/settings.json");
}

