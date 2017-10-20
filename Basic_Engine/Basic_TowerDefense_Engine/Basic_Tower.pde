
class Basic_Tower extends object {
  PVector arrayLocation;
  float towerWidth = 32;
  float towerHeight = 32;
  color towerColor = color(190, 190, 10, 100);
  color rangeClr = color(0, 0, 255);
  ArrayList<basic_enemy> targets = new ArrayList<basic_enemy>();//-1 means no target, 0 or higher is the target currently shooting at.
  basic_enemy mostRecentTarget;
  int listPlace;
  float start;
  float nextSpawn = 0;
  PVector boxP1;
  PVector boxP2;
  boolean madeThisWave = true;//for selling, if made this wave player gets a full refund
  boolean hoveredOver = false;
  boolean combinationAviable = false;//wheiter or not this tower can combine into something.

  int kills = 0;
  float damageDealt = 0;
  float damageDealtAoE = 0;
  float damageDealtTotal = 0;

  PImage img;
  PImage combPossibleImg = loadImage("combPossibleMarker.png");

  String filePath;

  //combine stuff
  ArrayList<Basic_Tower> combineTowerList = new ArrayList<Basic_Tower>();//towers I may combine with
  ArrayList<ArrayList<Class>> myCombinationsList = new ArrayList<ArrayList<Class>>();//list of ALL my combinations
  ArrayList<ArrayList<Class>> validCombineList = new ArrayList<ArrayList<Class>>();//List of combinations I can turn into currently
  ArrayList<ArrayList<Class>> invalidCombineList = new ArrayList<ArrayList<Class>>();//Contains the rest. This is mainly done so displaying it is easy.
  boolean checkCombineList = true;

  //stats
  float value = 100;//for selling the tower. Update the value acordingly(defaulting this to 100 for testing purposes
  float cost;//for the primary elements their purchase cost. For all others it's the combine cost.
  String type;
  float projectileSpeed;
  float projectileAcceleration;
  float range;
  float fireRate;
  float damage;
  int numberOfTargets;
  float AoE;
  String[] effects;
  int[] effectEffectivenes;

  //for pathfinding
  ArrayList<node> myNodes = new ArrayList<node>();

  Basic_Tower(PVector Loc, boolean isSlave) {
    //println(this);
    location = new PVector(Loc.x, Loc.y);
    if (!isSlave) {
      boxP1 = new PVector(location.x - towerWidth / 2, location.y - towerHeight / 2);
      boxP2 = new PVector(location.x + towerWidth / 2, location.y + towerHeight / 2);
      if (location.x != Float.MAX_VALUE)
        arrayLocation = new PVector((int)((Loc.x - gw.location.x - gw.cellWidth) / gw.cellWidth ), (int)((Loc.y - gw.location.y - gw.cellHeigth) / gw.cellHeigth ));
      if (location.x != Float.MAX_VALUE) {//exclude the block tower that is used for the UI's reset(that tower is placed at float.max, float.max)
        for (int x=0; x < 2; x++) {
          for (int y=0; y < 2; y++) {
            //println(gw + " gw / gr " + gw.gr);
            gw.gr.nodeArray[(int)arrayLocation.x + x][(int)arrayLocation.y+ y].disable();
            myNodes.add(gw.gr.nodeArray[(int)arrayLocation.x + x][(int)arrayLocation.y+ y]);
          }
        }
        //update the 12 nodes around the tower, just to make sure they don't make connections through towers
        for (int x = -1; x < 3; x++) {
          for (int y = -1; y < 3; y++) {
            if (!(arrayLocation.x + x < 0 || arrayLocation.x + x > gw.gr.arrayWidth - 1 ||
              arrayLocation.y + y < 0 || arrayLocation.y + y > gw.gr.arrayHeigth - 1)) {
              node n = gw.gr.nodeArray[(int)arrayLocation.x + x][(int)arrayLocation.y+ y];
              if (n.enabled) {
                n.update(boxP1, boxP2);
              }
            }
          }
        }
      }
      listPlace = towerList.size();
      towerList.add(this);
      //println("tower built at x / y " + location.x + " /  " + location.y);
      int towers = towerList.size();
      for (int i = 0; i < towers; i++) {
        Basic_Tower tower = towerList.get(i);
        if (tower == this) {
          this.combineTowerList.add(this);//add self to the list. ths makes doing the combine logic easier.
          break;
        }
        if (collision_helper.BC_collision(tower.boxP1, tower.boxP2, location, towerWidth + 2)) {
          this.combineTowerList.add(tower);
          tower.combineTowerList.add(this);
          tower.checkCombineList = true;
        }
      }
      //time to fetch my combinations
      int combinations = cm.combinations;//fetch number of combinations that exsist
      for (int i = 0; i < combinations; i++) {
        int requirements = cm.combinationList.get(i).size();
        for (int j = 1; j < requirements; j++) {//we skip the first index so we start at j = 1
          Class c = cm.combinationList.get(i).get(j);//fetch the class at index
          //println(cm.combinationList.get(i) + " " + i);
          if (c.isInstance(this)) {
            //we found out that we are part of this combination so add it to our internal list
            myCombinationsList.add(new ArrayList<Class>(cm.combinationList.get(i)));
            break;//go to next index
          }
        }
      }
      if (gw.gr != null) {
        try {
          gw.gr.updateTotalPath();
        } 
        catch (impossiblePathException e) {
          println(e + " " + e.getMessage() + " in tower constructor");
          this.sell();
          em.generateError("Your tower would block the path!", 2000);
        }
      }
    } else {
      objectList.remove(this);//due to extending from object we have already added ourselves too the object list. We actualy don't want to be in that list :/ this is a RARE exception though so it's fine.
      towerDataSlaves.add(this);//you are a slave, add yourself to the list!
    }
  }

