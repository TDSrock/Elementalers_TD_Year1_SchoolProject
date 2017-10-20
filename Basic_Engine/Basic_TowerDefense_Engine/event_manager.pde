class event_manager {
  String mapName;
  ArrayList<event> forcedEventList = new ArrayList<event>();//stores the forced events, these can actualy stop the player from taking actions(FOR NOW ONLY USE ON TUTORIAL)
  ArrayList<event> eventList = new ArrayList<event>();//gets re-created at the start of each map, some maps may have different stuff in them, these are achievement like-ish.
  
  ArrayList<event> eventsWithActionKey = new ArrayList<event>();
  ArrayList<event> eventsWithScore = new ArrayList<event>();//all the uncompleted events with a score conditions(s) that is not yet completed
  ArrayList<event> eventsWithPossitionx = new ArrayList<event>();//all the uncompleted events with a possionx condition(s) that is not yet completed
  ArrayList<event> eventsWithPossitiony = new ArrayList<event>();//all the uncompleted events with a possiony condition(s) that is not yet completed
  ArrayList<event> eventsWithTowerPlaced = new ArrayList<event>();//all the uncompleted events with a towerPlaced condition(s) that is not yet completed
  ArrayList<event> eventsWithTowerSold = new ArrayList<event>();//all the uncompleted events with a towerSold condition(s) that is not yet completed
  ArrayList<event> eventsWithKills = new ArrayList<event>();//all the uncompleted events with a kills condition(s) that is not yet completed
  ArrayList<event> eventsWithTotalDamage = new ArrayList<event>();//all the uncompleted events with a totalDamage condition(s) that is not yet completed
  ArrayList<event> eventsWithGlobalDamage = new ArrayList<event>();//all the uncompleted events with a globalDamage condition(s) that is not yet completed
  ArrayList<event> eventsWithCompleteWave = new ArrayList<event>();//all the uncompleted events with a completeWave condition(s) that is not yet completed
  ArrayList<event> eventsWithTowerCount = new ArrayList<event>();
  
  ArrayList<event> eventsWithBeforeWave = new ArrayList<event>();//all the uncompleted events with a beforeWave condition(s) that is not yet completed
  ArrayList<event> eventsWithFailTowerCount = new ArrayList<event>();//all the uncompleted events with a failtTowerCount condition(s) that is not yet completed
  
  ArrayList<event> storedEvents = new ArrayList<event>();//stores all the non-activates events(mainly used during setup)
  
  event_manager(String MapName){
    mapName = MapName;
  }

  public void init() { 
    loadEvents(mapName + "_events.txt");
    loadEvents("eventsForAllMaps.txt");
    if(forcedEventList.size() != 0 ){
      em.generateError(forcedEventList.get(0).eventText,00);
    }

    println(forcedEventList);
    println(eventList);
    println(eventsWithCompleteWave);
    println(storedEvents);
  }

  private void loadEvents(String FileName) {
    String filename = FileName;

    File f = new File(dataPath(filename));
    if (!f.exists()) {
      println("Event manager could not find the file named: " + FileName + " This might be a mistake OR the map simply does not hold events of the type");
      return;
    }
    BufferedReader reader = createReader(FileName);
    String line;
    while (true) {
      String[] split;
      try {
        line = reader.readLine();
      } 
      catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      if (line == null) {
        //end of file
        break;
      }
      println(line);
      split = line.split("\\s*\\\\" + "\\|/\\s*");// the correcct way to split for \|/
      print("[");
      for (String s : split) {
        print(s + ", ");
      }
      println("]");
      int splitCount = split.length;
      boolean started = split[splitCount - 1].toLowerCase().equals("true");
      println(splitCount);
      if (splitCount == 10) {
        new event(split[0], split[1], split[2], split[3], split[4], Float.valueOf(split[5]), Integer.valueOf(split[6]), Float.valueOf(split[7]), split[8], started);
      } else if (splitCount == 11) {
        new event(split[0], split[1], split[2], split[3], split[4], split[5], Float.valueOf(split[6]), Integer.valueOf(split[7]), Float.valueOf(split[8]), split[9], started);
      } else {
        println("found a line with the incorrect amount of \\|/'s in them to be an event, it had: " + splitCount + " times \\|/ in it/n, the orginal line was: " + line);
      }
      println();
    }
  }
  
  public boolean forcedEventCheck(PVector location, Class tower){
    if(forcedEventList.size() != 0){//check if there even is anything in the list first
      event currentForcedEvent = forcedEventList.get(0);//get the first index
      if(currentForcedEvent.possitionx != null){
        if(location.x != (float)currentForcedEvent.possitionx.get(0) && location.x != (float)currentForcedEvent.possitionx.get(0) + 1){
          return false;//the player fucked up on the x coord
        }
      }
      if(currentForcedEvent.possitiony != null){
        if(location.y != (float)currentForcedEvent.possitiony.get(0) && location.y != (float)currentForcedEvent.possitiony.get(0) + 1){
          return false;//the player fucked up on the y coord
        }
      }
      if(currentForcedEvent.towerPlaced != null){
        if(tower != currentForcedEvent.towerPlaced.get(0)){
          return false;//the player placed the wrong tower
        }
      }
      if(currentForcedEvent.towerSold != null){
        println(tower);
        println(currentForcedEvent.towerSold.get(0));
        if(tower != currentForcedEvent.towerSold.get(0)){
          return false;
        }
      }
      //seeing as we got here, lets reward the player for doing the thing we told him to do!
      completeEvent(currentForcedEvent);
    }
    return true;//return true if we don't need to bother with the forced check
  }

  public void completeEvent(event e){
    println("EVENT WAS COMPLETE " + e);
    em.generateError(e.eventCompletionText, 7000);
    playerCurrency += e.currencyReward;
    playerLives += e.livesReward;
    sm.increaseScore(e.scoreReward);
    if( e.eventReward != null){
      for(event re : e.eventReward){
        int i = 0;
        try{
          re.startEvent(re.isForcedEvent);
          if(i == 0 || !e.isForcedEvent){
            em.generateError("A new event has started: " + re.eventName +"\n" + re.eventText, 7000);
          }
          i++;
        } catch ( NullPointerException error ){
          println(error + " this error occured because you had an a non-exsistant event as an event reward"); 
        }
      }
    }
    if(e.isForcedEvent){
      forcedEventList.remove(e);
      if(forcedEventList.size() != 0){
        em.generateError(forcedEventList.get(0).eventText, 8000);
      }
    }else{
      eventList.remove(e);
    }
  }
  
  private void reportAllEvents(){
    for(event e : eventList){
      println(e);
      println(e.conditionsCount);
      for(ArrayList<Object> l : e.conditions){
        println(l);
      }
      println("fail conditions");
      for(ArrayList<Object> l : e.failConditions){
        println(l);
      }
      println();
    }
  }
  
  public void placementCheck(Class t){
    reportAllEvents();
    
    for (int i = 0; i < eventsWithPossitionx.size(); i++) {
      event currentEvent = eventsWithPossitionx.get(i);
      for(int j = 0; j < currentEvent.possitionx.size(); j++){
        float possitionxToBe = (float)currentEvent.possitionx.get(j);;
        if (gw.mp.arrayLocation.x == possitionxToBe) {
          println("You Placed a tower on xcoord: " +  possitionxToBe + "!");
          currentEvent.conditionsCount--;
          currentEvent.possitionx.remove(j);
          if(currentEvent.possitionx.size() == 0){
            eventsWithPossitionx.remove(currentEvent);
          }
          j--;
          println(currentEvent.conditionsCount  +  " current event's condition count after removing one due to the completed event here");
          if(currentEvent.conditionsCount <= 0 ){
            completeEvent(currentEvent);
          }
        }
      }
    }
    
    for (int i = 0; i < eventsWithTowerCount.size(); i++) {
      event currentEvent = eventsWithTowerCount.get(i);
      for(int j = 0; j < currentEvent.towerCount.size(); j++){
        int towersPlacedNeeded = (int)currentEvent.towerCount.get(j);
        if (gw.towersPlacedByPlayer <= towersPlacedNeeded) {
          currentEvent.conditionsCount--;
          currentEvent.towerCount.remove(j);
          if(currentEvent.towerCount.size() == 0){
            eventsWithTowerCount.remove(currentEvent);
          }
          j--;
          println(currentEvent.conditionsCount  +  " current event's condition count after removing one due to the completed event here");
          if(currentEvent.conditionsCount <= 0 ){
            completeEvent(currentEvent);
          }
        }
      }
    }

    for (int i = 0; i < eventsWithTowerPlaced.size(); i++) {
      event currentEvent = eventsWithTowerPlaced.get(i);
      for(int j = 0; j < currentEvent.towerPlaced.size(); j++){
        if (t == currentEvent.towerPlaced.get(j)) {
          currentEvent.conditionsCount--;
          currentEvent.towerPlaced.remove(j);
          if(currentEvent.towerPlaced.size() == 0){
            eventsWithTowerPlaced.remove(currentEvent);
          }
          j--;
          println(currentEvent.conditionsCount  +  " current event's condition count after removing one due to the completed event here");
          if(currentEvent.conditionsCount <= 0 ){
            completeEvent(currentEvent);
          }
        }
      }
    }
    
    reportAllEvents();
  }
  
  public void endOfWaveCheck() {
    reportAllEvents();
    println("hi");
    for (int i = 0; i < eventsWithScore.size(); i++) {
      println("event with complete wave " + i);
      event currentEvent = eventsWithScore.get(i);
      for(int j = 0; j < currentEvent.score.size(); j++){
        float scoreToBeat = (float)currentEvent.score.get(j);
        println("the score to beat is : " + scoreToBeat);
        if (sm.currentScore >= scoreToBeat) {
          println("You earned more score then " +  scoreToBeat + "!");
          currentEvent.conditionsCount--;
          currentEvent.score.remove(j);
          if(currentEvent.score.size() == 0){
            eventsWithScore.remove(currentEvent);
          }
          j--;
          println(currentEvent.conditionsCount  +  " current event's condition count after removing one due to the completed event here");
          if(currentEvent.conditionsCount <= 0 ){
            completeEvent(currentEvent);
          }
        }
      }
    }
    
    for (int i = 0; i < eventsWithKills.size(); i++) {
      event currentEvent = eventsWithKills.get(i);
      for (int j = 0; j < currentEvent.kills.size(); j++){
        int killsToComplete = (int)currentEvent.kills.get(j);
        for (int t = 0; t < towerList.size(); t++) {
          Basic_Tower currentTower = towerList.get(t);
          if (currentTower.kills >= killsToComplete) {
            println("you got enough kills on a single tower!");
            currentEvent.conditionsCount--;
            currentEvent.kills.remove(j);
            if(currentEvent.kills.size() == 0){
              eventsWithKills.remove(currentEvent);
            }
            j--;
            println(currentEvent.conditionsCount  +  " current event's condition count after removing one due to the completed event here");
            if(currentEvent.conditionsCount <= 0 ){
              completeEvent(currentEvent);
            }
            break;//break the tower loop
          }
        }
      }
    }

    for (int i = 0; i < eventsWithCompleteWave.size(); i++) {
      println("event with complete wave " + i);
      event currentEvent = eventsWithCompleteWave.get(i);
      for(int j = 0; j < currentEvent.completeWave.size(); j++){
        int waveToBeat = (int)currentEvent.completeWave.get(j);
        println("the wave to beat is : " + waveToBeat);
        println("the current wave is : " + gw.wave.waveCounter);
        if (gw.wave.waveCounter == waveToBeat) {
          println("You made it through wave " +  waveToBeat + "!");
          currentEvent.conditionsCount--;
          currentEvent.completeWave.remove(j);
          if(currentEvent.completeWave.size() == 0){
            eventsWithCompleteWave.remove(currentEvent);
          }
          j--;
          println(currentEvent.conditionsCount  +  " current event's condition count after removing one due to the completed event here");
          if(currentEvent.conditionsCount <= 0 ){
            completeEvent(currentEvent);
          }
        }
      }
    }

    for (int i = 0; i < eventsWithTotalDamage.size(); i++) {
      event currentEvent = eventsWithTotalDamage.get(i);
      for(int j = 0; j < currentEvent.totalDamage.size(); j++){
        float dmgToBeat = (float)currentEvent.totalDamage.get(j);
        for (int t = 0; t < towerList.size(); i++) {
          Basic_Tower currentTower = towerList.get(i);
          if (currentTower.damageDealtTotal >= dmgToBeat) {
            println("We're all very proud of you, your tower did damage, yay..");
            currentEvent.conditionsCount--;
            currentEvent.totalDamage.remove(j);
            if(currentEvent.totalDamage.size() == 0){
              eventsWithTotalDamage.remove(currentEvent);
            }
            j--;
            println(currentEvent.conditionsCount  +  " current event's condition count after removing one due to the completed event here");
            if(currentEvent.conditionsCount <= 0 ){
              completeEvent(currentEvent);
            }
            break;//break the tower loop
          }
        }
      }
    }

    for (int i = 0; i < eventsWithGlobalDamage.size(); i++) {
      event currentEvent = eventsWithGlobalDamage.get(i);
      for(int j = 0; j < currentEvent.globalDamage.size(); j++){
        float dmgToBeat = (float)currentEvent.globalDamage.get(j);
        if (gw.globalDamage <= dmgToBeat) {
          println("You have no idea how tiring it is to praise some human for doing a set amount of damage, in a game specifically made for the player to do damage...");  
          currentEvent.conditionsCount--;
          currentEvent.globalDamage.remove(j);
          if(currentEvent.globalDamage.size() == 0){
            eventsWithGlobalDamage.remove(currentEvent);
          }
          j--;
          println(currentEvent.conditionsCount  +  " current event's condition count after removing one due to the completed event here");
          if(currentEvent.conditionsCount <= 0 ){
            completeEvent(currentEvent);
          }
        }
      }
    }
    reportAllEvents();
  }
}

