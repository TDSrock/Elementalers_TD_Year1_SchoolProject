class projectile extends moving_object {

  color projectileClr = color(125);
  PVector checkpointLocation;
  boolean goalReached = false;
  basic_enemy target;
  basic_enemy aoeTarget;
  double accel = 0.5;
  int radius = 10;
  color clr = color(0, 255, 0);
  float elementModifier = 1.00;
  float baseModifier = 1.00;
  float baseDamage;
  float calculatedDamage;
  float finalDamage;
  float aoeSize;
  float aoeDamage;
  float distance;
  float totalAOEDamage = 0;
  String[] effects;
  Basic_Tower creator;

  //constructor
  projectile (PVector Loc, float TotalSpeed, float Accel, float Damage, float AoE, String Type, basic_enemy Target, Basic_Tower Creator ) {
    creator = Creator;
    location = new PVector(Loc.x, Loc.y);
    target = Target;
    totalSpeed = TotalSpeed;
    baseDamage = Damage;
    type = Type;
    accel = Accel;
    aoeSize = AoE;
  }

  float damageCalculation(float baseDamage) {
    //BALANCED Damage
    switch(type) {
    case "water": 
      switch(target.type) {
      case "water": 
        elementModifier = 1.00;
        break;
      case "fire": 
        elementModifier = 1.30;
        break;
      case "air": 
        elementModifier = 1.00;
        break;
      case "nature": 
        elementModifier = 0.70;
        break;
      case "light": 
        elementModifier = 1.00;
        break;
      case "dark": 
        elementModifier = 1.00;
        break;
      }
      break;
    case "fire":
      switch(target.type) {
      case "water": 
        elementModifier = 0.70;
        break;
      case "fire": 
        elementModifier = 1.00;
        break;
      case "air": 
        elementModifier = 0.70;
        break;
      case "nature": 
        elementModifier = 1.30;
        break;
      case "light": 
        elementModifier = 1.00;
        break;
      case "dark": 
        elementModifier = 1.30;
        break;
      }
      break;
    case "air":
      switch(target.type) {
      case "water": 
        elementModifier = 1.00;
        break;
      case "fire": 
        elementModifier = 1.30;
        break;
      case "air": 
        elementModifier = 1.00;
        break;
      case "nature": 
        elementModifier = 0.70;
        break;
      case "light": 
        elementModifier = 1.30;
        break;
      case "dark": 
        elementModifier = 0.70;
        break;
      }
      break;
    case "nature":
      switch(target.type) {
      case "water": 
        elementModifier = 1.30;
        break;
      case "fire": 
        elementModifier = 0.70;
        break;
      case "air": 
        elementModifier = 1.30;
        break;
      case "nature": 
        elementModifier = 1.00;
        break;
      case "light": 
        elementModifier = 1.00;
        break;
      case "dark": 
        elementModifier = 0.70;
        break;
      }
      break;
    case "light":
      switch(target.type) {
      case "water": 
        elementModifier = 1.00;
        break;
      case "fire": 
        elementModifier = 1.00;
        break;
      case "air": 
        elementModifier = 0.70;
        break;
      case "nature": 
        elementModifier = 1.00;
        break;
      case "light": 
        elementModifier = 1.00;
        break;
      case "dark": 
        elementModifier = 1.30;
        break;
      }
      break;
    case "dark":
      switch(target.type) {
      case "water": 
        elementModifier = 1.00;
        break;
      case "fire": 
        elementModifier = 0.70;
        break;
      case "air": 
        elementModifier = 1.30;
        break;
      case "nature": 
        elementModifier = 1.30;
        break;
      case "light": 
        elementModifier = 0.70;
        break;
      case "dark": 
        elementModifier = 1.00;
        break;
      }
      break;
    }
    calculatedDamage = baseDamage * elementModifier * baseModifier;
    return calculatedDamage;
  }

  void update() {
    totalSpeed +=accel;
    if (target == null) {
      destroy = true;
    } else {
      goalReached = moveTowardsPoint(target.location);
      if (goalReached) {
        int kills = 0;
        finalDamage = damageCalculation(baseDamage);        
        globalDamage += finalDamage;
        if (target.health <= 0 && !target.destroy) {
          kills++;
        }
        if (aoeSize > 0) {
          for (int i = 0; i < enemyList.size(); i++) {
            basic_enemy enemy = enemyList.get(i);
            if (enemy !=target) {
              if (collision_helper.PC_collision(enemy.location, location, aoeSize)) {
                distance = PVector.dist(enemy.location, this.location);
                aoeDamage = damageCalculation(baseDamage * (1 - (distance / aoeSize)));
                totalAOEDamage += aoeDamage;
                enemy.health -= aoeDamage;
                if (enemy.health <= 0 && !enemy.destroy) {
                  creator.kills++;
                }
              }
            }
          }
        }
        //println("Damage done = " + finalDamage);
        //println("AoE Damage done = " + totalAOEDamage);
        creator.damageDealt+=finalDamage;
        creator.damageDealtAoE+=totalAOEDamage;
        creator.damageDealtTotal+= (finalDamage + totalAOEDamage);
        gw.globalDamage+= (finalDamage + totalAOEDamage);
        creator.kills++;
        target.health -= finalDamage;
        destroy = true;
      }
    }
  }

  void drawing() {
    strokeWeight(1);
    stroke(0);
    fill(clr);
    ellipse(location.x, location.y, radius, radius);
  }
}