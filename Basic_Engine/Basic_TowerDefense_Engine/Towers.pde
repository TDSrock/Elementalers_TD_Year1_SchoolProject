class blocker_tower extends Basic_Tower{//this tower purely exsist to fill in the gaps when a combination is made. Made to sell or maintain the maze.
  public blocker_tower(PVector Loc, boolean isSlave){
   super(Loc, isSlave);
   cost = 0;//this is mainly to give this no sell value
   String[] effects = {
   };
   
   int[] effectEffectivenes = {
   };
   img = loadImage("blocker_tower.png");
   type = "nauture";//this won't do anythig but lol
   projectileSpeed = 9999999;
   projectileAcceleration = 999999;
   range = 0;//due to it's range being zero this tower shoulden't be able to do any damage
   fireRate = 99999999;
   damage = 1;
   numberOfTargets = 1;
   AoE = 0;
   value = 0;
  }
}

//ALL AIR TOWERS
class air_tower extends Basic_Tower {
  public air_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave); 
   cost = 100;
   String[] effects = {
   };
   
   int[] effectEffectivenes = {
   };
   img =  loadImage("Air.png");
   type = "air";
   filePath = "airTower.wav";
   projectileSpeed = 360;
   projectileAcceleration = 5;
   range = 175;
   fireRate = 1400;
   damage = 27.5;
   numberOfTargets = 1;
   AoE = 0;
  }
}

class cloud_tower extends Basic_Tower {
  public cloud_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave); 
   cost = 50;
   String[] effects = {
   };
   
   int[] effectEffectivenes = {
   };
   img = null;
   type = "air";
   filePath = "airTower.wav";
   projectileSpeed = 360;
   projectileAcceleration = 5;
   range = 162.5;
   fireRate = 1000;
   damage = 75;
   numberOfTargets = 1;
   AoE = 0;
  }
}

class inferno_tower extends Basic_Tower {
  public inferno_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave); 
    cost = 50;
    String[] effects = {
  };
   
    int[] effectEffectivenes = {
    };
    img = null;
    type = "air";
    filePath = "airTower.wav";
    projectileSpeed = 330;
    projectileAcceleration = 10;
    range = 160;
    fireRate = 1300;
    damage = 90;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class noxiouse_gas_tower extends Basic_Tower {
  public noxiouse_gas_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
  };
   
    int[] effectEffectivenes = {
    };
    img = null;
    type = "air";
    filePath = "airTower.wav";
    projectileSpeed = 90;
    projectileAcceleration = 50;
    range = 75;
    fireRate = 200;
    damage = 6;
    numberOfTargets = 10;
    AoE = 0;
  }
}

//ALL DARK TOWERS
class dark_tower extends Basic_Tower {
  public dark_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 100;
    String[] effects = {"slows"
    };
    
    int[] effectEffectivenes = {
    };
    img =  loadImage("Dark.png");
    type = "dark";
       filePath = "darkTower.flac";
    projectileSpeed = 260;
    projectileAcceleration = 5;
    range = 100;
    fireRate = 800;
    damage = 20;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class dark_gale_tower extends Basic_Tower {
  public dark_gale_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img =  null;
    type = "dark";
    filePath = "darkTower.flac";
    projectileSpeed = 180;
    projectileAcceleration = 15;
    range = 125;
    fireRate = 1150;
    damage = 95;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class will_o_wisp_tower extends Basic_Tower {//this tower should have a heafty burn effect instead of a damage of 40, the damage should probably be around 10 and the burns total damage around 50
  public will_o_wisp_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img =  null;
    type = "dark";
    filePath = "darkTower.flac";
    projectileSpeed = 180;
    projectileAcceleration = 10;
    range = 110;
    fireRate = 1175;
    damage = 40;
    numberOfTargets = 3;//lel this stat doesn't work yet so this litterly does nothing...
    AoE = 0;
  }
}

class space_tower extends Basic_Tower {
  public space_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img =  null;
    type = "dark";
    filePath = "darkTower.flac";
    projectileSpeed = 220;
    projectileAcceleration = 7.5;
    range = 140;
    fireRate = 1333;
    damage = 112.6;
    numberOfTargets = 1;
    AoE = 0;
  }
}

//ALL FIRE TWOERS
class fire_tower extends Basic_Tower {
  public fire_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 100;
    String[] effects = {
    };
     
