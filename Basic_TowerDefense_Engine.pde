/** Do NOT edit this file. I will murder you
 * Sets up the objectList and ensures they run their code.
 * Note that all objects have a update and a draw by default, don't worry you can override these without care
 */
import java.util.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.Type;//reflection is used twice. once in the combine manager and once in the gui(the buttons create towers via reflection)
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.io.File;


ArrayList<object> objectList = new ArrayList<object>();
ArrayList<basic_enemy> enemyList = new ArrayList<basic_enemy>();
ArrayList<Basic_Tower> towerList = new ArrayList<Basic_Tower>();
ArrayList<checkpoint> checkpointList = new ArrayList<checkpoint>();
ArrayList<Basic_Tower> towerDataSlaves = new ArrayList<Basic_Tower>();//will contain one instance of EACH tower so we can pull the data out from them. This list is built up in the combine manager while reading out the file.

final String ENGINE_PREFIX = this.toString().split("@")[0] + "$";
final String TOWER_POSTFIX = "_tower";

//NOTE: the core elements are hard coded in the void setup below.
Basic_TowerDefense_Engine head = this;
game_world gw;
time_controller time;
pause_manager pm;
game_manager gm;
input_handler ih;
tutorial tut;
score_manager sm;
sound_engine se;
combine_manager cm;
error_manager em;

int debugLevel = 1;
float frame = 0;
int playerLives;//set in the map file
float playerCurrency;//Decided in the map file
float globalDamage = 0;//The variable wich keeps track of all the damage
PImage tsImage;
boolean drawImage;
boolean drawText;
boolean flip;
boolean dragAndDrop = true;

void setup() {
  size(1280, 720, P2D);
  smooth(8);
  //setting up data-slaves
  new air_tower(new PVector(100, 100), true);
  new dark_tower(new PVector(100, 100), true);
  new fire_tower(new PVector(100, 100), true);
  new light_tower(new PVector(100, 100), true);
  new nature_tower(new PVector(100, 100), true);
  new water_tower(new PVector(100, 100), true);
  sm = new score_manager();
  cm = new combine_manager("combinations.ini");
  pm = new pause_manager();
  time = new time_controller();
  se = new sound_engine(head);
  ih = new input_handler();
  gm = new game_manager();
  tut = new tutorial();
  em = new error_manager();
  drawImage = true;
  drawText = true;
  flip = false;
  se.playLoop("bgmMusic.mp3");
}

void draw() {
  //println(sm.checkIfScoreIsHighScore(8));
  ih.update();
  frame++;
  flip = (frame % 20  == 0);
  se.update();
  time.update();

  if (flip) {
    drawText = !drawText;
  }
  switch(gm.gameState) {
  case 0:
    textSize(15);
    gm.update();
    gm.drawing();

    break;
  case 1:
    background(255);
    if (gw.nif != null) {
      gw.nif.update();
      gw.nif.drawing();
      if (gw.nif.completed) {
        gw.playerName = gw.nif.name;
        gw.nif = null;
      }
      break;
    }
    background(139, 69, 19);//make the entire screen Brown
    textSize(10);
    time.update();

    int objects = objectList.size();
    //update loop
    for (int i = 0; i < objects; i++) {
      object object = objectList.get(i);

      object.update();
      if (object != gw.mp)
        object.drawing();
    }
    gw.wave.update();
    gw.mp.drawing();
    //destory loop for objects
    objects = objectList.size();
  destroyLoop:
    for (int i = 0; i < objects; i++) {
      object object = objectList.get(i);
      if (object.destroy) {
        //println(i + " destroying: " + object); 
        object.destroy();
        if (objectList.size() == 0) {
          break destroyLoop;
        }
        objectList.remove(i);
        objects = objectList.size();
      }
    }
    try {
      gw.gr.drawing();
      if (debugLevel > 0) {
        for (int i = 0; i < gw.gr.nodeList.size(); i++) {
          gw.gr.nodeList.get(i).drawing();
        }
        time.drawing();
      }
    }
    catch(NullPointerException e) {
      //println(e);
    }
    break;
  case 2:
    pm.update();
    pm.drawing();
    break;  
  case 3:
    tut.update();
    tut.drawing();
    break;
  case 4:
  case 5:
    gm.update();
    gm.drawing();
    break;
  default:
    println("Something went Wrong... I think");
    break;
  }
}