//class to contain the event values.(and do some light checking of stuff)
/*when making an event you have two options in the files:
Forced event:
<EventName>\|/<EventText>\|/<EventCompletionText>\|/<EventConditions>\|/<EventErrorText>\|/<ScoreReward>\|/<LivesReward>\|/<CurrencyReward>\|/<EventReward>\|/<Started>
optional event:
<EventName>\|/<EventText>\|/<EventCompletionText>\|/<EventConditions>\|/<FailureConditions>\|/<EventErrorText>\|/<ScoreReward>\|/<LivesReward>\|/<CurrencyReward>\|/<EventReward>\|/<Started>
Note that the "<" and ">" are to denote the start and end of the programmers text*/
class event {
  String eventName;//place to store the event's name, these MUST be unuqie per map
  String eventErrorText;//place the error text here
  String eventText;//place the text the event shows the first time it comes up
  String eventCompletionText;//place text here for when the player completes an event
  String eventConditions;//place to put the conditions in the format:"<ACTION>--><VALUE>/|\<ACTION>--><VALUE>...
  /*Valid conditions are: 
  score--><score>                     (global score)        Checked at end of wave
  kills--><#ofkills>                  (by one tower)        Checked at end of wave
  totalDamage--><totalDamage>         (by one tower)        Checked at end of wave
  globalDamage--><globalDamage>       (by all towers ever)  Checked at end of wave
  completeWave--><wave>                                     Checked at end of wave
  actionKey--><#ofTimesActionKeyPressed>                    Checked at end of wave**
  possitionx--><possitionx>                                 Checked on placement*
  possitiony--><possitiony>                                 Checked on placement*
  towerPlaced--><tower>                                     Checked on placement*
  towerCount--><#ofTowers>            (placed by player)    Checked on placement
  towerSold--><tower>                                       Checked on sell*
  if starred means it's valid for a forced event, any other options will be recognized by the forced event but not checked. NOTE: DO NOT MIX towerSold and towerPlaced in an forced event it will softlock the game untill the file is updated
  **this one CAN be used for forced events, if it does you need to know how many time the player has already pushed. So, be carefull with this one.
  */
  String failureConditions = "";//place to put the failure conditions, this is ONLY for NON forced events!! place to put the conditions in the format:"<ACTION>--><VALUE>/|\<ACTION>--><VALUE>...
  /*valid failure conditions are:
   failTowerCount--><#ofTowersPlaced>  (placed by player)    Checked on placement
   beforeWave--><wave>                                       Checked at the start of wave
   */
  int livesReward = 0;//place lives here to reward too the player if he completes the event
  float currencyReward = 0;//place the currency reward here for the player if he completes the event
  float scoreReward = 0;
  event[] eventReward;//events that kick-off other event(s) their format is: <eventName>|||<eventName>...