    int[] effectEffectivenes = {
    };
    img =  loadImage("Fire.png");
    type = "fire";
    filePath = "fireTower.wav";
    projectileSpeed = 320;
    projectileAcceleration = 5;
    range = 125;
    fireRate = 1250;
    damage = 25;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class dragon_fire_tower extends Basic_Tower {
  public dragon_fire_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
     
    int[] effectEffectivenes = {
    };
    img = null;
    type = "fire";
    filePath = "fireTower.wav";
    projectileSpeed = 280;
    projectileAcceleration = 5;
    range = 110;
    fireRate = 1150;
    damage = 97;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class ember_tower extends Basic_Tower {
  public ember_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
     
    int[] effectEffectivenes = {
    };
    img = null;
    type = "fire";
    filePath = "fireTower.wav";
    projectileSpeed = 300;
    projectileAcceleration = 10;
    range = 75;
    fireRate = 400;
    damage = 42;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class holy_fire_tower extends Basic_Tower {
  public holy_fire_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
     
    int[] effectEffectivenes = {
    };
    img = null;
    type = "fire";
    filePath = "fireTower.wav";
    projectileSpeed = 605;
    projectileAcceleration = 12;
    range = 166;
    fireRate = 1666;
    damage = 142;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class magma_tower extends Basic_Tower {
  public magma_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
     
    int[] effectEffectivenes = {
    };
    img = null;
    type = "fire";
    filePath = "fireTower.wav";
    projectileSpeed = 340;
    projectileAcceleration = 2;
    range = 110;
    fireRate = 1250;
    damage = 105;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class radiation_tower extends Basic_Tower {
  public radiation_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
     
    int[] effectEffectivenes = {
    };
    img = null;
    type = "fire";
    filePath = "fireTower.wav";
    projectileSpeed = 900;
    projectileAcceleration = 50;
    range = 150;
    fireRate = 200;
    damage = 5.5;
    numberOfTargets = 10;
    AoE = 0;
  }
}

//ALL LIGHT TOWERS
class light_tower extends Basic_Tower {
  public light_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 100;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img =  loadImage("Light.png");
    type = "light";
       filePath = "lightTower.wav";
    projectileSpeed = 700;
    projectileAcceleration = 5;
    range = 200;
    fireRate = 2000;
    damage = 35;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class sand_tower extends Basic_Tower {
  public sand_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img = null;
    type = "light";
    filePath = "lightTower.wav";
    projectileSpeed = 420;
    projectileAcceleration = 5;
    range = 125;
    fireRate = 1300;
    damage = 97;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class soul_tower extends Basic_Tower {
  public soul_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img = null;
    type = "light";
    filePath = "lightTower.wav";
    projectileSpeed = 220;
    projectileAcceleration = 7.5;
    range = 140;
    fireRate = 1667;
    damage = 141;
    numberOfTargets = 1;
    AoE = 0;
  }
}

//ALL NATURE TOWERS
class nature_tower extends Basic_Tower {
  public nature_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 100;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img =  loadImage("Nature.png");
    type = "nature";
       filePath = "earthTower.mp3";
    projectileSpeed = 260;
    projectileAcceleration = 5;
    range = 125;
    fireRate = 1250;
    damage = 25;
    numberOfTargets = 1;
    AoE = 100;//this tower should have some AoE, add it once it's implemented :D
  }
}

class metal_tower extends Basic_Tower {
  public metal_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img = null;
    type = "nature";
    filePath = "earthTower.mp3";
    projectileSpeed = 300;
    projectileAcceleration = 5;
    range = 125;
    fireRate = 1250;
    damage = 100;
    numberOfTargets = 1;
    AoE = 120;//this tower should have some AoE, add it once it's implemented :D
  }
}

class plant_tower extends Basic_Tower {
  public plant_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img = null;
    type = "nature";
    filePath = "earthTower.mp3";
    projectileSpeed = 290;
    projectileAcceleration = 5;
    range = 133;
    fireRate = 1000;
    damage = 82;
    numberOfTargets = 1;
    AoE = 0;
  }
}

//ALL WATER TOWERS
class water_tower extends Basic_Tower {
  public water_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 100;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img =  loadImage("Water.png");
    type = "water";
       filePath = "waterTower.mp3";
    projectileSpeed = 310;
    projectileAcceleration = 5;
    range = 150;
    fireRate = 1000;
    damage = 20;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class ice_tower extends Basic_Tower {
  public ice_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img = null;
    type = "water";
    filePath = "waterTower.mp3";
    projectileSpeed = 340;
    projectileAcceleration = 2;
    range = 150;
    fireRate = 1300;
    damage = 100;
    numberOfTargets = 1;
    AoE = 150;
  }
}

class mud_tower extends Basic_Tower {
  public mud_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img = null;
    type = "water";
    filePath = "waterTower.mp3";
    projectileSpeed = 240;
    projectileAcceleration = 5;
    range = 130;
    fireRate = 1300;
    damage = 110;
    numberOfTargets = 1;
    AoE = 0;
  }
}

class steam_tower extends Basic_Tower {
  public steam_tower(PVector Loc, boolean isSlave){
    super(Loc, isSlave ); 
    cost = 50;
    String[] effects = {
    };
    
    int[] effectEffectivenes = {
    };
    img = null;
    type = "water";
    filePath = "waterTower.mp3";
    projectileSpeed = 640;
    projectileAcceleration = 5;
    range = 120;
    fireRate = 550;
    damage = 50;
    numberOfTargets = 1;
    AoE = 0;
  }
}