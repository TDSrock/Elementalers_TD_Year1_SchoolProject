/*Most basic of objects possible. This object SHOULD be the parent of ALL other objects
* do this via the extends method, example:
* class bert extends object{  }
*/

class object {
  //variables each object has
  PVector location;
  boolean destroy = false;
  //constructor
  object(){
    objectList.add(this);
    this.create();
  }
  
  private void create(){
    //event for any code you want to run on creation

  }
  
  public void update(){
    //event for math stuff you want to run every frame
  }
  
  public void drawing(){
    //event for drawing stuff you want to run every frame
  }
  
  public void destroy(){
     //destory event 
  }
}