  boolean isForcedEvent = false;//wheiter or not the player HAS to complete this event right now(forced events can only be completed in order, non forced events can be completed in any order)
  boolean started = true;

  //stuff to store this events conditions
  ArrayList<Object> actionKey;
  ArrayList<Object> score;// = new ArrayList<event>();
  ArrayList<Object> possitionx;// = new ArrayList<event>();
  ArrayList<Object> possitiony;// = new ArrayList<event>();
  ArrayList<Object> towerPlaced;// = new ArrayList<event>();
  ArrayList<Object> towerSold;// = new ArrayList<event>();
  ArrayList<Object> towerCount;// = new ArrayList<event>();
  ArrayList<Object> kills;// = new ArrayList<event>();
  ArrayList<Object> totalDamage;// = new ArrayList<event>();
  ArrayList<Object> globalDamage;// = new ArrayList<event>();
  ArrayList<Object> completeWave;// = new ArrayList<event>();
  ArrayList<ArrayList<Object>> conditions = new ArrayList<ArrayList<Object>>();

  int conditionsCount;

  //stuff to store this events failure conditions
  ArrayList<Object> beforeWave;// = new ArrayList<event>();
  ArrayList<Object> failTowerCount;// = new ArrayList<event>();
  ArrayList<ArrayList<Object>> failConditions = new ArrayList<ArrayList<Object>>();

