/* Graph for dealing with pathfinding
 * Please don't change stuff in here randomly
 */
class graph{
  Boolean intilaized = false;
  ArrayList<node> nodeList;
  ArrayList<node> pathList;
  ArrayList<node> theCheckpointsList = new ArrayList<node>();
  node[][] nodeArray;//for arrayBased math
  int nodes;
  int arrayWidth;
  int arrayHeigth;
  float pathLength = 0;
  
  graph(){
    println("making the graph");
    nodeList = new ArrayList<node>();
    arrayWidth = gw.arrayWidth;
    arrayHeigth = gw.arrayHeigth;
    nodeArray = new node[arrayWidth][arrayHeigth];
    for(int x = 0; x < gw.arrayWidth; x++){
      for(int y = 0; y < gw.arrayHeigth; y++){
        new node(new PVector(x,y), this);
      }
    }//all nodes are created, time to connect them all to the valid nodes
    nodes = nodeList.size();
    for(int i = 0; i < nodes; i++){
      node node = nodeList.get(i);
      node.initEnable(); 
    }
    try{
    updateTotalPath();
    } catch (impossiblePathException e){
      println("Invalid map was loaded. The impossiblePath exception error message is: " + e.getMessage());
    }
    intilaized = true;
  }
  
  public ArrayList<node> fetchTotalPath(){
    return pathList;
  }
  
  public void updateTotalPath() throws impossiblePathException{
    try{
    this.pathList = constructTotalPath();
    } catch (impossiblePathException e){
      println(e.getMessage());
      throw new impossiblePathException(e.getMessage());
    }
  }
  
  private ArrayList<node> constructTotalPath() throws impossiblePathException{
    ArrayList<node> newTotalPath = new ArrayList<node>();
    theCheckpointsList.clear();
    int checkpoints = checkpointList.size();
    pathLength = 0;
    
      for(int i = 0; i < checkpoints - 1; i++){
        try{
          //println(i + " too " + (i+ 1) + " / " + (checkpoints - 1));
          checkpoint c = checkpointList.get(i);
          checkpoint cn = checkpointList.get(i + 1);
          node n = nodeArray[(int)c.arrayLocation.x][(int)c.arrayLocation.y];
          if(i == 0){
            newTotalPath.add(n);
          }
          node nn = nodeArray[(int)cn.arrayLocation.x][(int)cn.arrayLocation.y];
          theCheckpointsList.add(n);
          if(!theCheckpointsList.contains(nn)){
            theCheckpointsList.add(nn);
          }
          newTotalPath.addAll(a_star(n, nn));
        } catch(impossiblePathException e){
          throw new impossiblePathException(e.getMessage() + " at path between checkpoint " + i + " and checkpoint " + (i+1)) ;
        }
    }
   
    return newTotalPath;
  }
  
