
class mouse_pointer extends object {
  //constructor

  float pointerWidth = 16;
  float pointerHeight = 16;
  color mouseClrNormal = color (255, 75, 25);
  color mouseClrDrag = color(75, 75, 255);
  color mouseClrFinal = mouseClrNormal;
  PVector arrayLocation;
  PVector drawLocation;
  PVector buildLocation;
  boolean inArray = true;
  boolean possitionChanged = true;
  boolean exitUI = false;
  boolean updateUI = true;
  int prevPointerMode = 0;
  int pointerMode = 0;//while in array the mousePointer mode will tell us what it is hovering over.
  int spacesToCheck = 2;
  int timer = 0;
  int startTimer = 0;
  int beginSpeed = 15;
  int minSpeed = 2;
  int jumpSpeed = beginSpeed;
  int speedIncrease = 10;
  //MousePointerMode legend: 0 empty buildable space, 1 non-buildable space ,2 a tower(the tower in question is stored in hoverTower)
  Basic_Tower hoverTower;//to store the tower we are hovering over on

  mouse_pointer(int startX, int startY) {
    arrayLocation = new PVector(startX, startY);
    drawLocation = new PVector(0, 0);
    buildLocation = new PVector(0, 0);
  }


  void update() {
    if (inArray && !gw.ui.combineList) {
      if (gw.ui.dragging) {
      towerLoop2:
        for (Basic_Tower tower : towerList) {
          for (int x=0; x<spacesToCheck; x++) {
            for (int y=0; y<spacesToCheck; y++) {
              PVector pointTesting = new PVector((drawLocation.x + pointerWidth / 2 + pointerWidth * x), (drawLocation.y + pointerHeight / 2 + pointerHeight * y));
              if (collision_helper.PB_collision(pointTesting, tower.boxP1, tower.boxP2)) {
                if (x == 0 && y == 0) {//where the pointer is now. If this collides with a tower, then that tower is being hovered over
                  gw.ui.placeable = false;
                  hoverTower = tower;
                  //println("breaking");
                  break towerLoop2;
                } else {//if it's any other point then building there we would collide with a tower. So we just don't give the option.
                  gw.ui.placeable = false;
                  //println("breaking");
                  break towerLoop2;
                }
              }
            }
          }
          //println("diden't break");
          gw.ui.placeable = true;
          ;//in the case the for loop has not reached the breakpoint, it means that all four spots are NOT occupied by a tower, so we can build a tower.
        }


        if (ih.upKeyPressed) {
          if (timer == startTimer) {
            arrayLocation.y--;
            timer++;
          } else {
            timer++;
            if (timer == jumpSpeed) {
              timer -= timer;
              jumpSpeed -= speedIncrease;
              if (jumpSpeed <= minSpeed) {
                jumpSpeed = minSpeed;
              }
            }
          }
          possitionChanged = true;
        }
        if (ih.upKeyReleased) {
          //println("Released");
          timer -= timer;
          jumpSpeed = beginSpeed;
        }

        if (ih.downKeyPressed) {
          if (timer == startTimer) {
            arrayLocation.y++;
            timer++;
          } else {
            timer++;
            if (timer == jumpSpeed) {
              timer -= timer;
              jumpSpeed -= speedIncrease;
              if (jumpSpeed <= minSpeed) {
                jumpSpeed = minSpeed;
              }
            }
          }
          possitionChanged = true;
        }
        if (ih.downKeyReleased) {
          //println("Released");
          timer -= timer;
          jumpSpeed = beginSpeed;
        }

        if (ih.leftKeyPressed) {
          if (timer == startTimer) {
            arrayLocation.x--;
            timer++;
          } else {
            timer++;
            if (timer == jumpSpeed) {
              timer -= timer;
              jumpSpeed -= speedIncrease;
              if (jumpSpeed <= minSpeed) {
                jumpSpeed = minSpeed;
              }
            }
          }
          possitionChanged = true;
        }
        if (ih.leftKeyReleased) {
          //println("Released");
          timer -= timer;
          jumpSpeed = beginSpeed;
        }
        if (ih.rightKeyPressed) {

          if (timer == startTimer) {
            arrayLocation.x++;
            timer++;
          } else {
            timer++;
            if (timer == jumpSpeed) {
              timer -= timer;
              jumpSpeed -= speedIncrease;
              if (jumpSpeed <= minSpeed) {
                jumpSpeed = minSpeed;
              }
            }
          }
          possitionChanged = true;
        }
        if (ih.rightKeyReleased) {
          //println("Released");
          timer -= timer;
          jumpSpeed = beginSpeed;
        }

        if (arrayLocation.x < 0) {
          arrayLocation.x = 0;
        }
        if (arrayLocation.y < 0) {
          arrayLocation.y = 0;
        }
        if (arrayLocation.x > gw.arrayWidth - 1) {
          arrayLocation.x = gw.arrayWidth - 1;
        }
        if (arrayLocation.y > gw.arrayHeigth - 1) {
          arrayLocation.y = gw.arrayHeigth - 1;
        }

        drawLocation.x = gw.location.x + gw.cellWidth * arrayLocation.x;
        drawLocation.y = gw.location.y + gw.cellHeigth * arrayLocation.y;//top left of the pointer

        buildLocation = new PVector(drawLocation.x + pointerWidth, drawLocation.y + pointerHeight);
      } else {
        if (ih.upKeyPressed) {
          if (timer == startTimer) {
            arrayLocation.y--;
            timer++;
          } else {
            timer++;
            if (timer == jumpSpeed) {
              timer -= timer;
              jumpSpeed -= speedIncrease;
              if (jumpSpeed <= minSpeed) {
                jumpSpeed = minSpeed;
              }
            }
          }
          possitionChanged = true;
        }
        if (ih.upKeyReleased) {
          //println("Released");
          timer -= timer;
          jumpSpeed = beginSpeed;
        }

        if (ih.downKeyPressed) {
          if (timer == startTimer) {
            arrayLocation.y++;
            timer++;
          } else {
            timer++;
            if (timer == jumpSpeed) {
              timer -= timer;
              jumpSpeed -= speedIncrease;
              if (jumpSpeed <= minSpeed) {
                jumpSpeed = minSpeed;
              }
            }
          }
          possitionChanged = true;
        }
        if (ih.downKeyReleased) {
          //println("Released");
          timer -= timer;
          jumpSpeed = beginSpeed;
        }

        if (ih.leftKeyPressed) {
          if (timer == startTimer) {
            arrayLocation.x--;
            timer++;
          } else {
            timer++;
            if (timer == jumpSpeed) {
              timer -= timer;
              jumpSpeed -= speedIncrease;
              if (jumpSpeed <= minSpeed) {
                jumpSpeed = minSpeed;
              }
            }
          }
          possitionChanged = true;
        }
        if (ih.leftKeyReleased) {
          //println("Released");
          timer -= timer;
          jumpSpeed = beginSpeed;
        }
        if (ih.rightKeyPressed) {

          if (timer == startTimer) {
            arrayLocation.x++;
            timer++;
          } else {
            timer++;
            if (timer == jumpSpeed) {
              timer -= timer;
              jumpSpeed -= speedIncrease;
              if (jumpSpeed <= minSpeed) {
                jumpSpeed = minSpeed;
              }
            }
          }
          possitionChanged = true;
        }
        if (ih.rightKeyReleased) {
          //println("Released");
          timer -= timer;
          jumpSpeed = beginSpeed;
        }

        if (arrayLocation.x < 0) {
          arrayLocation.x = 0;
        }
        if (arrayLocation.y < 0) {
          arrayLocation.y = 0;
        }
        if (arrayLocation.x > gw.arrayWidth - 1) {
          arrayLocation.x = gw.arrayWidth - 1;
        }
        if (arrayLocation.y > gw.arrayHeigth - 1) {
          arrayLocation.y = gw.arrayHeigth - 1;
        }

        drawLocation.x = gw.location.x + gw.cellWidth * arrayLocation.x;
        drawLocation.y = gw.location.y + gw.cellHeigth * arrayLocation.y;//top left of the pointer

        buildLocation = new PVector(drawLocation.x + pointerWidth, drawLocation.y + pointerHeight);
        if (!exitUI) {
          if (possitionChanged) {
            //println("possition changed");
            prevPointerMode = pointerMode;
            if (pointerMode != 3) {
            towerLoop:
              for (Basic_Tower tower : towerList) {
                for (int x=0; x<spacesToCheck; x++) {
                  for (int y=0; y<spacesToCheck; y++) {
                    PVector pointTesting = new PVector((drawLocation.x + pointerWidth / 2 + pointerWidth * x), (drawLocation.y + pointerHeight / 2 + pointerHeight * y));
                    if (collision_helper.PB_collision(pointTesting, tower.boxP1, tower.boxP2)) {
                      if (x == 0 && y == 0) {//where the pointer is now. If this collides with a tower, then that tower is being hovered over
                        pointerMode = 2;
                        hoverTower = tower;
                        //println("breaking");
                        break towerLoop;
                      } else {//if it's any other point then building there we would collide with a tower. So we just don't give the option.
                        pointerMode = 1;
                        //println("breaking");
                        break towerLoop;
                      }
                    }
                  }
                }
                //println("diden't break");
                pointerMode = 0;//in the case the for loop has not reached the breakpoint, it means that all four spots are NOT occupied by a tower, so we can build a tower.
              }
            }
            if (pointerMode == 0) {//faster to make this into two if statements then checking it after pointermode gets set to 0 above.
              if (arrayLocation.y == gw.arrayHeigth - 1 || arrayLocation.x == gw.arrayWidth - 1) {//bottom row and most right collum would place towers outside the array so lets catch them out. But we WILL let the player travel there with the cursor.
                pointerMode = 1;
              } else {
                for (int x=0; x<spacesToCheck; x++) {
                  for (int y=0; y<spacesToCheck; y++) {
                    if (gw.gameGrid[(int)arrayLocation.x + x][(int)arrayLocation.y + y] != 0) {//if any of the four spots is a checkpoint we can't build there either. Soo
                      pointerMode = 1;
                      //we are done with both these loops. just breaking the loop won't be good enough we are overiding both values
                      y+=spacesToCheck;
                      x+=spacesToCheck;
                    }
                  }
                }
              }
            }
            //println("Pointer mode after update: " + pointerMode + " Pointer mode before update: " + prevPointerMode);
            possitionChanged = false;
            updateUI = true;
          }
        } else {
          possitionChanged = true; 
          exitUI = false; 
          //println("exited ui");
        }
      }
      if (pointerMode == 2) {
        hoverTower.hoveredOver = true;//if we are hovering over a tower, tell that tower about it.
      }
    }
    gw.ui.update();
    updateUI = false;
    if (gw.ui.pauseButton) {
      gm.gameState = gm.gameStates[2];
      gw.ui.pauseButton = false;
      //Zorgt ervoor dat het bij elke Pause op de Eerste button staat
      pm.startY = 0;
    }
  }

  void drawing() {
    rectMode (CORNER);
    fill(0, 0, 0, 0);
    stroke(mouseClrFinal);
    strokeWeight(3);
    if (gw.ui.dragging) {
      rect(drawLocation.x, drawLocation.y, pointerWidth * 2, pointerHeight * 2);
    } else {
      rect(drawLocation.x, drawLocation.y, pointerWidth, pointerHeight );
    }
    gw.ui.drawing();
  }
}