  public event(String EventName, String EventText, String EventCompletionText, String EventConditions, String EventErrorText, float ScoreReward, int LivesReward, float CurrencyReward, String EventReward, boolean Started) {
    isForcedEvent = true;
    init(EventName, EventText, EventCompletionText, EventConditions, EventErrorText, ScoreReward, LivesReward, CurrencyReward, EventReward, Started);
  }

  public event(String EventName, String EventText, String EventCompletionText, String EventConditions, String FailureConditions, String EventErrorText, float ScoreReward, int LivesReward, float CurrencyReward, String EventReward, boolean Started) {
    failureConditions = FailureConditions;
    init(EventName, EventText, EventCompletionText, EventConditions, EventErrorText, ScoreReward, LivesReward, CurrencyReward, EventReward, Started); 
  }

  private void init(String EventName, String EventText, String EventCompletionText, String EventConditions, String EventErrorText, float ScoreReward, int LivesReward, float CurrencyReward, String EventReward, boolean Started) {//core init, adds all the list to conditions list and fConditionslist aswell as managing all the things both constructors have
    eventName = EventName;
    eventText = EventText;
    eventCompletionText = EventCompletionText;
    eventConditions = EventConditions;
    eventErrorText = EventErrorText;
    scoreReward = ScoreReward;
    livesReward = LivesReward;
    currencyReward = CurrencyReward;
    eventReward = createEventRewards(EventReward);
    started = Started;

    workOutConditions(eventConditions, failureConditions);
    
    if (actionKey != null) conditions.add(actionKey);
    if (score != null) conditions.add(score);
    if (possitionx != null) conditions.add(possitionx);
    if (possitiony != null) conditions.add(possitiony);
    if (towerPlaced != null) conditions.add(towerPlaced);
    if (towerSold != null) conditions.add(towerSold);
    if (kills != null) conditions.add(kills);
    if (totalDamage != null) conditions.add(totalDamage);
    if (globalDamage != null) conditions.add(globalDamage);
    if (completeWave != null) conditions.add(completeWave);
    if (towerCount != null) conditions.add(towerCount);
    if (beforeWave != null) failConditions.add(beforeWave);
    if (failTowerCount != null) failConditions.add(failTowerCount);

    //done setting up the event, time to start this event. If it is an event that should instant start.
    if (started) {
      startEvent(isForcedEvent);
    } else {//if it is not an event that should start, we should store it.
      gw.em.storedEvents.add(this);
    }
  }

