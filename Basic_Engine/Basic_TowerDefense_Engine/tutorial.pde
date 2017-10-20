class tutorial {
  PImage [] tutorialScreens = { 
    loadImage ("tutscreen 1.png"), loadImage ("tutscreen 2.png"), loadImage ("tutscreen 3.png"), loadImage ("tutscreen 4.png")
  };
  int screenAmount = tutorialScreens.length;
  int tutScreenShowing = 0; //By default show tutorial screen 1;
  int previousState;

  public void update() {
    if (ih.leftKeyMenuPressed) {
      tutScreenShowing--;
      if (tutScreenShowing < tutorialScreens.length - tutorialScreens.length) {
        tutScreenShowing = tutorialScreens.length - 1;
      }
    }

    if (ih.rightKeyMenuPressed) {
      tutScreenShowing++;
      if (tutScreenShowing > tutorialScreens.length - 1) {
        tutScreenShowing = tutorialScreens.length - tutorialScreens.length;
      }
    }
    if (ih.cancelKeyPressed) {
         gm.setGameState(previousState);
       }
  }

  public void drawing() {
    //image (CENTER);
     
    image(tutorialScreens[tutScreenShowing], width/2, height/2);
    /*textAlign(CENTER);
    textSize(32);
    text( "Press arrowkeys to go to the next tutorialscreen or press 'x' to go back to the main menu" , width,height);*/
  }
}