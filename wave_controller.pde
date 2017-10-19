class wave_controller {
  int enemyAmount = 8;
  int currentAmount;
  boolean spawning = false;
  boolean spawning1 = false;
  boolean spawning2 = false;
  boolean spawningBoss = false;
  boolean preWave = false;
  float nextSpawn;
  float nextSpawn2;
  float nextSpawnBoss;
  boolean waveDone = false;
  int offset = 380;
  int space = 20;
  int standardHeight = 20;
  int spawned = 0;
  int spawned2 = 0;
  PVector healthBar = new PVector((width - 200), height - 220);
  PVector healthBar2 = new PVector(width - 50, height - 190);

  int waveCounter = 0;

  float currentWaveHealth = 0;

  //method variables HERE float nextSpawn, float delay, int numberOfEnemies, float speed, float waveHealth, String type

  float standardRadius = 12.5;
  int healthScaler = 100;
  float waveBounty = 110;

  float[][] waveDataFloat ={
    //delay array!
    {500, 1500, 1000, 1000, 1000, 1000, 500, 500, 500, 500, 750, 750, 500}, //13
    //speed array!
    {200, 100, 125, 150, 100, 133, 166, 100, 125, 150, 175, 150, 200, 180 }, //13
    //baseHealth array!
    {10500, 1500, 2500, 3000, 4000, 4500, 5500, 5500, 6500, 7500, 8500, 9000, 7000,}, //13
  };

  int[][] waveDataInt ={
    // numberOfEnemies Array!
    {6, 8, 8, 5, 9, 9, 5, 10, 10, 6, 5, 3, 6}, //13
    // numberOfEnemies2 Array!
    {6, 0, 0, 5, 0, 0, 5, 0 , 0 , 6, 5, 3, 6}, //13
    // bossAmount Array!
    {4, 0, 0, 0, 0, 0, 0, 0,  0,  0, 1, 0, 2}, //13
  };

  boolean[][] waveDataBoolean ={
    //spawning1 here!
    {true, true, true, true, true, true, true, true, true, true, true, true, true, true}, //13
    //spawning2 here!
    {true, false, false, true, false, false, true, false, false, true, true, true, true}, //13
    //spawningBoss here!
    {true, false, false, false, false, false, false, false, false, false, true, false, true}, //13
  };

  String[][]waveDataString ={
    // type1 here!
    {"dark", "air", "water", "air", "fire", "nature", "fire", "light", "dark", "light", "dark", "water","nature" }, //13
    // type2 here!
    {"light", "none", "none", "water", "none", "none", "nature", "none", "none", "dark", "fire", "dark", "nature"}, //13
    // typeBoss here!
    {"dark", "none", "none", "none", "none", "none", "none", "none", "none", "none", "water", "none", "nature"}, //13
  };
  
  int amountOfWaves = waveDataString[0].length;
  /*String type;
  String type2;
  String typeBoss;
  int random;
  int random2;
  int randomBoss;*/



  // ALL OF THIS SHIT NEEDS TO GO GOD DAMNIT
  float delay;
  int numberOfEnemies;
  float speed;
  float waveTotalHealth;
  float enemyHealth;
  boolean secondEnemy;
  boolean bossWave;
  String bossType;
  int bossAmount = 0;
  int bossSpawned = 0;
  float bounty = 10;

  float waveFinalHealth;
  int lifeCost;
  int waveLifeCost = 1;


  //constructor
  wave_controller() {
  }  

  public void update() {
    //event for math stuff i want to run every frame
    currentAmount = enemyList.size();
    drawing(); 
    if (currentAmount > 0) {
      waveDone = false;
    } else {
      waveDone = true;
    }

    if (waveDone && !spawning && preWave) {
      println("Wave Ended!");
      playerCurrency += 100;
      
      gw.em.endOfWaveCheck();

      /*random = int(random(6));
      switch(random) { //no idea whay went wrong here
      case 0: 
        type = "air";
        break;
      case 1:
        type = "water";
        break;
      case 2:
        type = "fire";
        break;
      case 3:
        type = "nature";
        break;
      case 4:
        type = "light";
        break;
      case 5:
        type = "dark";
        break;
      default:
        println("something broke in the wave controller, please help");
        break;
      }
      random2 = int(random(6));
      switch(random2) {
      case 0: 
        type2 = "air";
        break;
      case 1:
        type2 = "water";
        break;
      case 2:
        type2 = "fire";
        break;
      case 3:
        type2 = "nature";
        break;
      case 4:
        type2 = "light";
        break;
      case 5:
        type2 = "dark";
        break;
      default:
        println("something went horribly wrong, your waves are cubes now, enjoy!");
        break;
      }
      randomBoss = int(random(6));
      switch(randomBoss) {
      case 0: 
        typeBoss = "air";
        break;
      case 1:
        typeBoss = "water";
        break;
      case 2:
        typeBoss = "fire";
        break;
      case 3:
        typeBoss = "nature";
        break;
      case 4:
        typeBoss = "light";
        break;
      case 5:
        typeBoss = "dark";
        break;
      default:
        println("Something is seriously out of whack, your bosses are Cubes now, enjoy!");
        break;
      }*/
      preWave = false;
    }

    if (gw.ui.nextWave && waveDone && !spawning) {
      if (waveCounter%10 == 0) {
        waveBounty*= 1.4;
        healthScaler*= 1.75;
      }
      waveCounter++;
      for (Basic_Tower t : towerList) {
        t.madeThisWave = false;
      }

      lifeCost = (int)floor(waveLifeCost / (waveDataInt[0][waveCounter%amountOfWaves] + (waveDataInt[1][waveCounter%amountOfWaves] + (waveDataInt[2][(waveCounter)%amountOfWaves]))));
      if (lifeCost <= 0) {
        lifeCost = 1;
      }

      nextSpawn = millis(); // -_-
      nextSpawn2 = nextSpawn + (waveDataFloat[0][waveCounter%amountOfWaves] / 2);
      nextSpawnBoss = nextSpawn + (waveDataFloat[0][waveCounter%amountOfWaves] * 1.5);
      println("New Wave spawning");
      spawning = true;
      gw.ui.nextWave = false;
      preWave = true;
    }
    if (spawning) {
      if (waveDataBoolean[0][waveCounter%amountOfWaves]) {
        spawning1 = true;
        if (spawning1) {
          if (nextSpawn < millis()) {
            nextSpawn += waveDataFloat[0][waveCounter%amountOfWaves];
            //      waveTotalHealth = baseHealth1 + healthScaler * waveCounter;   enemyHealth = waveTotalHealth / numberOfEnemies;                                                                                                                                                                                  bounty = waveBounty / numberOfEnemies;                                                                           
            new basic_enemy( checkpointList.get(0).location, standardRadius, waveDataFloat[1][waveCounter%amountOfWaves], (waveDataFloat[2][waveCounter%amountOfWaves] + (healthScaler * waveCounter)) * gw.mapDifModifier / (waveDataInt[0][waveCounter%amountOfWaves] + (waveDataInt[1][waveCounter%amountOfWaves] + (waveDataInt[2][(waveCounter)%amountOfWaves]))), waveDataString[0][waveCounter%amountOfWaves], waveBounty / (waveDataInt[0][waveCounter%amountOfWaves] + (waveDataInt[1][waveCounter%amountOfWaves] + (waveDataInt[2][waveCounter%amountOfWaves]))), lifeCost);
            spawned++;
          }
          if (waveDataInt[0][waveCounter%amountOfWaves] <= spawned) {  
            spawning1 = false;
          }
        }
      }
      if (waveDataBoolean[1][waveCounter%amountOfWaves]) {//Enemy 2
        spawning2 = true;
        //Enemy 2
        if (spawning2) {
          if (nextSpawn2 < millis()) {
            nextSpawn2 += waveDataFloat[0][waveCounter%amountOfWaves];
            new basic_enemy( checkpointList.get(0).location, standardRadius, waveDataFloat[1][waveCounter%amountOfWaves], (waveDataFloat[2][waveCounter%amountOfWaves] + (healthScaler * waveCounter)) * gw.mapDifModifier / (waveDataInt[0][waveCounter%amountOfWaves] + (waveDataInt[1][waveCounter%amountOfWaves] + (waveDataInt[2][(waveCounter)%amountOfWaves]))), waveDataString[1][waveCounter%amountOfWaves], waveBounty / (waveDataInt[0][waveCounter%amountOfWaves] + (waveDataInt[1][waveCounter%amountOfWaves] + (waveDataInt[2][waveCounter%amountOfWaves]))), lifeCost);
            spawned2++;
          }
          if (waveDataInt[1][waveCounter%amountOfWaves] <= spawned2) {
            spawning2 = false;
          }
        }
      }
      if (waveDataBoolean[2][waveCounter%amountOfWaves]) {
        spawningBoss = true;
        if (spawningBoss) {
          if (nextSpawnBoss < millis()) {
            nextSpawnBoss += waveDataFloat[0][waveCounter%amountOfWaves] * 2;
            new basic_enemy( checkpointList.get(0).location, standardRadius * 3, waveDataFloat[1][waveCounter%amountOfWaves] * 0.75, (waveDataFloat[2][waveCounter%amountOfWaves] + (healthScaler * waveCounter)) * gw.mapDifModifier / (waveDataInt[0][waveCounter%amountOfWaves] + (waveDataInt[1][waveCounter%amountOfWaves] + (waveDataInt[2][(waveCounter)%amountOfWaves]))) * 2.5, waveDataString[2][waveCounter%amountOfWaves], waveBounty / (waveDataInt[0][waveCounter%amountOfWaves] + (waveDataInt[1][waveCounter%amountOfWaves] + (waveDataInt[2][waveCounter%amountOfWaves]))) * 2, lifeCost * 2);
            bossSpawned++;
          }
          if (waveDataInt[2][waveCounter%amountOfWaves] <= bossSpawned) {
            spawningBoss = false;
          }
        }
      }
      if (!spawning1 && !spawning2 && !spawningBoss) {
        spawning = false;
        spawned = 0;
        spawned2 = 0;
        bossSpawned = 0;
      }
    }

    currentWaveHealth =0;
    for (int i = 0; i < enemyList.size(); i++) {
      basic_enemy enemyHealth = enemyList.get(i);
      if (enemyHealth.health >= 0) {
        currentWaveHealth += enemyHealth.health;
      }
    }
  }



  public void drawing() {
    //ui.drawHealthbar(healthBar, healthBar2, currentWaveHealth, waveTotalHealth);
  }

  //Wave Information Here--------------------------------------------------------------------------------
  /*  void waveStart() { 
   switch (waveCounter % 10) {
   case 1:      
   waveLifeCost = waveCounter;
   delay = delayRound1;
   numberOfEnemies = numberRound1;
   speed = 150;
   waveTotalHealth = baseHealth1 + healthScaler * waveCounter;        
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "air";
   secondEnemy = false;
   bossWave = false;   
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   }
   bounty = waveBounty / numberOfEnemies;
   break;
   case 2:
   waveLifeCost = waveCounter;
   delay = delayRound1;
   numberOfEnemies = numberRound1;
   speed = 100;
   waveTotalHealth = baseHealth1 + healthScaler * waveCounter;
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "water";
   secondEnemy = false;
   bossWave = false;
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   bounty = waveBounty / numberOfEnemies;
   }
   break;
   case 3:
   waveLifeCost = waveCounter;
   delay = delayRound1;    
   numberOfEnemies = numberRound1;
   speed = 100;
   waveTotalHealth = baseHealth1 + healthScaler * waveCounter;
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "air";
   secondEnemy = true;
   type2 = "water";
   bossWave = false;
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   }
   bounty = waveBounty / numberOfEnemies;
   break;
   case 4:
   waveLifeCost = waveCounter;
   delay = delayRound2;
   numberOfEnemies = numberRound2;
   speed = 175;
   waveTotalHealth = baseHealth2 + healthScaler * waveCounter;
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "fire";
   secondEnemy = false;
   bossWave = false;
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   }
   bounty = waveBounty / numberOfEnemies;
   break;
   case 5:
   waveLifeCost = waveCounter;
   delay = delayRound2;
   numberOfEnemies = numberRound2;
   speed = 120;
   waveTotalHealth = baseHealth2 + healthScaler * waveCounter;
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "nature";
   secondEnemy = false;
   bossWave = false;
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   }
   bounty = waveBounty / numberOfEnemies;
   break;
   case 6:
   waveLifeCost = waveCounter;
   delay = delayRound2;
   numberOfEnemies = numberRound2;
   speed = 150;
   waveTotalHealth = baseHealth2 + healthScaler * waveCounter;
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "fire";
   secondEnemy = true;
   type2 = "nature";
   bossWave = false;
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   }
   bounty = waveBounty / numberOfEnemies;
   break;
   case 7:
   waveLifeCost = waveCounter;
   delay = delayRound3;
   numberOfEnemies = numberRound3;
   speed = 125;
   waveTotalHealth = baseHealth3 + healthScaler * waveCounter;
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "light";
   secondEnemy = false;
   bossWave = false;
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   }
   bounty = waveBounty / numberOfEnemies;
   break;
   case 8:
   waveLifeCost = waveCounter;
   delay = delayRound3;
   numberOfEnemies = numberRound3;
   speed = 200;
   waveTotalHealth = baseHealth3 + healthScaler * waveCounter;
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "dark";
   secondEnemy = false;
   bossWave = false;
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   }
   bounty = waveBounty / numberOfEnemies;
   break;
   case 9:
   waveLifeCost = waveCounter;
   delay = delayRound3;
   numberOfEnemies = numberRound3;
   speed = 200;
   waveTotalHealth = baseHealth3 + healthScaler * waveCounter;
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "light";
   secondEnemy = true;
   type2 = "dark";
   bossWave = false;
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   }
   bounty = waveBounty / numberOfEnemies;
   break;
   case 0:
   waveLifeCost = waveCounter;
   delay = delayRound3;
   numberOfEnemies = numberRound3;
   speed = 125;
   waveTotalHealth = baseHealth3 + healthScaler * waveCounter;
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "light";
   secondEnemy = false;
   bossWave = true;
   bossType = "dark";
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   }
   bounty = waveBounty / numberOfEnemies;
   waveBounty += 100;
   break;
   default:
   println("SOS");
   delay = 1000;
   numberOfEnemies = 8;
   speed = 200;
   waveTotalHealth = 1000 + (1000 * (waveCounter / 10));
   enemyHealth = waveTotalHealth / numberOfEnemies;
   type = "light";
   secondEnemy = true;
   type2 = "air";
   bossWave = true;
   bossType = "dark";
   bounty += 100;
   lifeCost = (int)floor(waveLifeCost / numberOfEnemies);
   if (lifeCost <= 0) {
   lifeCost = 1;
   }
   bounty = waveBounty / numberOfEnemies;
   break;
   }
   } */
}