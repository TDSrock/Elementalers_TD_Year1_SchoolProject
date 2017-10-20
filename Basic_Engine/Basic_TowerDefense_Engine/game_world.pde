class game_world extends object {
  mouse_pointer mp;
  gui ui;
  graph gr;
  wave_controller wave;
  event_manager em;
  int[][] gameGrid;
  int cellWidth = 16;
  int cellHeigth = 16;
  int arrayWidth;
  int arrayHeigth;
  PVector botRight;
  String line;
  int currentLine = 0;
  String[] data;
  int[] setupData;
  String[][] gridData;
  ArrayList<Integer> checkpointOrderList = new ArrayList<Integer>();
  String mapName;
  PImage background;
  Boolean firstFrame = true;
  String playerName;
  name_input_field nif;
  float mapDifModifier = 1;
  float globalDamage = 0;
  int towersPlacedByPlayer = 0;

  game_world(String fileName) {
    nif = new name_input_field();
    mapName = split(fileName, ".")[0];
    background = loadImage(mapName + "_background.png");
    BufferedReader reader = createReader(fileName);

    while (true) {
      try {
        line = reader.readLine();
      } 
      catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      if (line == null) {
        //end of file
        break;
      }

      data = split(line, ",");
      //println(line + " " + currentLine);
      if (currentLine == 0) { // first line of file
        setupData = int(split(line, ","));
        gameGrid = new int[setupData[0]][setupData[1]];
        arrayWidth = setupData[0];
        arrayHeigth = setupData[1];
        location = new PVector(8, 8);
        botRight = new PVector(location.x + cellWidth * arrayWidth, location.y + cellHeigth * arrayHeigth);

        gridData = new String[setupData[1]][setupData[0]];
        playerCurrency = setupData[2];
        playerLives = setupData[3];
        mapDifModifier = (float)setupData[4] / 1000;
      } else { // rest of the lines
        gridData[currentLine - 1] = data;
      }
      currentLine++;
    }

    for (int i = 0; i < arrayHeigth; i++) {
      for (int j = 0; j <  arrayWidth; j++) {
        if (!gridData[i][j].equals("e")) {
          if (isNumeric(gridData[i][j])) {
            checkpointOrderList.add(Integer.parseInt(gridData[i][j]));
          }
        }
      }
    }
    Collections.sort(checkpointOrderList);
    //println(checkpointOrderList);
    for (Integer cp : checkpointOrderList) { 
      createCheckpoint((int)cp);
    }
  }

  private void createCheckpoint(int cp) {
    for (int i = 0; i < arrayHeigth; i++) {
      for (int j = 0; j <  arrayWidth; j++) {
        if (gridData[i][j].equals("" + cp)) {
          new checkpoint(new PVector(j, i));
          gameGrid[j][i] = 1;
          return;
        }
      }
    }
  }

  public boolean isNumeric(String str) { // check if string is numeric
    try {
      double d = Double.parseDouble(str); // try to make it a double
    }
    catch(NumberFormatException nfe) {  
      return false; // catch error is not numeric, so false
    }
    return true; // no error, so the string is numeric
  }

  public void update() {
    if (firstFrame) {
      firstFrame = false;
      gr = new graph();
      mp = new mouse_pointer((int)arrayWidth/2, (int)arrayHeigth/2);
      wave = new wave_controller();
      em = new event_manager(mapName);
      em.init();

      ui = new gui();

      new blocker_tower(new PVector(Float.MAX_VALUE, Float.MAX_VALUE), false);
      if (gr != null) {
        for (int i = 0; i < arrayHeigth; i++) {
          for (int j = 0; j <  arrayWidth; j++) {
            if (!gridData[i][j].equals("e")) {
              if (!isNumeric(gridData[i][j])) {
                Basic_Tower t = null;
                switch(gridData[i][j]) {
                case "a":
                  t = new air_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "f":
                  t = new fire_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "w":
                  t = new water_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "n":
                  t = new nature_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "d":
                  t = new dark_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "l":
                  t = new light_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "st":
                  t = new steam_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "cl":
                  t = new cloud_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "in":
                  t = new inferno_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "ng":
                  t = new noxiouse_gas_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "dg":
                  t = new dark_gale_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "ww":
                  t = new will_o_wisp_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "sp":
                  t = new space_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "df":
                  t = new dragon_fire_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "em":
                  t = new ember_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "hf":
                  t = new holy_fire_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "ma":
                  t = new magma_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "ra":
                  t = new radiation_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "sa":
                  t = new sand_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "so":
                  t = new soul_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "me":
                  t = new metal_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "pl":
                  t = new plant_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "ic":
                  t = new ice_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "mu":
                  t = new mud_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                case "b":
                  t = new blocker_tower(new PVector(j * cellWidth + cellWidth + location.x, i * cellHeigth + cellHeigth + location.y), false);
                  break;
                default:
                  println("invalid value in the map file value was:" + gridData[i][j]);
                  break;
                }
                if (t != null) {
                  t.value = 0;
                }
              }
            }
          }
        }
      }
    }
  }

  public void drawing() {
    //draw grid
    stroke(0, 80);
    strokeWeight(2);
    if (background != null) {
      image(background, location.x - 8, location.x - 8, arrayWidth * cellWidth + 26, arrayHeigth * cellHeigth + 26);
    }
    int gridWidth = gameGrid.length;
    int gridHeight = gameGrid[0].length;
    for (int x = 0; x < gridWidth + 1; x++) {
      line(location.x + cellWidth * x, location.y, location.x + cellWidth * x, location.y + cellHeigth * arrayHeigth);
    }

    for (int y = 0; y< gridHeight + 1; y++) {
      line(location.x, location.y + y * cellHeigth, location.x + cellWidth * gridWidth, location.y + cellHeigth * y);
    }

    for (int x = 0; x < gridWidth; x++) {
      for (int y = 0; y< gridHeight; y++) {
        switch(gameGrid[x][y]) {
        case 0:
          //nothing so draw nothing
          break;
        case 1://something is there, draw a no build zone
          rectMode(CORNER);
          fill(255, 0, 0, 128);
          rect(x * cellWidth + location.x, y * cellHeigth + location.y, cellWidth, cellHeigth);
          break;
        default:
          println("in the array we ecountered a non-registered number: " + gameGrid[x][y] + " at (x/y) :" + x + "/" + y);
          break;
        }
      }
    }
    if(nif!= null){
      nif.drawing();
    }
  }
}