  private ArrayList<node> a_star(node start, node goal) throws impossiblePathException{
    //println("starting a_star");
    if(start == goal){
      println("a* used with the start and goal node being the same");
    }
    // The set of nodes already evaluated.
    ArrayList<node> closedSet = new ArrayList<node>();
    // The set of currently discovered nodes still to be evaluated.
    // Initially, only the start node is known.
    ArrayList<node> openSet = new ArrayList<node>();
    openSet.add(start);
    // For each node, which node it can most efficiently be reached from.
    // If a node can be reached from many nodes, cameFrom will eventually contain the
    // most efficient previous step.
    node[][] cameFrom = new node[arrayWidth][arrayHeigth];//nodeArray;// := the empty map

    // For each node, the cost of getting from the start node to that node.
    float[][] gScore = new float[arrayWidth][arrayHeigth];
   for(float[] row : gScore){
      java.util.Arrays.fill(row, Float.MAX_VALUE);//:= map with default value of Infinity
    }
    // The cost of going from start to start is zero.
    gScore[(int)start.arrayLocation.x][(int)start.arrayLocation.y] = 0;// := 0 
    // For each node, the total cost of getting from the start node to the goal
    // by passing by that node. That value is partly known, partly heuristic.
    float[][] fScore = new float[arrayWidth][arrayHeigth];
    for(float[] row : fScore){
      java.util.Arrays.fill(row, Float.MAX_VALUE);//:= map with default value of Infinity
    }
    // For the first node, that value is completely heuristic.
    fScore[(int)start.arrayLocation.x][(int)start.arrayLocation.y] = heuristic_cost_estimate(start, goal);// := heuristic_cost_estimate(start, goal)
    float tentative_gScore = 0;
    while (!openSet.isEmpty()){
      node current = get_lowest_fScore(openSet, fScore); //:= the node in openSet having the lowest fScore[] value
      if (current == goal){
        pathLength += tentative_gScore;
        return reconstruct_path(cameFrom, start, goal);
      }

      openSet.remove(current);
      closedSet.add(current);
      for(node neighbor : current.ConnectedNodes){//each neighbor of current{
        if (closedSet.contains(neighbor)){
          continue;    // Ignore the neighbor which is already evaluated.
        }
        // The distance from start to a neighbor
        tentative_gScore = gScore[(int)current.arrayLocation.x][(int)current.arrayLocation.y] + PVector.dist(current.location, neighbor.location);//:= gScore[current] + dist_between(current, neighbor)
        if (!openSet.contains(neighbor)){//neighbor not in openSet{  // Discover a new node
            openSet.add(neighbor);
        }else if (tentative_gScore >= gScore[(int)neighbor.arrayLocation.x][(int)neighbor.arrayLocation.y]){
          continue;    // This is not a better path.
        }
        //println("adding " + current + " cameFrom stuff");

        // This path is the best until now. Record it!
        cameFrom[(int)neighbor.arrayLocation.x][(int)neighbor.arrayLocation.y] = current;//:= current
        gScore[(int)neighbor.arrayLocation.x][(int)neighbor.arrayLocation.y] = tentative_gScore;//:= tentative_gScore
        fScore[(int)neighbor.arrayLocation.x][(int)neighbor.arrayLocation.y] = gScore[(int)neighbor.arrayLocation.x][(int)neighbor.arrayLocation.y] + heuristic_cost_estimate(neighbor, goal);//:= gScore[neighbor] + heuristic_cost_estimate(neighbor, goal)
      }
    }
    throw new impossiblePathException("Impossible path exception");
  }
  
  private float heuristic_cost_estimate(node n1, node n2){
    return PVector.dist(n1.location, n2.location);
  }
  
  private node get_lowest_fScore(ArrayList<node> openSet, float[][] fScore){
    node lowest_fScoreNode = openSet.get(0);
    float lowest_current_fScore = fScore[(int)lowest_fScoreNode.arrayLocation.x][(int)lowest_fScoreNode.arrayLocation.y];
    int nodes = openSet.size();
    for(int i = 1; i < nodes; i++){
      node n = openSet.get(i);
      float n_fScore = fScore[(int)n.arrayLocation.x][(int)n.arrayLocation.y];
      if(lowest_current_fScore > n_fScore){
        lowest_current_fScore = n_fScore;
        lowest_fScoreNode = n;
      }
    }
    return lowest_fScoreNode;
  }
  
  private ArrayList<node> reconstruct_path(node[][] cameFrom, node start, node goal){
    PVector direction = new PVector(-4000, -4000);
    PVector prevDirection = direction;
    ArrayList<node> total_path = new ArrayList<node>();
    node current = goal;
    node previouse = current;
    total_path.add(current);
    //println("added first node of path " + current);
    while(current != start){
      prevDirection = new PVector(direction.x, direction.y);
      direction = PVector.sub(current.location, cameFrom[(int)current.arrayLocation.x][(int)current.arrayLocation.y].location).normalize();
      previouse = current;
      current = cameFrom[(int)current.arrayLocation.x][(int)current.arrayLocation.y];
      if(prevDirection.x != direction.x || prevDirection.y != direction.y){
        //println(++newDirCount);
        total_path.add(previouse);
      }
    }
    java.util.Collections.reverse(total_path);
    return total_path;
  }
  
