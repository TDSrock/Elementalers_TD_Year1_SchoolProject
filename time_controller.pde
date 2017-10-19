
class time_controller{
  
  float time;
    
    public time_controller(){
      
    }
    
    public void update(){
      time = (float)millis()/1000;
    }
    
    public void drawing(){
      textAlign(RIGHT, CENTER);
      fill(0,0,0);
      textSize(16);
      //text(time, 950, 30);
      text((int)frameRate + " fps", width- 20, 20);
      textAlign(LEFT, CENTER);
    }
    
}