  private void workOutConditions(String eventConditions, String eventFailConditions) {
    if (eventConditions.length() != 0) {
      String[] splitConditions = eventConditions.split("/\\|\\\\");
      this.conditionsCount = splitConditions.length;
      for (int i = 0; i < conditionsCount; i++) {
        String[] curCondition = splitConditions[i].split("-->");
        switch(curCondition[0]){
          case "score":
            if(score == null) score = new ArrayList<Object>();
            score.add(Float.valueOf(curCondition[1]));
            break;
          case "possitionx":
            if(possitionx == null) possitionx = new ArrayList<Object>();
            possitionx.add(Float.valueOf(curCondition[1]));
            break;
          case "possitiony":
            if(possitiony == null) possitiony = new ArrayList<Object>();
            possitiony.add(Float.valueOf(curCondition[1]));
            break;
          case "towerPlaced":
            if(towerPlaced == null) towerPlaced = new ArrayList<Object>();
            towerPlaced.add(getClassObj(curCondition[1]));
            break;
          case "towerCount":
            if(towerCount == null) towerCount = new ArrayList<Object>();
            towerCount.add(Integer.valueOf(curCondition[1]));
            break;
          case "towerSold":
            if(towerSold == null) towerSold = new ArrayList<Object>();
            towerSold.add(getClassObj(curCondition[1]));
            break;
          case "kills":
            if(kills == null) kills = new ArrayList<Object>();
            kills.add(Integer.valueOf(curCondition[1]));
            break;
          case "totalDamage":
            if(totalDamage == null) totalDamage = new ArrayList<Object>();
            totalDamage.add(Float.valueOf(curCondition[1]));
            break;
          case "globalDamage":
            if(globalDamage == null) globalDamage = new ArrayList<Object>();
            globalDamage.add(Float.valueOf(curCondition[1]));
            break;
          case "completeWave":
            if(completeWave == null) completeWave = new ArrayList<Object>();
            completeWave.add(Integer.valueOf(curCondition[1]));
            break;
          case "actionKey":
            if (actionKey == null) actionKey = new ArrayList<Object>();
            actionKey.add(Integer.valueOf(curCondition[1]));
          break;
          default:
            println("error on reading conditions: " + curCondition[0]);
          break;
        }
      }
    }
    if (eventFailConditions.length() != 0) {
      String[] splitFailConditions = eventFailConditions.split("/\\|\\\\");
      int fconditions = splitFailConditions.length;
      for (int i = 0; i < fconditions; i++) {
        String[] curCondition = splitFailConditions[i].split("-->");
        switch(curCondition[0]) {
        case "beforeWave":
          if (beforeWave == null) beforeWave = new ArrayList<Object>();
          beforeWave.add(Integer.valueOf(curCondition[1]));
          break;
        case "failTowerCount":
          if (failTowerCount == null) failTowerCount = new ArrayList<Object>();
          failTowerCount.add(Float.valueOf(curCondition[1]));
          break;
        default:
          println("error on reading Failconditions: " + curCondition[0]);
          break;
        }
      }
    }
  }