  public void drawing(){
    int r = 170;
    int g = 0;
    int b = 85;
    int rReduced = 0;
    nodes = pathList.size();
    //println("drawing path of node count: " + nodes);
    for(int i = 0; i < nodes - 1; i++){
      PVector cur = pathList.get(i).location;
      PVector next = pathList.get(i + 1).location;
      if(theCheckpointsList.contains(pathList.get(i))){//found a node that is a checkpoint lets change our color values.
        r += 85;
        g += 85;
        b += 85;
        while(r > 255){
          r -= 255;
          rReduced +=1;
          if(rReduced % 2 == 0){
            r+=170;
            g-=85;
            b+=85;
          }
        }
        while(g > 255)
          g -= 255;
        while(b > 255)
          b -= 255;
      }
      if(r != 255 && b != 255 && g != 255){
        int swapper = rReduced % 3;
        if(swapper == 0){
          r = 255;
        } else if (swapper == 1){
          g = 255;
        } else {
          b = 255;
        }
      }
      strokeWeight(3);
      stroke(r,g,b, 230);
      line(cur.x, cur.y, next.x, next.y);
    }
    
  }
  /*public void resetGraph(){
    nodes = nodeList.size();
    for(int i = 0; i < nodes; i++){
      nodeList.get(i).destroy = true;
    }
    nodeList.clear();
  }*/
}

class node{  
  int nodes;
  ArrayList<node> ConnectedNodes = new ArrayList<node>();;
  ArrayList<Float> pathCostList = new ArrayList<Float>();
  PVector arrayLocation = new PVector(0,0);
  graph insideOf;
  PVector location;
  boolean enabled = false;

  node(PVector ArrayLocation, graph InsideOf){
    insideOf = InsideOf;
    arrayLocation = new PVector(ArrayLocation.x, ArrayLocation.y);
    insideOf.nodeArray[(int)arrayLocation.x][(int)arrayLocation.y] = this;
    location = new PVector(arrayLocation.x * gw.cellWidth + gw.cellWidth / 2 + gw.location.x, arrayLocation.y * gw.cellHeigth + gw.cellHeigth / 2 + gw.location.y);
    //refreshLoSList();
    insideOf.nodeList.add(this);
    //println("node built at x / y " + location.x + " /  " + location.y);
  }
  
  private void initEnable(){
    //println("starting the connection process");
    enabled = true;
    for(int x = -1; x < 2; x++){
      for(int y = -1; y < 2; y++){
        if((x == 0 && y == 0)||
          arrayLocation.x + x < 0 || arrayLocation.x + x > insideOf.arrayWidth - 1 ||
          arrayLocation.y + y < 0 || arrayLocation.y + y > insideOf.arrayHeigth - 1){
            //println("skipping connection");
        }else {
          //println("doing tower check");
          node n = insideOf.nodeArray[(int)arrayLocation.x + x][(int)arrayLocation.y + y];
          //println("connecting a node to another one");
          ConnectedNodes.add(n);
        }
      }
    }
  }
  
  public void enable(){
    //println("starting the connection process");
    enabled = true;
    for(int x = -1; x < 2; x++){
      for(int y = -1; y < 2; y++){
        if((x == 0 && y == 0)||
          arrayLocation.x + x < 0 || arrayLocation.x + x > insideOf.arrayWidth - 1 ||
          arrayLocation.y + y < 0 || arrayLocation.y + y > insideOf.arrayHeigth - 1){
            //println("skipping connection");
        }else {
          //println("doing tower check");
          node n = insideOf.nodeArray[(int)arrayLocation.x + x][(int)arrayLocation.y + y];
          if(n.enabled){
            //println("connecting a node to another one");
            if(!this.ConnectedNodes.contains(n)) this.ConnectedNodes.add(n);
            if(!n.ConnectedNodes.contains(this)) n.ConnectedNodes.add(this);
          } else {
            //println("A tower was in the way of the connection");
          }
        }
      }
    }
    this.update();
  }
  
