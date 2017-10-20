class game_manager {
  // makes a list of options in the menu
  PImage titleImage = loadImage("Title_Image.png");
  String[] menu = {
    "Start", /*"Level Select",*/ "Tutorial", "Highscore",/*"Options",*/ "Quit"
  };
  String[] maps = { "Straight Shot(tutorial)", "Straight Shot", "ZigZag", "back"};
  // Makes the gamstate's
  int[] gameStates = {0, 1, 2, 3, 4, 5};
  int gameState = gameStates[0];

  int startY = 0;
  float arrayWidth;
  float arrayHeight;
  int buttonAmount;
  float textY;
  int previouseState = 0;
  float titleSpace = height / 4;
  boolean showScores = false;
  float highScoreMove = width / 4;
  PImage highscoreSlab = loadImage("highScoreSlab.png");

  int selecterOffset;//defines the y of everybutton.
  
  ArrayList<AbstractMap.SimpleEntry<String, Float>> scores;

  // This will load the images that you use in the menu.
  
  PImage bg = loadImage ("Achtergrond1.png");
  PImage ws = loadImage ("Button_when_selected.png"); //Dit is de NIET geselcteerde
  PImage wns = loadImage ("Button_when_not_selected.png"); //Dit is de WEL geselecteerde
  
  public void update() { 
    arrayWidth = width;
    arrayHeight = height;
    highScoreMove = width / 4;
    

    
    if(gameState == 5 || gameState == 4){
      selecterOffset = height / maps.length / 2;
      buttonAmount = maps.length;
      textY = buttonAmount * 2;
      // if action button pressed go to next menu point.
      if (ih.actionKeyPressed) {
        if(maps[startY].equals("back")){
          setGameState(previouseState);
        } else{
          if(gameState == 5){
            loadMap(maps[startY] + ".txt");
          } else if(gameState == 4){
            setupHighScoreTable(maps[startY]);
          }
        }
      }
  
      // If up key pressed go up. When at the upper point and press up start at the bottom.
      if (ih.upKeyMenuPressed) {
        startY--;
        if (startY < maps.length - maps.length) {
          startY = maps.length - 1;
        }
      }
      // If down key pressed go down. When at lower point and press down start at top.
      if (ih.downKeyMenuPressed) {
        startY++;
        if (startY > maps.length - 1) {
          startY = maps.length - maps.length;
        }
      }
      if(ih.cancelKeyPressed){
        setGameState(previouseState);
      }
    } else {
      showScores = false;
      arrayHeight = height - titleSpace;
      selecterOffset = (height - (int)(titleSpace)) / 2 / menu.length;
      buttonAmount = menu.length;
      textY = buttonAmount * 2;
      // if action button pressed go to next menu point.
      if (ih.actionKeyPressed) {
        executeButton(menu[startY]);
      }
  
      // If up key pressed go up. When at the upper point and press up start at the bottom.
      if (ih.upKeyMenuPressed) {
        startY--;
        if (startY < menu.length - menu.length) {
          startY = menu.length - 1;
        }
      }
      // If down key pressed go down. When at lower point and press down start at top.
      if (ih.downKeyMenuPressed) {
        startY++;
        if (startY > menu.length - 1) {
          startY = menu.length - menu.length;
        }
      }
    }
  }
  public void drawing() {
    background(bg); // shows background image
    fill(255, 0, 0);

    textAlign(CENTER, CENTER);// centers the text
    imageMode(CENTER); // centers the image
    drawPointer();
    buttonNames();
    
    if(gameState == 0){//The title!
      drawTitle();
    }
    if(showScores){
      dispScores();
    }

  }
  // Draws the pointer in the main menu.
  void drawPointer() {
    if(gameState == 0){
      image(ws, arrayWidth/2, selecterOffset + startY * (arrayHeight/buttonAmount) + titleSpace);
    } else {
      image(ws, arrayWidth/2 - highScoreMove * ( showScores ? 1 : 0 ), selecterOffset + startY * (arrayHeight/buttonAmount));
    }
  }
  // Draws the button names
  void buttonNames() {
    if(gameState == 0){
      for (int i = 0; i < menu.length; i++) {
        image(wns, arrayWidth/2, arrayHeight/textY + (arrayHeight/textY * (2 * i)) + titleSpace);
        text(menu[i], arrayWidth/2, arrayHeight/textY + (arrayHeight/textY * (2 * i)) + titleSpace);
      }
    }else{
      for(int i = 0; i < maps.length; i++){
        image(wns, arrayWidth/2 - highScoreMove * ( showScores ? 1 : 0 ), arrayHeight/textY + (arrayHeight/textY * (2 * i)));
        text(maps[i], arrayWidth/2 - highScoreMove * ( showScores ? 1 : 0 ), arrayHeight/textY + (arrayHeight/textY * (2 * i)));
      }
    }
  }
  // This shows what happens when the action button is pressed per menu option.
  void executeButton(String selectedButton) {
    switch(selectedButton) {
    case "Start":
      //println("WAAAGH" + menu[startY]);
      setGameState(gameStates[5]);
      //println("WAAAGH" + menu[startY]);
      break;
    case"Level Select":
      //println("WAAAGH" + menu[startY]);
      break;
    case"Tutorial":
      tut.previousState = gameState;
      setGameState(gameStates[3]);
           break;
    case"Highscore":
      setGameState(gameStates[4]);
       break;
    case"Options":
       break;
    case"Quit":
      exit();
      break;
    default:
      break;
    }
  }
  
  void drawTitle(){
    float scalar = (sin(time.time / 2) + 2) / 12 + 9 / 5;
    float hover = sin(time.time * 1.7) * 10;
    image(titleImage, arrayWidth / 2, titleSpace / 1.2 + hover, titleImage.width * scalar, height / 3 * scalar);
  }
  
  void loadMap(String mapName){
    gw = new game_world(mapName);
    setGameState(1);
  }
  
  public void setGameState(int State) {
    previouseState = gameState;
    gameState = State;
  }
  
  public void setupHighScoreTable(String mapName){
    scores = sm.getScores(mapName);
    println(scores);
    showScores = true;
  }
  
  public void dispScores(){
    int n = 1;
    //println(scores);
    textAlign(LEFT);
    textSize(20);
    fill(0);
    image(highscoreSlab, arrayWidth / 2 + arrayWidth / 4.7, height / 2, arrayWidth / 2 + arrayWidth / 40, height / (sm.highScoreListSize + 2) * 12);
    text ("#",           arrayWidth / 2, height / (sm.highScoreListSize + 2));
    text ("Player name", arrayWidth / 2 + arrayWidth / 20, height / (sm.highScoreListSize + 2));
    textAlign(RIGHT);
    text ("Score",       arrayWidth / 2 + arrayWidth / 2.4, height / (sm.highScoreListSize + 2));
    textAlign(LEFT);
    for(AbstractMap.SimpleEntry<String, Float> s : scores){
      text(n++, arrayWidth / 2, height / (sm.highScoreListSize + 2) * n);
      text(s.getKey(), arrayWidth / 2 + arrayWidth / 20, height / (sm.highScoreListSize + 2) * n);
      textAlign(RIGHT);
      text(s.getValue(), arrayWidth / 2 + arrayWidth / 2.4, height / (sm.highScoreListSize + 2) * n);
      textAlign(LEFT);
      if(n==11){
        break;
      }
    }
    while(n <= 10){
      text(n++, arrayWidth / 2, height / (sm.highScoreListSize + 2) * n);
    }
    textSize(15);
  }
  
  public void playerLost(){
    setGameState(0);
    if(gw != null){
      sm.playerDied(gw.mapName);
    }
    objectList.clear();
    enemyList.clear();
    towerList.clear();
    checkpointList.clear();
    gw = null;
  }
  
}