  public void update() {
    if (checkCombineList) {
      checkCombineList();
      checkCombineList = false;
    }


    if (nextSpawn < millis()) {

      if (targets.size() < numberOfTargets) {
        targets = acuireTargets(numberOfTargets);
      }
      if (targets.size() > 0) {
        se.playSound(filePath);
        nextSpawn = fireRate + millis();
        for (basic_enemy t : targets) {
          new projectile(location, projectileSpeed, projectileAcceleration, damage, AoE, type, t, this);//projectile(location.x, location.y, mostRecentTarget.location.x, mostRecentTarget.location.y);
        }
      }
    }

    if (targets.size() > 0) {
      for (int i = targets.size() - 1; i >= 0; i--) {
        basic_enemy r = targets.get(i);
        if (r.destroy) {
          targets.remove(r);
        }
        if (!collision_helper.CC_collision(r.location, r.radius, location, range)) {//target moved out of range
          targets.remove(r);
        }
      }
    }
  }

  private ArrayList<basic_enemy> acuireTargets(int targetsToGet) {
    //println(enemyList.size());
    ArrayList<basic_enemy> targets = new ArrayList<basic_enemy>();
    for (int i = 0; i < enemyList.size(); i++) {
      basic_enemy enemyTesting = enemyList.get(i);
      //println(enemyTesting + "the enenmy at index: " + i + " his listNumber is: " + enemyTesting.listPlace);
      if (collision_helper.CC_collision(enemyTesting.location, enemyTesting.radius, location, range)) {
        targets.add(enemyTesting);//found a target
      }
      if (targets.size() == targetsToGet) {
        break;
      }
    }
    return targets;
  }
  //check the list, see if there are combinations that are valid. If so place them there. If not place them in the invalid list.
  public void checkCombineList() {

    ArrayList<Class> myClasses = new ArrayList<Class>();
    for (Basic_Tower t : combineTowerList) {//move data from combineTowerList to classes. this makes checking stuff easier
      myClasses.add(t.getClass());
    }

    //clear both lists we start from scratch
    validCombineList.clear();
    invalidCombineList = new ArrayList<ArrayList<Class>>(myCombinationsList);//assume everything is invalid
    //Figure out what we have exactly with class/count pairs
    for (ArrayList<Class> s : myCombinationsList) {
      ArrayList<Class> myClassesDupe = new ArrayList<Class>(myClasses);//dupe this list. We'll remove stuff from it that way we won't count the same tower twice.
      int requirements = s.size() - 1;
    currentCombination:
      for (Class c : s) {
        if (myClassesDupe.contains(c)) {
          requirements--;
          myClassesDupe.remove(c);//prevent confirming the same thing over and over again
          if (requirements == 0) {
            validCombineList.add(s);
            break currentCombination;
          }
        }
      }
    }

    int n = 0;
    combinationAviable = (validCombineList.size() >= 1); //if there are any combinations possible, it is True
  }

  public void drawing() {
    if (img == null) {
      //dit tekent de tower zelf,
      strokeWeight(1);
      stroke(0);
      fill(towerColor);
      rectMode(CENTER);
      rect(location.x, location.y, towerWidth, towerHeight);
    } else {
      imageMode(CENTER);
      image(img, location.x, location.y, towerWidth, towerHeight);
    }
    strokeWeight(1);
    stroke(126);//draw a grey line between me and target, if there is a target
    fill(126);
    if (targets.size() != 0) {
      for (basic_enemy l : targets) {
        line(location.x, location.y, l.location.x, l.location.y);
      }
    }

    if (combinationAviable) {
      imageMode(CORNER);
      image(combPossibleImg, location.x, location.y, towerWidth / 1.5, -towerHeight / 1.5);
    }

    if (hoveredOver) {
      // draw range
      fill(0, 0, 0, 0);
      stroke(rangeClr);
      rectMode(CORNERS);
      arc(location.x, location.y, range * 2, range * 2, 0, PI * 2);
      hoveredOver = false;//just set this to false after drawing. I think that should make sure we don't draw the range after mp has moved on.
    }


    /*int towers = combineTowerList.size();
     for(int i = 0; i < towers; i++){
     Basic_Tower tower = combineTowerList.get(i);
     line(tower.location.x, tower.location.y, location.x, location.y);
     }*/
  }

  public void sell() {
    if (madeThisWave) {
      playerCurrency += value;
    } else {
      playerCurrency += (int)(value / 2);
    }
    destroy = true;
  }

  void destroy() {
    for (Basic_Tower t : combineTowerList) {
      if (t == this) continue;
      t.combineTowerList.remove(this);
      t.checkCombineList();
    }
    listPlace = towerList.indexOf(this);
    try {
      towerList.remove(listPlace);
    }
    catch(Exception e) {
      println(e);
    }
    for (node n : myNodes) {
      n.enable();
    }
    try {
      gw.gr.updateTotalPath();
    }
    catch(impossiblePathException e) {
      println(e);
    }
  }
}