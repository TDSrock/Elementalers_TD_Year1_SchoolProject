class checkpoint extends object{
  int checkpointNumber;
  PVector arrayLocation;
  color checkpointColor;
  boolean firstFrame = true;
  PImage checkpointBase = loadImage("Checkpoint_image_1.png");
  PImage checkpointFlag;
  float checkpointImageSize = 24;
  float flagSize = 30;
  checkpoint(PVector Loc){
    checkpointNumber = checkpointList.size();
    /* if(checkpointNumber== 0){
      checkpointColor = color(0,200,0);//first checkpoint is green
    }*/
    arrayLocation = new PVector(Loc.x, Loc.y);
    location = new PVector(0,0);
    checkpointColor = color(0);
    //location = new PVector( gw.location.x + gw.cellWidth * arrayLocation.x, gw.location.y + gw.cellHeigth * arrayLocation.y); 
    checkpointList.add(this);
  }

  public void update(){
    if(checkpointNumber== 0){
      checkpointColor = color(0,200,0);//first checkpoint is green
    }
    if(checkpointNumber == checkpointList.size() - 1){
      checkpointColor = color(200,0,0);//last checkpoint is red
    }
    location = new PVector( gw.location.x + gw.cellWidth * arrayLocation.x + gw.cellWidth/2, gw.location.y  + gw.cellHeigth * arrayLocation.y + gw.cellHeigth / 2);
    
    if(firstFrame){//on the first frame, and the first frame only we need to place a node
      if(checkpointNumber == 0)
        checkpointFlag = loadImage("Checkpoint_Flag_start.png");
      if(checkpointNumber == checkpointList.size()-1){
        checkpointFlag = loadImage("Checkpoint_Flag_finish.png");
    }
    
    firstFrame = false;
    }
    
  }
  
  
  public void drawing(){
    //println(str(checkpointNumber) + "checkpoint is at " + str(location.x) + " x/y " + str(location.y) + " and array location : " + str(arrayLocation.x) + " x/y " + str(arrayLocation.y)); 
    fill(checkpointColor);
    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    imageMode(CENTER);
    image(checkpointBase, location.x, location.y, checkpointImageSize, checkpointImageSize);
    if(checkpointFlag == null){
      text(str(checkpointNumber), location.x, location.y, gw.cellWidth, gw.cellHeigth);
    }else {
      image(checkpointFlag, location.x + flagSize / 8.33, location.y - flagSize / 2.77, flagSize, flagSize);
    }
  }
  
}