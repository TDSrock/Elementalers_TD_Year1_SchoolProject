/**
 * Contains booleans that should be used globably for the keys
 * Please use these values instead of the built in crap
 * I've made these work nicely for us ahead of time
 *
 **/
class input_handler {
  public boolean upKey;
  public boolean downKey;
  public boolean leftKey;
  public boolean rightKey;
  public boolean actionKey;
  public boolean cancelKey;
  public boolean pauseKey;

  public boolean upKeyPressed;
  public boolean downKeyPressed;
  public boolean leftKeyPressed;
  public boolean rightKeyPressed;
  public boolean actionKeyPressed;
  public boolean cancelKeyPressed;
  public boolean pauseKeyPressed;

  public boolean upKeyMenuPressed;
  public boolean downKeyMenuPressed;
  public boolean leftKeyMenuPressed;
  public boolean rightKeyMenuPressed;
  public boolean actionKeyMenuPressed;
  public boolean cancelKeyMenuPressed;
  public boolean pauseKeyMenuPressed;

  public boolean upKeyReleased;
  public boolean downKeyReleased;
  public boolean leftKeyReleased;
  public boolean rightKeyReleased;
  public boolean actionKeyReleased;
  public boolean cancelKeyReleased;
  public boolean pauseKeyReleased;

  private boolean upKeyPrev;
  private boolean downKeyPrev;
  private boolean leftKeyPrev;
  private boolean rightKeyPrev;
  private boolean actionKeyPrev;
  private boolean cancelKeyPrev;
  private boolean pauseKeyPrev;
  
  public int actionKeyPresses = 0;

  input_handler() {
  }

  public void update() {
    upKeyPrev = upKey;
    downKeyPrev = downKey;
    leftKeyPrev = leftKey;
    rightKeyPrev = rightKey;
    actionKeyPrev = actionKey;
    cancelKeyPrev = cancelKey;
    pauseKeyPrev = pauseKey;

    if (keyPressed) {//A key is pressed, find out which!
      if (key == CODED) {
        upKey = (keyCode == UP);
        downKey = (keyCode == DOWN);
        leftKey = (keyCode == LEFT);
        rightKey = (keyCode == RIGHT);
      }
      actionKey = (key == 'z' || key == 'Z');
      cancelKey = (key == 'x' || key == 'X');
    } else {
      upKey = false;
      downKey = false;
      leftKey = false;
      rightKey = false;
      actionKey = false;
      cancelKey = false;
    }

    upKeyPressed = (upKey && upKeyPrev);
    upKeyReleased = (!upKey && upKeyPrev);
    upKeyMenuPressed = (upKey && !upKeyPrev);
    downKeyPressed = (downKey && downKeyPrev);
    downKeyReleased = (!downKey && downKeyPrev);
    downKeyMenuPressed = (downKey && !downKeyPrev);
    leftKeyPressed = (leftKey && leftKeyPrev);
    leftKeyReleased = (!leftKey && leftKeyPrev);
    leftKeyMenuPressed = (leftKey && !leftKeyPrev);
    rightKeyPressed = (rightKey && rightKeyPrev);
    rightKeyReleased = (!rightKey && rightKeyPrev);
    rightKeyMenuPressed = (rightKey && !rightKeyPrev);
    actionKeyPressed = (actionKey && !actionKeyPrev);
    actionKeyReleased = (!actionKey && actionKeyPrev);
    cancelKeyPressed = (cancelKey && !cancelKeyPrev);
    cancelKeyReleased = (!cancelKey && cancelKeyPrev);
  }
}