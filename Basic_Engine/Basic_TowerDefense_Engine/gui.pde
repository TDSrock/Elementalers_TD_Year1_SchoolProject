class gui {
  PVector guiTopLeft = new PVector(width - width / 4, 0);
  PVector guiBotRight = new PVector(width, height);
  PVector guiCursorLocation = new PVector(0, 0, 0);//the cursor will use a 3d PVector. The x and y values will simply be the x and y of the current array in the list and the current list will be z.
  PVector[] guiLocationStoreArray = { new PVector(guiCursorLocation.x, guiCursorLocation.y, 1), new PVector(guiCursorLocation.x, guiCursorLocation.y), new PVector(guiCursorLocation.x, guiCursorLocation.y), new PVector(guiCursorLocation.x, guiCursorLocation.y) };//to store the PVectors in of the modes whenever you leave a mode. Whenver you enter a mode pull the data from here.
  final String ENGINE_PREFIX = head.toString().split("@")[0] + "$";
  float spacingBetweenGuiSections = 100;
  int borderMode = 0;
  PImage[][] UIImages = {
    { loadImage("GUI_mode_1_image_1.png")}
  };

  String selectedTower;

  //set-up all values for the constant show gui
  float constantShowButtonWidth = 128;
  float constantShowButtonHeigth = 36;
  float constantShowButtonEmptySpace = 16;

  float[] constantShowSpacingArray = { constantShowButtonWidth, constantShowButtonHeigth, constantShowButtonEmptySpace };

  PImage[][] constantShowImages = {
    { loadImage("nextWaveButton.png"), loadImage("openPauseMenu.png") }
  };

  String[][] constantShowButtons = {
    {"send_next_wave", "open_pause_menu"}
  };
  boolean pauseButton = false;

  PImage constantShowSelector = loadImage("constantButtonSelected.png");//use this to show the player what he selected in the constant show part of the GUI.

  //set-up all values for the buildTower gui
  float buildTowerButtonWidth = 36;
  float buildTowerButtonHeigth = 36;
  float buildTowerButtonEmptySpace = 16;
  float[] buildTowerSpacingArray = { buildTowerButtonWidth, buildTowerButtonHeigth, buildTowerButtonEmptySpace };

  PImage[][] buildTowerImages = {//used for drawing the button
    {  loadImage("Air.png"), loadImage("Fire.png"), loadImage("Nature.png")}, 
    {loadImage("Water.png"), loadImage("Dark.png"), loadImage("Light.png")}
  };

  String[][] buildTowerButtons = {//used for button press
    {  "air_tower", "fire_tower", "nature_tower"}, 
    {"water_tower", "dark_tower", "light_tower"}
  };
  //-------------------------------------------------
  //-------------------------------------------------
  float sellTowerButtonWidth = 128;
  float sellTowerButtonHeigth = 36;
  float sellTowerButtonEmptySpace = 16;
  float[] sellTowerSpacingArray = { sellTowerButtonWidth, sellTowerButtonHeigth, sellTowerButtonEmptySpace };


  PImage[][] sellTowerImage = {//used for drawing the button
    {  loadImage("sellTowerButton.png"), loadImage("combineButton.png")}
  };

  String[][] sellTowerButton = {//used for button press
    {"sell", "combine"}
  };

  PImage[][] sellTowerImageNoCombine = {//used for drawing the button
    {loadImage("sellTowerButton.png")}
  };

  String[][] sellTowerButtonNoCombine = {//used for button press
    {"sell"}
  };


  PImage sellTowerSelector = loadImage("constantButtonSelected.png");
  //--------------------------------------------------
  //--------------------------------------------------
  PImage buildTowerSelector = loadImage("towerSelector.png");

  ArrayList<float[]> guiVisualSpacingList =new ArrayList<float[]>();//throw in all the distance values here, these MUST follow the format of: buttonWidth, buttonHeight, emptySpaceBetween buttons
  ArrayList<PImage[][]> guiVisualList = new ArrayList<PImage[][]>();//throw in all the images here
  ArrayList<String[][]> guiButtonList = new ArrayList<String[][]>();//throw in all the respective strings here.
  ArrayList<PImage> selectorImageList = new ArrayList<PImage>();//throw in all the selector images into this guy.

  boolean nextWave = false;

  PImage chart = loadImage ("Elements.png");

  //drag and drop booleans
  boolean dragging = false;
  boolean placeable = false;

  // combine list Variables
  color red = color(255, 0, 0);
  color green = color(0, 255, 0);
  color blue = color(0, 0, 255);

  PVector listLoc = new PVector(guiTopLeft.x + 150, 200);

  int listCounter = 0;
  int displayCounter = listCounter;
  int displayAmount = 2;

  boolean combineList = false;

  ArrayList<AbstractMap.SimpleEntry<String, Boolean>> guiCombineVisualList = new ArrayList<AbstractMap.SimpleEntry<String, Boolean>>();
  ArrayList<ArrayList<Class>> guiCombineList = new ArrayList<ArrayList<Class>>();

  //constructor
  gui() {//by default loading in the build gui mode
    guiButtonList.add(constantShowButtons);
    guiVisualList.add(constantShowImages);
    guiButtonList.add(buildTowerButtons);
    selectorImageList.add(constantShowSelector);

    guiVisualList.add(buildTowerImages);
    guiVisualSpacingList.add(constantShowSpacingArray);
    guiVisualSpacingList.add(buildTowerSpacingArray);
    selectorImageList.add(buildTowerSelector);
  }

  void update() {
    if (combineList) {
      if (ih.actionKeyPressed && guiCombineVisualList.get(listCounter + displayCounter).getValue()) {
        String button = guiCombineVisualList.get(listCounter + displayCounter).getKey();
        Class forcedEventCheckClass = null;
        try {
          forcedEventCheckClass = Class.forName(ENGINE_PREFIX + button);
        } 
        catch (ClassNotFoundException e) {
          println(e);
        }
        if (gw.em.forcedEventCheck(new PVector(gw.mp.hoverTower.arrayLocation.x, gw.mp.hoverTower.arrayLocation.y), forcedEventCheckClass)) {
          Basic_Tower slave = fetchDataSlave(button);
          if (playerCurrency >= slave.cost) {
            playerCurrency -= slave.cost;
            println("PURCHASED COMBINATION");
            ArrayList<Class> bluePrint = new ArrayList<Class>();
            for (ArrayList<Class> s : cm.combinationList) {
              if (s.get(0).toString().substring(32).equals(button)) {
                bluePrint = new ArrayList<Class>(s);
                bluePrint.remove(s.get(0));
                break;
              }
            }

            bluePrint.remove(gw.mp.hoverTower.getClass());
            int blockersNeeded = bluePrint.size();
            gw.mp.hoverTower.combineTowerList.remove(gw.mp.hoverTower);
            ArrayList<Basic_Tower> toBeBlocker = new ArrayList<Basic_Tower>();
            int indexes = gw.mp.hoverTower.combineTowerList.size();
            for (int i = 0; i < indexes; i++) {
              Basic_Tower t = gw.mp.hoverTower.combineTowerList.get(i);
              if (t == gw.mp.hoverTower) continue;
              int bluePrintEntries = bluePrint.size();
              for (int j = 0; j < bluePrintEntries; j++) {
                Class bluePrintEntry = bluePrint.get(j);
                if (t.getClass() == bluePrintEntry) {
                  gw.mp.hoverTower.combineTowerList.remove(t);
                  t.combineTowerList.remove(gw.mp.hoverTower);
                  bluePrint.remove(bluePrintEntry);
                  bluePrintEntries = bluePrint.size();
                  indexes = gw.mp.hoverTower.combineTowerList.size();
                  toBeBlocker.add(t);
                  j+= 999999999;
                  i--;
                }
              }
            }
            //I know that the combine button is still buggy so this is here to check for that, if you see any of these two errors send me a screenshot ASAP
            if (bluePrint.size() != 0 ) {
              println("COMBINE ERROR SOMETHING REMAINED IN THE BLUEPRINT LIST " + bluePrint + "\nI know that the combine button is still buggy so this is here to check for that, if you see any of these two errors send me a screenshot ASAP");
            }
            if (toBeBlocker.size() != blockersNeeded) {
              println("COMBINE ERROR NOT ENOUGH BLOCKERS IN THE BLOCKERS LIST " + toBeBlocker + " but I needed: " + blockersNeeded + "\nI know that the combine button is still buggy so this is here to check for that, if you see any of these two errors send me a screenshot ASAP");
            }
            for (Basic_Tower t : toBeBlocker) {
              PVector blockerLocation = new PVector(t.location.x, t.location.y);
              t.destroy();
              objectList.remove(t);
              new blocker_tower(blockerLocation, false);
            }

            selectedTower = ENGINE_PREFIX + button;
            PVector combineTowerLocation = new PVector(gw.mp.hoverTower.location.x, gw.mp.hoverTower.location.y);
            gw.mp.hoverTower.destroy();
            objectList.remove(gw.mp.hoverTower);
            try {
              Class c = Class.forName(selectedTower);
              Constructor con = c.getConstructor(Basic_TowerDefense_Engine.class, PVector.class, boolean.class);
              con.newInstance(head, combineTowerLocation, false);
              gw.em.placementCheck(c);
            }
            catch(Exception e) {
              e.printStackTrace();
            }
            gw.mp.possitionChanged = true;
          } else {
            em.generateError("Not enough funds!", 3500);
          }//end of can afford
          combineList = false;
        } else {
          em.generateError(gw.em.forcedEventList.get(0).eventErrorText, 8000);
        }
      }
      if (ih.cancelKeyPressed) {
        gw.mp.inArray = true;
        gw.mp.exitUI = true;
        combineList = false;
      }
      if (ih.upKeyMenuPressed) { 
        if (displayCounter  == 0 && listCounter != 0) {
          if (listCounter < displayAmount) {
            displayCounter = 0;
          } else {
            listCounter = 0;
          }
        } else if (displayCounter != 0) {
          displayCounter -= 1;
        }
      }

      if (ih.downKeyMenuPressed) {
        if (listCounter == guiCombineList.size() - 1) {
          listCounter = 0;
          displayCounter = 0;
        } else if (displayCounter == displayAmount && listCounter != guiCombineList.size() - 1) {
          if ((guiCombineList.size() - 1 - listCounter) < displayAmount) {
            listCounter = guiCombineList.size() - 1;
          } else {
            listCounter += displayAmount + 1;
            displayCounter = 0;
          }
        } else if (displayCounter != displayAmount) {
          displayCounter += 1;
        }
        if (listCounter + displayCounter > guiCombineList.size()) {
          listCounter = 0;
          displayCounter = 0;
        }
      }
    } else {
      if (gw.mp.pointerMode != gw.mp.prevPointerMode && gw.mp.updateUI ) {
        println("update gui");
        guiVisualList.clear();
        guiButtonList.clear();
        guiVisualSpacingList.clear();
        selectorImageList.clear();

        guiButtonList.add(constantShowButtons);
        guiVisualList.add(constantShowImages);
        guiVisualSpacingList.add(constantShowSpacingArray);
        selectorImageList.add(constantShowSelector);
        switch(gw.mp.pointerMode) {
        case 0://load the build gui
          println("loading build gui");
          guiButtonList.add(buildTowerButtons);
          guiVisualList.add(buildTowerImages);
          guiVisualSpacingList.add(buildTowerSpacingArray);
          selectorImageList.add(buildTowerSelector);
          break;
        case 1://load the no building space gui
          break;
        case 2://load the hover gui
          if (gw.mp.hoverTower.myCombinationsList.size() > 0) {
            guiButtonList.add(sellTowerButton);
            guiVisualList.add(sellTowerImage);
          } else {
            guiButtonList.add(sellTowerButtonNoCombine);
            guiVisualList.add(sellTowerImageNoCombine);
          }
          guiVisualSpacingList.add(sellTowerSpacingArray);
          selectorImageList.add(sellTowerSelector);
        case 3://load the DragAndDrop GUI
          break;
        default://something went wrong, throw a message to the console.
          println("pointermode not recognised by gui");
          break;
        }
      }
      if (gw.mp.inArray) {
        if (dragging) {
          if (placeable) {
            if (ih.actionKeyPressed) {
              selectedButton((guiButtonList.get(((int)guiCursorLocation.z))[(int)guiCursorLocation.y][(int)guiCursorLocation.x]));
              gw.mp.pointerMode = 0;
              dragging = false;
              gw.mp.mouseClrFinal = gw.mp.mouseClrNormal;
            }
          }
          if (ih.cancelKeyPressed) {
            gw.mp.inArray = false;
            guiCursorLocation = guiLocationStoreArray[gw.mp.pointerMode];
            gw.mp.pointerMode = 0;
            dragging = false;
            gw.mp.mouseClrFinal = gw.mp.mouseClrNormal;
          }
        } else {
          if (ih.actionKeyPressed) {
            try{
              if(gw.em.forcedEventList.size() != 0){//this is a SUPER HACKY WAY to complete forced events with an action key command
                event e = gw.em.forcedEventList.get(0);
                if(e.actionKey != null){
                  gw.em.completeEvent(e);//this event is done
                }
              }
            } catch (Exception e){
              println(e);
            }
            gw.mp.inArray = false;
            guiCursorLocation = guiLocationStoreArray[gw.mp.pointerMode];
          }
        }
      } else {
        if (ih.cancelKeyPressed) {//give cancel key presidence
          gw.mp.inArray = true;
        } else if (ih.actionKeyPressed) {
          if (dragAndDrop) {
            if (guiButtonList.get(((int)guiCursorLocation.z))[(int)guiCursorLocation.y][(int)guiCursorLocation.x].contains ("_tower")) {
              gw.mp.pointerMode = 3;
              dragging = true;
              gw.mp.inArray = true;
              gw.mp.mouseClrFinal = gw.mp.mouseClrDrag;
            } else {
              selectedButton((guiButtonList.get(((int)guiCursorLocation.z))[(int)guiCursorLocation.y][(int)guiCursorLocation.x]));
            }
          } else {
            selectedButton((guiButtonList.get(((int)guiCursorLocation.z))[(int)guiCursorLocation.y][(int)guiCursorLocation.x]));
          }
        }
        if (ih.upKeyMenuPressed) {
          guiCursorLocation.y--;
        }
        if (ih.downKeyMenuPressed) {
          guiCursorLocation.y++;
        }
        if (ih.leftKeyMenuPressed) {
          guiCursorLocation.x--;
        }
        if (ih.rightKeyMenuPressed) {
          guiCursorLocation.x++;
        }
        if (guiCursorLocation.z > 0 && guiCursorLocation.y == -1) {
          guiCursorLocation.z--;
          guiCursorLocation.y = guiButtonList.get((int)guiCursorLocation.z).length - 1;
        }

        if (guiCursorLocation.z < guiButtonList.size() && guiCursorLocation.y == guiButtonList.get((int)guiCursorLocation.z).length) {
          guiCursorLocation.z++;
          guiCursorLocation.y = 0;
        }

        if (guiCursorLocation.z <= 0) {
          guiCursorLocation.z = 0;
        }
        if (guiCursorLocation.z >= guiButtonList.size()) {
          guiCursorLocation.z = guiButtonList.size() - 1;
        }

        if (guiCursorLocation.y == -1) {
          guiCursorLocation.y = 0;
        }

        if (guiCursorLocation.x == -1) {
          guiCursorLocation.x = 0;
        }

        if (guiCursorLocation.x > guiButtonList.get((int)guiCursorLocation.z)[(int)guiCursorLocation.y].length - 1) {
          guiCursorLocation.x = guiButtonList.get((int)guiCursorLocation.z)[(int)guiCursorLocation.y].length - 1;
        }
      }
    }
  }

  void selectedButton(String selectedButton) {
    println (selectedButton);
    Class forcedEventCheckClass = null;
    if (selectedButton.equals("sell")) {
      forcedEventCheckClass = gw.mp.hoverTower.getClass();
    } else {
      try {
        forcedEventCheckClass = Class.forName(ENGINE_PREFIX + selectedButton);
      } 
      catch (ClassNotFoundException e) {
        println(e);
      }
    }
    if(gw.em.forcedEventCheck(new PVector(gw.mp.arrayLocation.x, gw.mp.arrayLocation.y), forcedEventCheckClass) || selectedButton.equals("combine") || selectedButton.equals("open_pause_menu")){
      if (selectedButton.contains("_tower")) {
        spawnSelectedTower(selectedButton, gw.mp.buildLocation);
      } else {
        switch(selectedButton) {
        case "send_next_wave":
          nextWave = true;
          break;
        case "open_pause_menu":
          pauseButton = true;
          break;
        case "sell":
          if (gw.mp.hoverTower.value != 0) {
            gw.towersPlacedByPlayer--;
          }
          gw.mp.hoverTower.sell();
          break;
        case "combine":
          guiCombineVisualList.clear();
          guiCombineList = new ArrayList<ArrayList<Class>>(gw.mp.hoverTower.myCombinationsList);
          for (ArrayList<Class> c : gw.mp.hoverTower.validCombineList) {
            String name = c.get(0).toString().split(" ")[1].substring(26);
            //println(name  + " From the valid list");
            guiCombineVisualList.add(new AbstractMap.SimpleEntry<String, Boolean>(name, true));
          }
          for (ArrayList<Class> c : gw.mp.hoverTower.invalidCombineList) {
            String name = c.get(0).toString().split(" ")[1].substring(26);
            //println(name + " From the invalid list");
            guiCombineVisualList.add(new AbstractMap.SimpleEntry<String, Boolean>(name, false));
          } 
          combineList = true;
          break;
        default:
          println("unexpexted button, button was: " + selectedButton);
          break;
        }
      }
    } else {
      em.generateError(gw.em.forcedEventList.get(0).eventErrorText, 8000);
    }
    guiLocationStoreArray[gw.mp.pointerMode] = guiCursorLocation;
    gw.mp.inArray = true;
    gw.mp.exitUI = true;
  }

  void spawnSelectedTower(String selectedTower, PVector location) {
    Basic_Tower slave = fetchDataSlave(selectedTower);
    if (slave != null) {
      if (slave.cost <= playerCurrency) {
        gw.towersPlacedByPlayer++;
        playerCurrency -= slave.cost;
        selectedTower = ENGINE_PREFIX + selectedTower;
        try {
          Class c = Class.forName(selectedTower);
          try {
            Constructor con = c.getConstructor(Basic_TowerDefense_Engine.class, PVector.class, boolean.class);
            con.newInstance(head, location, false);
          }
          catch(InstantiationException s) {
            println(s);
          }
          catch(IllegalAccessException r) {
            println(r);
          }
          catch(NoSuchMethodException p) {
            println(p);
          }
          catch(ReflectiveOperationException i) {
            println(i);
          }
          gw.em.placementCheck(c);
        }
        catch(ClassNotFoundException e) {
          println(e);
        }
      } else {
        println("not enough funds");
        em.generateError("Not enough funds!", 2000);
      }
    } else {
      println("slave was null");
    }
  }

  public Basic_Tower fetchDataSlave(String slaveName) {
    try {
      Class c = Class.forName((ENGINE_PREFIX + slaveName));
      for (Basic_Tower t : towerDataSlaves) {
        if (c.isInstance(t)) {
          return t;
        }
      }
      println("slaveNotFound");
    }
    catch(ClassNotFoundException e) {
      println(e);
    }
    return null;
  }

  void drawing() {       
    rectMode (CORNERS);
    fill(0, 0, 0, 0);
    stroke(10, 10, 10, 255);
    strokeWeight(10);
    imageMode(CORNERS);
    image(UIImages[borderMode][0], guiTopLeft.x, guiTopLeft.y, guiBotRight.x, guiBotRight.y);//replace with gui_image later
    fill(0);
    textAlign(LEFT, CENTER);
    textSize(17);
    //hard coded disp menu
    text("Lives: " + playerLives, guiTopLeft.x + 20, guiTopLeft.y + 20);
    text("Currency: "  + (int)floor(playerCurrency), guiTopLeft.x + 20, guiTopLeft.y + 45);
    text("Current Wave: " + gw.wave.waveCounter, guiTopLeft.x + 20, guiTopLeft.y + 70);
    text("Path length : " + (int)gw.gr.pathLength, guiTopLeft.x + 20, guiTopLeft.y + 95);
    text("Score : " + (int)sm.currentScore, guiTopLeft.x + 20, guiTopLeft.y + 120);
    imageMode(CORNER);
    for (int z = 0; z < guiButtonList.size(); z++) {
      PImage[][] buttons = guiVisualList.get(z);
      float[] distanceValues = guiVisualSpacingList.get(z);//format of: buttonWidth, buttonHeight, emptySpaceBetween buttons
      for (int y = 0; y < buttons.length; y++) {
        for (int x = 0; x < buttons[y].length; x++) {
          image(buttons[y][x], guiTopLeft.x + 20 + (distanceValues[2] + distanceValues[0]) * x, 140 + z * spacingBetweenGuiSections + y * (distanceValues[2] + distanceValues[1]), distanceValues[0], distanceValues[1]);
        }
      }
    }
    textSize(17);
    if (gw.wave.waveDataBoolean[2][(gw.wave.waveCounter + 1)%gw.wave.amountOfWaves]) {
      text("BOSS WAVE", guiTopLeft.x + 15, guiBotRight.y - 400);
    }    
    text("Next wave: " + gw.wave.waveDataString[0][(gw.wave.waveCounter+1)%gw.wave.amountOfWaves] + " enemies.", guiTopLeft.x + 15, guiBotRight.y - 380);
    text("Amount of enemies: " + (gw.wave.waveDataInt[0][(gw.wave.waveCounter+1)%gw.wave.amountOfWaves] + gw.wave.waveDataInt[1][(gw.wave.waveCounter+1)%gw.wave.amountOfWaves] + gw.wave.waveDataInt[2][(gw.wave.waveCounter+1)%gw.wave.amountOfWaves]), guiTopLeft.x + 15, guiBotRight.y - 360);
    if (gw.wave.waveDataBoolean[1][(gw.wave.waveCounter + 1)%gw.wave.amountOfWaves]) {
      text("Secondary enemies: " + gw.wave.waveDataString[1][(gw.wave.waveCounter + 1)%gw.wave.amountOfWaves], guiTopLeft.x + 15, guiBotRight.y - 340);
    }
    if (gw.wave.waveDataBoolean[2][(gw.wave.waveCounter + 1)%gw.wave.amountOfWaves]) {
      text(gw.wave.waveDataString[2][(gw.wave.waveCounter + 1)%gw.wave.amountOfWaves] + " Boss", guiTopLeft.x + 15, guiBotRight.y - 320);
    }
    textSize(17);



    imageMode(CORNERS);
    image(chart, guiTopLeft.x + 10, guiBotRight.y - 250, guiBotRight.x - 10, guiBotRight.y - 100);
    imageMode(CORNER);

    //put another hard coded disp menu of the tower selected down here. Use the fetchDataSalve method toghther with a string(like: Basic_Tower slave = fetchDataSlave("air_tower");)
    //however if you are hovering over a tower you can use mp.hoverTower to fetch the data!    
    if (gw.mp.pointerMode == 0 || gw.mp.pointerMode == 2 || gw.mp.pointerMode == 3) {
      Basic_Tower slave = null;
      if (gw.mp.pointerMode == 2) {
        slave = gw.mp.hoverTower;
      } else if (gw.mp.pointerMode == 0 || gw.mp.pointerMode == 3 || combineList) {
        if (guiCursorLocation.z == 1 || combineList) {
          if (!gw.mp.inArray || gw.mp.pointerMode == 3 || combineList) {
            if (combineList) {
              slave = fetchDataSlave(guiCombineVisualList.get(listCounter + displayCounter).getKey());
            } else {
              slave = fetchDataSlave(buildTowerButtons[(int)guiCursorLocation.y][(int)guiCursorLocation.x]);
            }
            if (slave != null) {//draw the ghost img and range
              if (slave.img != null) {//just incase the slave doesn't have an image yet we do nothing here instead
                tint(255, 126);//move the opacity to 50%
                image(slave.img, gw.mp.drawLocation.x, gw.mp.drawLocation.y, 32, 32);
              }
              tint(255, 255);//reset the opacity
              fill(0, 0, 0, 0);
              stroke(slave.rangeClr);
              strokeWeight(1);
              if (combineList) {//if we are in the combine list, we want to ALSO show the player the range of his current tower
                tint(255, 200);
                strokeWeight(2);
                arc(gw.mp.hoverTower.location.x, gw.mp.hoverTower.location.y, gw.mp.hoverTower.range * 2, gw.mp.hoverTower.range * 2, 0, PI * 2);
                stroke(50, 233, 72);
                strokeWeight(1);
                arc(gw.mp.hoverTower.location.x, gw.mp.hoverTower.location.y, slave.range * 2, slave.range * 2, 0, PI * 2);
                tint(255, 255);
              } else {
                arc(gw.mp.buildLocation.x, gw.mp.buildLocation.y, slave.range * 2, slave.range * 2, 0, PI * 2);
              }
            }
          }
        }
      }      
      if (slave != null) {//we managed to fetch the slave properly so now we print his stats
        fill(0, 255);
        textSize(13);
        text("tower: " + slave.toString().substring(26).split("@")[0].replace("_", " "), guiTopLeft.x + 20, guiBotRight.y - 100);
        textSize(11);
        text("cost:", guiTopLeft.x + 20, guiBotRight.y - 80);
        text((int)slave.cost, guiTopLeft.x + 70, guiBotRight.y - 80);
        text("range:", guiTopLeft.x + 20, guiBotRight.y - 60);
        text((int)slave.range, guiTopLeft.x + 70, guiBotRight.y - 60);
        text("fire rate:", guiTopLeft.x + 140, guiBotRight.y - 60);
        text((int)slave.fireRate, guiTopLeft.x + 200, guiBotRight.y - 60);
        text("damage:", guiTopLeft.x + 20, guiBotRight.y - 40);
        text(roundf(slave.damage, 3), guiTopLeft.x + 70, guiBotRight.y - 40);
        text("type:", guiTopLeft.x + 140, guiBotRight.y - 40);
        text(slave.type, guiTopLeft.x + 200, guiBotRight.y - 40);
        text("AoE:", guiTopLeft.x + 20, guiBotRight.y - 20);
        text((int)slave.AoE, guiTopLeft.x + 70, guiBotRight.y - 20);
        text("# targets:", guiTopLeft.x + 140, guiBotRight.y - 20);
        text((int)slave.numberOfTargets, guiTopLeft.x + 200, guiBotRight.y - 20);
      }
    }

    if (!gw.mp.inArray) {
      PImage curSelector = selectorImageList.get((int)guiCursorLocation.z);
      float[] distanceValues = guiVisualSpacingList.get((int)guiCursorLocation.z);
      image(curSelector, guiTopLeft.x + 20 + (distanceValues[2] + distanceValues[0]) * guiCursorLocation.x, 140 + guiCursorLocation.z * spacingBetweenGuiSections + guiCursorLocation.y * (distanceValues[2] + distanceValues[1]), distanceValues[0] + 4, distanceValues[1] + 4);
    }
    //println(notEnoughFundsTimeStamp + " " + (millis() - errorDispTime));
    
    if(gw.em.forcedEventList.size() != 0){
      event e = gw.em.forcedEventList.get(0);
      textSize(16);
      text("current event:", guiTopLeft.x + 18, 400);
      text(e.eventName, guiTopLeft.x + 20, 420);
      textSize(11);
      text(e.eventText.replace("<<^", "\n"), guiTopLeft.x + 20, 450);
      rectMode(CORNERS);
      stroke(blue);
      strokeWeight(3);
      fill(0,0);
      if(e.possitionx != null && e.possitiony != null){
        rect((float)e.possitionx.get(0) * gw.cellWidth + gw.location.x, gw.location.y + (float)e.possitiony.get(0) * gw.cellHeigth, gw.location.x + ((float)e.possitionx.get(0) + 2) * gw.cellWidth, gw.location.y + ((float)e.possitiony.get(0) + 2) * gw.cellHeigth);
      }else {
        if(e.possitionx != null){
          rect((float)e.possitionx.get(0) * gw.cellWidth + gw.location.x, gw.location.y, gw.location.x + ((float)e.possitionx.get(0) + 2) * gw.cellWidth, gw.location.y + gw.arrayHeigth * gw.cellHeigth);
        } else  if( e.possitiony != null){
          rect(gw.location.x, gw.location.y + (float)e.possitiony.get(0) * gw.cellHeigth, gw.location.x + gw.arrayWidth * gw.cellWidth, gw.location.y + ((float)e.possitiony.get(0) + 2) * gw.cellHeigth);
        }
      }
    }


    rectMode(CENTER);
    /*  ArrayList<AbstractMap.SimpleEntry<String, Boolean>> guiCombineVisualList;
     ArrayList<ArrayList<Class>> guiCombineList;
     */
    if (combineList) {
      fill(255);
      rectMode(CORNER);
      strokeWeight(3);
      rect(listLoc.x - 5, listLoc.y + 30, 170, 65);
      for (int i = 0; i < guiCombineVisualList.size() - listCounter; i++) {
        fill(0);
        textSize(16);
        if (guiCombineVisualList.get(listCounter + i).getValue()) {
          //valid
          fill(green);
          text(guiCombineVisualList.get(listCounter + i).getKey(), listLoc.x, (listLoc.y + 40) + (i * 20));
        } else {
          //invalid
          fill(red);
          text(guiCombineVisualList.get(listCounter + i).getKey(), listLoc.x, (listLoc.y + 40) + (i * 20));
        }
        if (i == displayAmount) {
          break;
        }
      }
      try {
        fill(blue);
        //text(guiCombineVisualList.get(listCounter + displayCounter).getKey(), listLoc.x, listLoc.y + displayCounter * 20);
        noFill();
        rectMode(CORNER);
        strokeWeight(1);
        stroke(blue);
        rect(listLoc.x - 5, listLoc.y + 30 + displayCounter * 20, 170, 25);
      } 
      catch (IndexOutOfBoundsException e) {
        displayCounter = 0;
        listCounter = 0;
      }
    }
    rectMode(CORNER);
    em.drawing();
  }

  public float roundf(float number, int scale) {
    int pow = 10;
    for (int i = 1; i < scale; i++)
      pow *= 10;
    float tmp = number * pow;
    return (float) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
  }
  public void drawHealthbar (PVector topLeft, PVector bottomRight, float health, float initialHealth) {

    if (health < 0) {
      health = 0;
    }

    rectMode (CORNERS);
    noStroke();
    fill(255, 0, 0);
    rect(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y);

    rectMode (CORNER);
    noStroke();
    fill(0, 255, 0);
    rect(topLeft.x, topLeft.y, (health / initialHealth) * (bottomRight.x -topLeft.x ), bottomRight.y -topLeft.y);

    stroke (0);
    strokeWeight(2);
    rectMode (CORNERS);
    fill(0, 0, 0, 0);
    rect(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y);
  }
}