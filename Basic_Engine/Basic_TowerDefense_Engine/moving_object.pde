
class moving_object extends object {
  PVector directionVector;
  float totalSpeed = 5;//default speed
  PVector speed;
  float direction;
  boolean goalReached = false;
  float frameSpeed;
  float halfFrameSpeed;
  String type = "basic";

  public moving_object() {
  }

  public boolean moveTowardsPoint(PVector goal) {
    halfFrameSpeed = frameSpeed / 2;

    if (collision_helper.PB_collision(location, new PVector(goal.x - frameSpeed, goal.y - frameSpeed), new PVector(goal.x + frameSpeed, goal.y + frameSpeed))) {
      location = goal;
      speed = new PVector(0, 0);//move too the checkpoint and set speed to 0 for the frame.
      return true;
    }

    directionVector = PVector.sub(goal, location).normalize();
    speed = calculateSpeedVector(directionVector, totalSpeed);
    //dedicate movement
    location.add(speed);
    return false;
  }

  public boolean pathFindTowardsPoint(PVector goal) {
    if ( goal.x - frameSpeed <= goal.x && location.y - frameSpeed <= goal.y
      &&  goal.x + frameSpeed >= goal.x && location.y + frameSpeed >= goal.y) {
      return true;
    }

    directionVector = PVector.sub(goal, location).normalize();
    speed = calculateSpeedVector(directionVector, totalSpeed);
    //dedicate movement
    location.add(speed);
    return false;
  }

  public PVector calculateSpeedVector(PVector DirectionVector, float TotalSpeed) {
    PVector r = new PVector(0, 0);
    frameSpeed = TotalSpeed / frameRate;//this debinds framerate and movementspeed This also means speeds to remain the same as the orginal test of 1.5 should be around 90. These two speeds SHOULD be about the same.
    r = DirectionVector.mult(frameSpeed);
    return r;
  }
}