  private Class getClassObj(String className) {
    className = ENGINE_PREFIX + className + TOWER_POSTFIX;//setup the class string
    Class r = null;
    try {
      r = Class.forName(className);
    } 
    catch(ClassNotFoundException e) {
      println(e);
    }
    return r;
  }

  private event[] createEventRewards(String events) {
    if (events.length() != 0) {
      String[] splitEvents = events.split("\\|\\|\\|");
      int eventsRewarded = splitEvents.length;
      event[] r = new event[eventsRewarded];
      for (int i = 0; i < eventsRewarded; i ++) {
        r[i] = findEvent(splitEvents[i].trim());
      }
      return r;
    }
    return null;
  }

  private event findEvent(String EventName) {
    int eventsStored = gw.em.storedEvents.size();
    println();
    println("looking for: " + EventName);
    for (int i = 0; i <  eventsStored; i++) {
      event e = gw.em.storedEvents.get(i);
      println("Found: " + e.eventName);
      if (EventName.equals(e.eventName)) {
        gw.em.storedEvents.remove(e);
        println("found who I was looking for");
        return e;
      }
    }
    println("Error in finding the event! Either it was typed wrong in the file, or it was already removed, eventName was: " + EventName +"\nNote: events that contain events should be made after the events that they should contain");
    return null;
  }

  private void startEvent(boolean IsForced) {
    if (IsForced) {
      gw.em.forcedEventList.add(this);//with forced events will bassicly use a queue to checkup on the status so from here we let him go.
    } else {
      gw.em.eventList.add(this);//all the others get checks thrown over them over time, so we split them up in tons of seperate groups depending on their conditions ect.
      if (score != null) gw.em.eventsWithScore.add(this);
      if (possitionx != null) gw.em.eventsWithPossitionx.add(this);
      if (possitiony != null) gw.em.eventsWithPossitiony.add(this);
      if (towerPlaced != null) gw.em.eventsWithTowerPlaced.add(this);
      if (towerSold != null) gw.em.eventsWithTowerSold.add(this);
      if (kills != null) gw.em.eventsWithKills.add(this);
      if (totalDamage != null) gw.em.eventsWithTotalDamage.add(this);
      if (globalDamage != null) gw.em.eventsWithGlobalDamage.add(this);
      if (completeWave != null) gw.em.eventsWithCompleteWave.add(this);
      if (beforeWave != null) gw.em.eventsWithBeforeWave.add(this);
      if (failTowerCount != null) gw.em.eventsWithFailTowerCount.add(this);
    }
  }
}