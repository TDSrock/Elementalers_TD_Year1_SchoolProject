class pause_manager {
  String[] pause = {
    "Continue", "Retire", /*"Options",*/ "Quit"
  };

  int startY = 0;
  int arrayWidth = width;
  int arrayHeight = height;
  int buttonAmount = pause.length;
  float textY = buttonAmount * 2;

  final int SELECTER_OFFSET = height / 2 / pause.length;//kida decend way

  PImage bg = loadImage ("Achtergrond1.png");
  PImage ws = loadImage ("Button_when_selected.png"); //Dit is de NIET geselcteerde
  PImage wns = loadImage ("Button_when_not_selected.png"); //Dit is de WEL geselecteerde
  PImage elm = loadImage ("Elements kleiner.png");


  public void update() {
    if (ih.actionKeyPressed) {
      executeButton(pause[startY]);
    }

    if (ih.upKeyMenuPressed) {
      println("UP");
      startY++;

    }
    if (ih.downKeyMenuPressed) {
      println("DOWN");
      startY--;

    }
    if (startY > pause.length - 1) {
      startY = pause.length - pause.length;
    }
    if (startY < pause.length - pause.length) {
      startY = pause.length - 1;
    }
  }

  public void drawing() {
    background(bg);
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    imageMode(CENTER);
    update();
    drawPointer();
    drawButton();
  }

  //-----De Methods-----

  //Draw the Pointer
  void drawPointer() {
    image(ws, arrayWidth/2, SELECTER_OFFSET + startY * (arrayHeight/buttonAmount));
  }
  void drawButton() {
    for (int i = 0; i < pause.length; i++) {
      image(wns, arrayWidth/2, arrayHeight/textY + (arrayHeight/textY * (2 * i)));
      text(pause[i], arrayWidth/2, arrayHeight/textY + (arrayHeight/textY * (2 * i)));
    }
  }
  void drawElements() {
    image(elm, arrayWidth - 225, arrayHeight - 100);
  }

  //Executes the Code for The Buttons
  void executeButton(String selectedButton) {
    switch(selectedButton) {
    case "Continue":
      println("WAAAGH " + pause[startY]);
      gm.gameState = gm.gameStates[1];
      break;
    case"Retire":
      println("WAAAGH " + pause[startY]);
      gm.playerLost();
      break;
    case"Options":
      println("WAAAGH " + pause[startY]);
      break;
    case"Quit":
      exit();
      break;
    default:
      println("RUN YO GITZ");
      break;
    }
  }
}