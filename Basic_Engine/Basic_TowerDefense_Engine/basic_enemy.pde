class basic_enemy extends moving_object {
  float radius = 25;
  int goingToNode;
  color enemyCLR;
  PVector nodeLocation;
  int listPlace;
  String type = "fire";
  float health;
  float fullHealth;
  int livesCost = 1;
  float bounty = 10;
  float maxHealth;
  ArrayList<node> myPath;
  
  //contructor
  basic_enemy(PVector Loc, float Radius, float TotalSpeed, float Health, String Type, float Bounty, int LifeCost) {
    //println(Health);
    location = new PVector(Loc.x, Loc.y);
    location = checkpointList.get(0).location;
    goingToNode = 1;
    totalSpeed = TotalSpeed;
    listPlace = enemyList.size();
    enemyList.add(this);
    //checkpointLocation = checkpointList.get(goingTocheckpoint).location;
    fullHealth = Health;
    health = Health;
    maxHealth = Health;
    type = Type;
    bounty = Bounty;
    livesCost = LifeCost;
    radius = Radius;
    switch(type){
      case "air": enemyCLR = color(198,191,255,200);
      break;
      case "water": enemyCLR = color(29,30,250,200);
      break;
      case "fire": enemyCLR = color(254,0,0,200);
      break;
      case "nature": enemyCLR = color(1,168,0,200);
      break;
      case "light": enemyCLR = color(255,225,79,200);
      break;
      case "dark": enemyCLR = color(78,0,114,200);
      break;
      default: enemyCLR = color(150);
      break;    
    }
    myPath = gw.gr.fetchTotalPath();
  }

  void update() {
    if(!destroy){//avoiding a weird checkpoint reached destroy bug
      nodeLocation = new PVector(myPath.get(goingToNode).location.x, myPath.get(goingToNode).location.y);
      goalReached = moveTowardsPoint(nodeLocation);
      if( goalReached ){
         goingToNode++;
         if(goingToNode > myPath.size() - 1){//finished apperently
           destroy = true;
           println(this + " has gotten past your defenses!");
         }
      }
      if (health <= 0){
          destroy = true;
      }
    }
    
  }
  void drawing() {
    /*textAlign(CENTER,CENTER);
    text(checkpointLocation.x + "checkpoint x / checkpoint y" + checkpointLocation.y,location.x, location.y - 40);
    text(directionVector.x + "direction vector .x / .y" + directionVector.y ,location.x, location.y - 60);
    //text(degrees(direction) ,location.x, location.y - 80);
    
    text(location.x + " x / y" + location.y ,location.x, location.y - 20);*/
    strokeWeight(1);
    stroke(0);
    fill(enemyCLR);
    ellipse(location.x, location.y, radius * 2, radius * 2);
    fill (0);
    if(health != fullHealth){
      gw.ui.drawHealthbar(new PVector(location.x- 20, location.y - radius / 2 - 15), new PVector(location.x + 20, location.y - radius / 2 - 5), health, fullHealth);
    }
  }
  
  void destroy() {
    listPlace = enemyList.indexOf(this);
    enemyList.remove(listPlace);
    if (health <= 0){
      playerCurrency += bounty;
      sm.increaseScore(bounty);
    }else{
      playerLives -= livesCost;
      if(playerLives <= 0){
        gm.playerLost();
      }
    }
    //new basic_enemy(checkpointList.get(0).location, 60);//spawn a new enemy at the start with speed 60
  }
}