class error {
  color errorCLR;
  float time;
  float timeLeft;
  String text;
  int listPlace;

  error(String Text, float DispTime) { 
    text = Text;
    time = DispTime;
    timeLeft = millis();
    em.errorList.add(this);
  }

  void update() {
    if (timeLeft < millis() - time) {
      listPlace = em.errorList.indexOf(this);
      em.errorList.remove(listPlace);
    }
  }
}

class error_manager {
  int warningBoxHeight = 40;
  int warningBoxWidth = 400;
  int lineSpacing;
  String[] multipleLines;
  String[] previousLines;
  ArrayList<error> errorList = new ArrayList<error>();  

  void generateError (String errorText, float errorTime) {
    new error(errorText, errorTime);
  }

  void drawing() {
    for (int i = 0; i < errorList.size(); i++) {
      error currentError = errorList.get(i);
      currentError.update();
      if (i > 0) {
        error previousError = errorList.get(i - 1);
        if (previousError.text.contains("<<^")) {
          previousLines = split(previousError.text, "<<^");
          lineSpacing = 20 * previousLines.length;
        } else {
          lineSpacing = 0;
        }
      } else {
        lineSpacing = 0;
      }
      if (currentError.text.contains("<<^")) {
        multipleLines = split(currentError.text, "<<^");
        rectMode(CENTER);
        stroke(0);
        strokeWeight(2);
        fill(255, 0, 0, 200);
        rect(width/2, (height/2 - 50) + (i * 50) - 20 * errorList.size() + lineSpacing, 9 * currentError.text.length(), warningBoxHeight + 20 * multipleLines.length);
        for (int e = 0; e < multipleLines.length; e++) {
          textSize(16);
          fill(255, 255);
          textAlign(CENTER, CENTER);
          text(multipleLines[e], width/2, (height/2 - 50) + (i * 50) - (20 * errorList.size()) + (20 * e)  + lineSpacing);
        }
      } else {
        rectMode(CENTER);
        stroke(0);
        strokeWeight(2);
        fill(255, 0, 0, 200);
        rect(width/2, (height/2 - 50) + (i * 50) - 20 * errorList.size() + lineSpacing, 9 * currentError.text.length(), warningBoxHeight);
        textSize(16);
        fill(255, 255);
        textAlign(CENTER, CENTER);
        text(currentError.text, width/2, (height/2 - 50) + (i * 50) - 20 * errorList.size() + lineSpacing);
      }
    }
  }
}