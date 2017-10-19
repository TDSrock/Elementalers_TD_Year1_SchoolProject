/* manages all combinations from a, knowing what creats what standpoint.
 * this does NOT track the combination towers stats and such, that is done in Towers.*/

class combine_manager{
  /* stores all the combinations from a class level. each index in the upper list is a combination, 
   * each index in the lower list holds what the combinations is and how to create it.
   * therefor index 0,0 is the end result of the first combination and 0,1 is the first requirment for the first combination*/
   ArrayList<ArrayList<Class>> combinationList = new ArrayList<ArrayList<Class>>();
   ArrayList<Class> nextCombination = new ArrayList<Class>();
   ArrayList<Class> uniqeueClasses = new ArrayList<Class>();
   BufferedReader reader;//used to read the file(s)
   String line;//used to store the line from the file
   String combinationResult;
   String[] combinationRequirements;
   int combinations;
   final String ENGINE_PREFIX = head.toString().split("@")[0] + "$";
   final String TOWER_POSTFIX = "_tower";
   
  combine_manager(String FileName){
    //ArrayList<Class> nextCombination = new ArrayList<Class>();
    nextCombination = new ArrayList<Class>();
    reader = createReader(FileName);
    while(true){
      String[] split;
      try {
        line = reader.readLine();
      } catch (IOException e){
        e.printStackTrace();
        line = null;
      }
      if(line == null){
        //end of file
        break;
      }
      split = line.split("=");
      
      combinationResult = split[0];
      System.arraycopy(split, 1, split, 0,  split.length - 1);
      combinationRequirements = split[0].split("\\+");//the correct way to split on +... took me some time to google this...
      String className = ENGINE_PREFIX + combinationResult + TOWER_POSTFIX;//setup the class string
      
      try{
        Class c = Class.forName(className);
        //println(c + " found, added to list");
        boolean add = true;
        for(Basic_Tower tower : towerDataSlaves){
          if(c.isInstance(tower)){
            add = false;
            break;//we found a reason not to add this, so we can stop.
          }
        }//THIS FOR LOOP IS NOT NEEDED CURRENTLY, ONLY NEEDED IF SEVERAL COMBINATIONS ARE VALID FOR 1 TOWER
        if(add){
          try{
            Constructor con = c.getConstructor(Basic_TowerDefense_Engine.class, PVector.class, boolean.class);
            Object slave = con.newInstance(head, new PVector(100,100), true);//the placement of these guys doesn't matter. Placing them somewhere where they might interefere to see if the below removes work.
            objectList.remove(slave);//remove the dataslave from these two list which he gets added to by default. we DO NOT want this too happen
          }catch(InstantiationException s){
            println(s);
          }catch(IllegalAccessException r){
            println(r);
          }catch(NoSuchMethodException p){
            println(p);
          }catch(ReflectiveOperationException i){
            println(i);
          }
        }
        
        nextCombination.add(c);
      } catch(ClassNotFoundException e){
        println(e + " class not found");
      }
      
      int materials = combinationRequirements.length;
      for(int i = 0; i < materials; i++){
        className = ENGINE_PREFIX + combinationRequirements[i] + TOWER_POSTFIX;
        try{
          Class c = Class.forName(className);
          //println(c + " found, added to list");
          nextCombination.add(c);
        } catch(ClassNotFoundException e){
          println(e + " class not found");
        }
      }
      //done making this combination store it in the upper arrayList.
      //println();
      //println(nextCombination);
      combinationList.add(new ArrayList<Class>(nextCombination));//make a new data pointer and give it the combinations data
      nextCombination.clear();
      //println(combinationList);
    }
    //println(combinationList);
    println("Full report of combinations: ");
    int n = 0;
    for (ArrayList<Class> s : combinationList) { 
      println(s + " Combination " + ++n);
    }
    println("End of report");
    combinations = combinationList.size();
  }

}