class score_manager {

  float currentScore = 0;
  PrintWriter writer;
  int highScoreListSize = 10;
  name_input_field nif;
  //empty constructor
  score_manager() {
  }

  public void increaseScore(float increaseAmount) {
    // If enemy gets killed add the bounty * mad modifier
    currentScore += increaseAmount * gw.mapDifModifier;
  }

  public void resetScore() {
    currentScore = 0;
  }
  /* If the player died. Check if his score is high enough for the highscorelist
   * if so, add the name and score to a new file 
   * If the file already exists delete the old 1.
   */
  public void playerDied(String mapName) {
    if (checkIfScoreIsHighScore(currentScore, mapName)) {
      String playerName = gw.playerName;
      playerName = playerName.trim();//trim away needless spaces
      if(playerName.length() == 0){
        playerName = "Anonymous";
      }
      ArrayList<AbstractMap.SimpleEntry<String, Float>> l = getScores(mapName);
      l.add(new AbstractMap.SimpleEntry<String, Float>(playerName, currentScore));
      println(writeNewHighscoreFile(sortScores(l), mapName) + " if the save was a succes or not");
    }
    this.resetScore();
  }
  /* Check if the files contains ten entries, if it does't return true.
   * Else get the lowest score in the highscorelist 
   * Then check if the playerscore is bigger than the lowest score in the highscorelist.
   */
  public boolean checkIfScoreIsHighScore(float playerScore, String mapName) {
    ArrayList<AbstractMap.SimpleEntry<String, Float>> scores = getScores(mapName);
    if (scores.size() < highScoreListSize) {
      println("returning true becuase the list is small enough to always let in a new score");
      return true;
    }
    float scoreToBeat = scores.get(scores.size() - 1).getValue();
    println(scoreToBeat + " score to beat");
    return scoreToBeat < playerScore;
  }
  /* Check if a the file exist. 
   * If it does not return empty list.
   * Else read out that file for the playername and score valuepairs, store those in the returnlist
   * Once done reading the file return the list.
   */
  public ArrayList<AbstractMap.SimpleEntry<String, Float>> getScores(String mapName) { //returns all scores in the current file. Note this might return an empty arraylist if no scores are found.
    ArrayList<AbstractMap.SimpleEntry<String, Float>> r = new ArrayList<AbstractMap.SimpleEntry<String, Float>>();
    String filename = mapName + "_highscores.txt";

    File f = new File(dataPath(filename));
    if (!f.exists()) {
      return r;
    }

    BufferedReader reader = createReader(filename);
    String line;
    String[] data;
    while (true) {
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

      data = split(line, " ");
      //println(data);
      String scoreName = data[0];
      float score = Float.parseFloat(data[1]);

      r.add(new AbstractMap.SimpleEntry<String, Float>(scoreName, score));
    }
    try {
      reader.close();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
    return r;
  }

  /* Check if the file exist.
   * If the file exist return false
   * Else make a new file of highscores.
   * If succeed return true.
   */
  public boolean writeNewHighscoreFile( ArrayList<AbstractMap.SimpleEntry<String, Float>> scores, String mapName) {
    if (scores.size() > highScoreListSize) { //The limit is set due to processingtime.
      scores = new  ArrayList<AbstractMap.SimpleEntry<String, Float>>(scores.subList(0, highScoreListSize));
    }
    String filename = dataPath(mapName + "_highscores.txt");

    File f = new File(filename);
    if(f.exists()) {
      try {
        f.delete();
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
    if (f.exists()) {
      return false;
    } else { 
      writer = createWriter(filename);  

      for (AbstractMap.SimpleEntry<String, Float> pair : scores) {
        writer.println(pair.getKey() + " " + pair.getValue());
      }
      writer.flush();
      writer.close();
    }

    return f.exists();
  }
  /* Gets all pairs and places their score into the score list
   * Then sorts the score form high to low
   * Then it gets the score out of the scorelist and checks if the score is equel to the score in the highscore list.
   * If it is it makes a list with the new pair and removes it form the old list.
   * Once done returns the new list.
   */
  public ArrayList<AbstractMap.SimpleEntry<String, Float>> sortScores (ArrayList<AbstractMap.SimpleEntry<String, Float>> scores) {
    ArrayList<AbstractMap.SimpleEntry<String, Float>> r = new ArrayList<AbstractMap.SimpleEntry<String, Float>>();
    ArrayList<Float> scoreList = new ArrayList<Float>();
    for (AbstractMap.SimpleEntry<String, Float> pair : scores) {
      scoreList.add(pair.getValue());
    }
    Collections.sort(scoreList);
    Collections.reverse(scoreList);

    for (float s : scoreList) {
      int pairs = scores.size();
      for (int i = 0; i < pairs; i++) {
        AbstractMap.SimpleEntry<String, Float> pair = scores.get(i);
        if (s == pair.getValue()) {
          r.add(new AbstractMap.SimpleEntry<String, Float>(pair.getKey(), s));
          ;
          scores.remove(pair);
          pairs = scores.size();
          break;
        }
      }
    }

    return r;
  }
}
//https://docs.oracle.com/javase/7/docs/api/java/io/FileWriter.html