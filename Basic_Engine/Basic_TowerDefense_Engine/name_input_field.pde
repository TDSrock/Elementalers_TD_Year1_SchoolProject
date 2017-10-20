class name_input_field {

  String[][] keyBoard = {
    {"A", "B", "C", "D", "E", " ", "a", "b", "c", "d", "e"}, 
    {"F", "G", "H", "I", "J", " ", "f", "g", "h", "i", "j"}, 
    {"K", "L", "M", "N", "O", " ", "k", "l", "m", "n", "o"}, 
    {"P", "Q", "R", "S", "T", " ", "p", "q", "r", "s", "t"}, 
    {"U", "V", "W", "X", "Y", " ", "u", "v", "w", "x", "y"}, 
    {"Z", "[", "]", "^", "_", " ", "z", "{", "}", "|", "~"}, 
    {"0", "1", "2", "3", "4", " ", "!", "#", "$", "%", "&"}, 
    {"5", "6", "7", "8", "9", " ", "(", ")", "*", "+", "-"}, 
    {"/", "=", "@", "<", ">", " ", ":", ";", " ", " ", "OK"}, 
  };

  PVector cursorLocation = new PVector(keyBoard.length / 2, keyBoard.length / 2);

  String name = "";
  float offsetX = 64;
  float offsetY = 64;
  float roomForName = 64;
  PVector nameLocation = new PVector(width / 2, roomForName * 2);
  PVector boxPossition = new PVector(width / 2 - keyBoard[0].length * offsetX / 2 + 1, height / 2 - keyBoard.length * offsetY / 2 + roomForName);
  boolean completed = false;
  void update() {

    if (ih.upKeyMenuPressed && cursorLocation.y > 0) {
      cursorLocation.y--;
    }

    if (ih.downKeyMenuPressed && cursorLocation.y < keyBoard.length - 1) {
      cursorLocation.y++;
    }

    if (ih.leftKeyMenuPressed && cursorLocation.x > 0) {
      cursorLocation.x--;
    }

    if (ih.rightKeyMenuPressed && cursorLocation.x < keyBoard[(int)cursorLocation.y].length - 1) {
      cursorLocation.x++;
    }
    if (ih.actionKeyPressed) {
      String button = keyBoard[(int)cursorLocation.y][(int)cursorLocation.x];
      println(button);
      if (button.length() == 1) {
        if(!button.equals(" ")){
          if(name.length() < 12 ){
            name += button;
          }
        }
      } else {
        ih.actionKeyPresses = 0;
        completed = true;
      }
    }
    if (ih.cancelKeyPressed) {
      if (name.length() > 0) {
        name = name.substring(0, name.length()-1);
      }
    }
  }

  void drawing() {
    background(gm.bg);
    textAlign(CENTER, CENTER);
    fill(126, 200);
    stroke(255, 255);
    rectMode(CORNERS);
    rect(boxPossition.x, boxPossition.y - roomForName * 2, boxPossition.x + offsetX * keyBoard[0].length, boxPossition.y + offsetY * keyBoard.length);
    fill(0,255);
    text("Please enter your name", nameLocation.x, nameLocation.y / 2);
    text(name, nameLocation.x, nameLocation.y);
    fill(0, 0);
    rectMode(CORNER);
    stroke(255,255);
    strokeWeight(3);
    rect(cursorLocation.x * offsetX + boxPossition.x, cursorLocation.y * offsetY + boxPossition.y, offsetX, offsetY );
    fill(0);
    stroke(0,255);
    for (int i = 0; i < keyBoard.length; i++) {
      for (int j = 0; j < keyBoard[i].length; j++) {
        textSize(30);
        if (i == keyBoard.length - 1 && j == keyBoard[i].length - 1) {
          textSize(28);//other size for the ok button
        }
        text(keyBoard[i][j], j * offsetX + boxPossition.x, i * offsetY + boxPossition.y, offsetX, offsetY);
      }
    }
  }
}