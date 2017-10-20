import processing.sound.*;


public class sound_engine {
  
  //SoundFile fire;
  //float soundtime = file.duration();
  SoundFile file;
  SoundFile bg_music;
  float bgmVolume = 0.05;
  float seVolume = 0.05;
  ArrayList<SoundFile> fileList = new ArrayList<SoundFile>();
  ArrayList<String> fileStrings = new ArrayList<String>();
  ArrayList<Integer> timesPlaying = new ArrayList<Integer>();//list to hold how many times the soundfile is played on this frame already
  float fileLength;
  //boolean playSound = true;
  /*ArrayList<SoundFile> soundList = new ArrayList<SoundFile>();//arraylist voor soundfiles, als een soundfile wordt gespeelt dan is die toegevoegd naar deze arraylist
   ArrayList<SoundFile> soundremoveList = new ArrayList<SoundFile>();*/
  Basic_TowerDefense_Engine head;
  public sound_engine(Basic_TowerDefense_Engine Head) {
    head = Head;
  }


  public void playSound(String fileName) { //geluid functie
    try {//try the whole method
      if (fileStrings.contains(fileName)) { //it checks if the soundfile is in the arraylist
        int index = fileStrings.indexOf(fileName);
        Integer playing = timesPlaying.get(index);
        timesPlaying.set(index, ++playing);
        if (playing != 0) {
          file.amp(0.5 / playing * seVolume); //volum
        } else {
          println("HOW IN THE GOD DID THIS HAPPEN?");
        }
        fileList.get(index).play();
      } else { // if the soundfile is NOT in the arraylist, then ADD the file to the arraylist
        //file = new SoundFile(head, filePath);
        file = new SoundFile(head, fileName);
        if (file != null) {
          fileList.add(file);
          fileStrings.add(fileName);
          timesPlaying.add(1);
          file.amp(0.5 * seVolume); //volum
          file.play(); 

          //println("arrays" + fileList + fileStrings);
        } else { //if soundfile doesn't exist, give error
          println("Invalid file attempted to be played, pleased edit the name of: " + fileName);
        }
      }
    }
    catch(Exception e) {//if SOMETHING goes wrong, report it to the console.
      e.printStackTrace();
    }
  }


  void update() {
    for (int i : timesPlaying) {
      i = 0;
    }
  }

  public void playLoop(String fileName) { //geluid functie voor een loop
  
    bg_music = new SoundFile(head, fileName);
    bg_music.loop();
    bg_music.amp(0.3 * bgmVolume);
  }
}