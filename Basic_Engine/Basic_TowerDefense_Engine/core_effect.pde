class core_effect {
  
  ArrayList<atribute> atributes = new ArrayList<atribute>();
  core_effect(){
    new effect(this, "slow25_2");//slows for 25% for 2 seconds
    new condition(this, "on_hit");
  }
}
class atribute{
  String atributeName;
  
  atribute(core_effect creator, String name){
    creator.atributes.add(this);
    atributeName = name;
  }
}
class effect extends atribute{

  effect(core_effect creator, String name){
    super(creator, name);
    
  }
}

class condition extends atribute{

  condition(core_effect creator, String name){
    super(creator, name);
  }
  
}