  public void update(PVector b1, PVector b2){//b = the tower box that caused the update
    int nodes = ConnectedNodes.size();
    for(int i = 0; i < nodes; i++){
      node n = ConnectedNodes.get(i);
      if(collision_helper.LB_collision(this.location, n.location, b1, b2)){//remove nodes connections if the box is in the way
        this.ConnectedNodes.remove(n);
        n.ConnectedNodes.remove(this);
        nodes = ConnectedNodes.size();
      }
    }
  }
  
  public void update(){//update it comparing to all towers, this one is less effecient, so use with caution(and becomes slower with more tower)
   int nodes = ConnectedNodes.size();
    for(int i = 0; i < nodes; i++){
      node n = ConnectedNodes.get(i);
      for(Basic_Tower t : towerList){
        if(collision_helper.LB_collision(this.location, n.location, t.boxP1, t.boxP2)){//remove nodes connections if the box is in the way
          this.ConnectedNodes.remove(n);
          n.ConnectedNodes.remove(this);
          nodes = ConnectedNodes.size();
        }
      }
    }
    for(int x = -1; x < 2; x++){
      for(int y = -1; y < 2; y++){
        if((x == 0 && y == 0)||
          arrayLocation.x + x < 0 || arrayLocation.x + x > insideOf.arrayWidth - 1 ||
          arrayLocation.y + y < 0 || arrayLocation.y + y > insideOf.arrayHeigth - 1){
            //println("skipping connection");
        }else {
          node n = insideOf.nodeArray[(int)arrayLocation.x + x][(int)arrayLocation.y + y];
          if(n.enabled){
            n.wakeup();
          }
        }
      }
    }
  }
  
  public void wakeup(){//resolves a small bug with when a tower gets sold.
    for(int x = -1; x < 2; x++){
      for(int y = -1; y < 2; y++){
        if((x == 0 && y == 0)||
          arrayLocation.x + x < 0 || arrayLocation.x + x > insideOf.arrayWidth - 1 ||
          arrayLocation.y + y < 0 || arrayLocation.y + y > insideOf.arrayHeigth - 1){
            //println("skipping connection");
        }else {
          //println("doing tower check");
          node n = insideOf.nodeArray[(int)arrayLocation.x + x][(int)arrayLocation.y + y];
          if(n.enabled){
            //println("connecting a node to another one");
            if(!this.ConnectedNodes.contains(n)) this.ConnectedNodes.add(n);
            if(!n.ConnectedNodes.contains(this)) n.ConnectedNodes.add(this);
          } else {
            //println("A tower was in the way of the connection");
          }
        }
      }
    }
    int nodes = ConnectedNodes.size();
    for(int i = 0; i < nodes; i++){
      node n = ConnectedNodes.get(i);
      for(Basic_Tower t : towerList){
        if(collision_helper.LB_collision(this.location, n.location, t.boxP1, t.boxP2)){//remove nodes connections if the box is in the way
          this.ConnectedNodes.remove(n);
          n.ConnectedNodes.remove(this);
          nodes = ConnectedNodes.size();
        }
      }
    }
  }
  
  public void disable(){
    //remove self from all nodes and clear my own nodelist
    for(node n : ConnectedNodes){
      n.ConnectedNodes.remove(this);
    }
    ConnectedNodes.clear();
    enabled = false;
  }

  void drawing(){
    if(enabled){
      if (debugLevel > 1) {
        nodes = ConnectedNodes.size();
        for(int i = 0; i < nodes; i++){
          node node = ConnectedNodes.get(i);
          strokeWeight(1);
          stroke(0,0,0,100);
          //line(location.x, location.y, node.location.x, node.location.y);
          fill(30,30,100,255);
          line(location.x, location.y, node.location.x, node.location.y);
        }
        /*strokeWeight(3);
        stroke(0,150,150, 50);
        point(location.x, location.y);
        textSize(12);*/
        //text(nodes, location.x - 3, location. y);
      }
    }
  }
}

public class impossiblePathException extends Exception {
  public impossiblePathException(){
  }
  
  public impossiblePathException(String s){
    super(s);
  }
}//used to throw impossile path error