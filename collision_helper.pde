static class collision_helper{
  /* returns true if both points exsist on the same location
   * confirmed to work*/
  public static boolean PP_collision(PVector p1, PVector p2){
     return round(p1.x) == round(p2.x) && round(p1.y) == round(p2.y); 
  }
  /* returns true if the point is anywhere on the line
   * confirmed to work*/
  public static boolean PL_collision(PVector p1, PVector l1p1, PVector l1p2){ 
    if(!PB_collision(p1, l1p1, l1p2)){
      return false;
    }
    
    float slope = (l1p1.y - l1p2.y) / (l1p1.x - l1p2.x);
    float b = -(slope * l1p1.x) + l1p1.y;
    
    return round(p1.y) == round(slope * p1.x + b);
  }
  
  /* returns true if the point is within the box
   * confirmed to work*/
  public static boolean PB_collision(PVector p1, PVector b1p1, PVector b1p2){
    //gaurantee the box coordinates are top left and botom right.
    PVector box_tl = new PVector();
    PVector box_br = new PVector();

    //top and bot
    if(b1p1.y < b1p2.y){
      box_br.y = b1p1.y;
      box_tl.y = b1p2.y;
    } else {
      box_br.y = b1p2.y;
      box_tl.y = b1p1.y;
    }
    //left and right
    if(b1p1.x < b1p2.x){
      box_br.x = b1p1.x;
      box_tl.x = b1p2.x;
    } else {
      box_br.x = b1p2.x;
      box_tl.x = b1p1.x;
    }
    
    if(p1.x < box_tl.x && p1.x > box_br.x
    && p1.y < box_tl.y && p1.y > box_br.y) {
      return true;
    }
    
    return false;
  }
  /* returns true if the lines intersect anywhere
   * confirmed to work*/
  public static boolean LL_collision(PVector l1p1, PVector l1p2, PVector l2p1, PVector l2p2){
    float denominator = ((l1p2.x - l1p1.x) * (l2p2.y - l2p1.y)) - ((l1p2.y - l1p1.y) * (l2p2.x - l2p1.x));
    float numerator1 = ((l1p1.y - l2p1.y) * (l2p2.x - l2p1.x)) - ((l1p1.x - l2p1.x) * (l2p2.y - l2p1.y));
    float numerator2 = ((l1p1.y - l2p1.y) * (l1p2.x - l1p1.x)) - ((l1p1.x - l2p1.x) * (l1p2.y - l1p1.y));
    // Detect coincident lines (has a problem, conicedent lines that are not ontop of eachother still return true!)
    if (denominator == 0){ 
      //println("denom return occured, notify sjors about this if it is the first time you see this(I'll look into if I need to fix the issue that is in the comment above this line)");
      return numerator1 == 0 && numerator2 == 0;
    }

    float r = numerator1 / denominator;
    float s = numerator2 / denominator;

    return (r >= 0 && r <= 1) && (s >= 0 && s <= 1);
  }
  
  /* returns true if the line is inside the box or if the line crosses one of the box's lines
   * confirmed to work*/
  public static boolean LB_collision(PVector l1p1, PVector l1p2, PVector b1p1, PVector b1p2){
    //gaurantee the box coordinates are top left and botom right.
    PVector box_tl = new PVector();
    PVector box_br = new PVector();

    //top and bot
    if(b1p1.y < b1p2.y){
      box_br.y = b1p1.y;
      box_tl.y = b1p2.y;
    } else {
      box_br.y = b1p2.y;
      box_tl.y = b1p1.y;
    }
    //left and right
    if(b1p1.x < b1p2.x){
      box_br.x = b1p1.x;
      box_tl.x = b1p2.x;
    } else {
      box_br.x = b1p2.x;
      box_tl.x = b1p1.x;
    }
    
    //if either of the points are within the box return true, no need to do more complicated checks
    if(PB_collision(l1p1, box_tl, box_br)
    || PB_collision(l1p2, box_tl, box_br)) {
      return true;
    }
    //check if the line collides with any of the lines the of the box.
    PVector box_tr = new PVector(box_br.x, box_tl.y);
    PVector box_bl = new PVector(box_tl.x, box_br.y);
    if(LL_collision(l1p1, l1p2, box_br, box_bl)
    || LL_collision(l1p1, l1p2, box_br, box_tr)
    || LL_collision(l1p1, l1p2, box_tl, box_tr)
    || LL_collision(l1p1, l1p2, box_tl, box_bl)){
      return true;
    }
    
    return false;
  }
  /* returns true if the line is inside the box or if the line crosses one of the box's lines
   * confirmed to work*/
  public static boolean BB_collision(PVector b1p1, PVector b1p2, PVector b2p1, PVector b2p2){
    //gaurantee the box coordinates are top left and botom right, on both.
    PVector box1_tl = new PVector();
    PVector box1_br = new PVector();

    //top and bot
    if(b1p1.y < b1p2.y){
      box1_br.y = b1p1.y;
      box1_tl.y = b1p2.y;
    } else {
      box1_br.y = b1p2.y;
      box1_tl.y = b1p1.y;
    }
    //left and right
    if(b1p1.x < b1p2.x){
      box1_br.x = b1p1.x;
      box1_tl.x = b1p2.x;
    } else {
      box1_br.x = b1p2.x;
      box1_tl.x = b1p1.x;
    }
    PVector box1_tr = new PVector(box1_br.x, box1_tl.y);
    PVector box1_bl = new PVector(box1_tl.x, box1_br.y);
    
    PVector box2_tl = new PVector();
    PVector box2_br = new PVector();

    //top and bot
    if(b1p1.y < b1p2.y){
      box2_br.y = b2p1.y;
      box2_tl.y = b2p2.y;
    } else {
      box2_br.y = b2p2.y;
      box2_tl.y = b2p1.y;
    }
    //left and right
    if(b1p1.x < b1p2.x){
      box2_br.x = b2p1.x;
      box2_tl.x = b2p2.x;
    } else {
      box2_br.x = b2p2.x;
      box2_tl.x = b2p1.x;
    }
    PVector box2_tr = new PVector(box2_br.x, box2_tl.y);
    PVector box2_bl = new PVector(box2_tl.x, box2_br.y);
    
    //check if any of the lines collide
    if(LB_collision(box1_tl, box1_tr, box2_tl, box2_br)
    || LB_collision(box1_tl, box1_bl, box2_tl, box2_br)
    || LB_collision(box1_br, box1_tr, box2_tl, box2_br)
    || LB_collision(box1_br, box1_bl, box2_tl, box2_br)){
      return true;
    }
    
    if(LB_collision(box2_tl, box2_tr, box1_tl, box1_br)
    || LB_collision(box2_tl, box2_bl, box1_tl, box1_br)
    || LB_collision(box2_br, box2_tr, box1_tl, box1_br)
    || LB_collision(box2_br, box2_bl, box1_tl, box1_br)){
      return true;
    }
    
    return false;
  }
  /* returns true if the point is inside the circle
   * confirmed to work*/
  public static boolean PC_collision(PVector p1, PVector c1, float c1_r){
    //built in box check before doing circle check to make this method faster
    PVector box_tl = new PVector(c1.x - c1_r, c1.y - c1_r);
    PVector box_br = new PVector(c1.x + c1_r, c1.y + c1_r);
    
    if(PB_collision(p1, box_tl, box_br)){//NOTE TO SELF: test if this actualy makes it faster
      if(PVector.dist(c1, p1) < c1_r){
        return true;
      }
    }
  return false;
  }
  /* returns true if either point is inside the circle or if the line intersects with the circle
   * confirmed to work*/
  public static boolean LC_collision(PVector l1p1, PVector l1p2, PVector c1, float c1_r){
    //First lets figure out if either point is within the circle, if so we can just return true
    if(PC_collision(l1p1, c1, c1_r)
    || PC_collision(l1p2, c1, c1_r)){
      return true;
    }
    
    PVector LocalP1 = PVector.sub(l1p1, c1);
    PVector LocalP2 = PVector.sub(l1p2, c1);
    PVector P2MinusP1 = PVector.sub(LocalP2, LocalP1);
  
    float a = (P2MinusP1.x) * (P2MinusP1.x) + (P2MinusP1.y) * (P2MinusP1.y);
    float b = 2 * ((P2MinusP1.x * LocalP1.x) + (P2MinusP1.y * LocalP1.y));
    float c = (LocalP1.x * LocalP1.x) + (LocalP1.y * LocalP1.y) - (c1_r * c1_r);
    float delta = b * b - (4 * a * c);
    if (delta < 0){
      return false;
    }else if (delta == 0){
      return false;
    }else if (delta > 0){//might aswell be an else, but mehh;
      float SquareRootDelta = sqrt(delta);
      
      float u1 = (-b + SquareRootDelta) / (2 * a);
      if( u1 > 0 && u1 < 1)
        return true;
      float u2 = (-b - SquareRootDelta) / (2 * a);
      if( u2 > 0 && u2 < 1)
        return true;
    }
    return false;
  }
  /* returns true if any point is inside the circle or if any line intersects with the circle or if the circle's center is within the box
   * confirmed to work*/
  public static boolean BC_collision(PVector b1p1, PVector b1p2, PVector c1, float c1_r){
    //gaurantee the box coordinates are top left and botom right, on both.
    PVector box1_tl = new PVector();
    PVector box1_br = new PVector();

    //top and bot
    if(b1p1.y < b1p2.y){
      box1_br.y = b1p1.y;
      box1_tl.y = b1p2.y;
    } else {
      box1_br.y = b1p2.y;
      box1_tl.y = b1p1.y;
    }
    //left and right
    if(b1p1.x < b1p2.x){
      box1_br.x = b1p1.x;
      box1_tl.x = b1p2.x;
    } else {
      box1_br.x = b1p2.x;
      box1_tl.x = b1p1.x;
    }
    
    PVector box1_tr = new PVector(box1_br.x, box1_tl.y);
    PVector box1_bl = new PVector(box1_tl.x, box1_br.y);
    
    if(PB_collision(c1, box1_tl, box1_br)){
      return true;
    }
    
    //check if any of the box points is within the circle
    if(PC_collision(box1_tl, c1, c1_r)
    || PC_collision(box1_tr, c1, c1_r)
    || PC_collision(box1_bl, c1, c1_r)
    || PC_collision(box1_br, c1, c1_r)){
      return true;
    }
    
    //check if any of the lines intersect with the circle
    if(LC_collision(box1_br, box1_bl, c1, c1_r)
    || LC_collision(box1_br, box1_tr, c1, c1_r)
    || LC_collision(box1_tl, box1_bl, c1, c1_r)
    || LC_collision(box1_tl, box1_tr, c1, c1_r)){
      return true;
    }
    
    return false;
  }
  
  public static boolean CC_collision(PVector c1, float c1_r, PVector c2, float c2_r){
    //check if either circle falls within another
    if(PC_collision(c1, c2, c2_r)
    || PC_collision(c2, c1, c1_r)){
      return true;
    }
    return pow((abs(c2.x-c1.x)), 2) + pow((abs(c1.y - c2.y)), 2) <= pow((c1_r + c2_r), 2);
  }

}