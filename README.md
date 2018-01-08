# [](#header-1)Elementalers Tower Defense

Elementalers Tower defense was the first project the HvA had thrown at us(during the FYS(Fasten Your Seatbelts) project. This project for us was mostly as simple as "Create any game you want". The only conditions that we had to keep in mind were; that the game was 2D, that the game was built in Processing (which for those unfamilair with processing meant Java) and lastly we were also forced to keep our controller schema to six buttons, the arrow keys and Z and X.

Within the project I quickly attained the role of Project Lead as the core concept was my idea (ontop of that I always wanted to make a tower defense) and that I clearly have the most experience from my group. We had two guys with HTML and CSS exerpience but that was about it. The other four  started from scratch. One of which left us somewhere around the end of the first month.

Huge swaths of the game's logic were built swiftly in the first couple of days. I quickly put a basic gameloop into the game along with a basic structure for the object instance, this would be the start of our inhertince schema which when drawn out now looks like this:

![](https://i.imgur.com/Oxkfwsx.png)

If you look closely at the code base you'll notice that this isn't entirly acurate, the rocks for example inherit from the tower class as the static objects class was forgetten about. But variouse other components were implemented smoothly.

One of the systems I loved was the combination system. This system made it so that towers placed in close proximity with one-another can combine into a new more powerfull tower.
```Java
//check the list, see if there are combinations that are valid. If so place them there. If not place them in the invalid list.
  public void checkCombineList() {

    ArrayList<Class> myClasses = new ArrayList<Class>();
    for (Basic_Tower t : combineTowerList) {//move data from combineTowerList to classes. this makes checking stuff easier
      myClasses.add(t.getClass());
    }

    //clear both lists we start from scratch
    validCombineList.clear();
    invalidCombineList = new ArrayList<ArrayList<Class>>(myCombinationsList);//assume everything is invalid
    //Figure out what we have exactly with class/count pairs
    for (ArrayList<Class> s : myCombinationsList) {
      ArrayList<Class> myClassesDupe = new ArrayList<Class>(myClasses);//dupe this list. We'll remove stuff from it that way we won't count the same tower twice.
      int requirements = s.size() - 1;//count self
    currentCombination:
      for (Class c : s) {
        if (myClassesDupe.contains(c)) {
          requirements--;
          myClassesDupe.remove(c);//prevent confirming the same thing over and over again
          if (requirements == 0) {
            validCombineList.add(s);
            break currentCombination;
          }
        }
      }
    }

    int n = 0;
    combinationAviable = (validCombineList.size() >= 1); //if there are any combinations possible, it is True
  }
```
This was one of the most important methods in the whole system which made the tower look within itself to see if it was possible for it to combine into something with it's neighboring towers.

Other systems I loved making was the Pathfinding, this was the first time for me implementing A* let alone pathfinding. The event system was also a joy to write. It was both a system to make random achievements and a way to force to player to take certain actions at certain times. We never ended up using this system too it's fullets potential becuase we had only enough time to implement a playable tutorial stage.

![](https://i.imgur.com/eqx81A3.png)
Image of the title screen.

![](https://i.imgur.com/IpxfExw.jpg)
In-game before enemy spawn.

![](https://i.imgur.com/J9XPKC2.jpg)
In-game during a wave.

The UI of this game was intresting to create. Most people however couldn't understand how it worked. Clearly we didn't test it enough **and** the design was not intuitive enough for the standard user. Ontop of the fact that most of the people at school didn't understand the genre... This made the game a technical marvel, but unfortunatly a visual and game-play failure. We managed to etch out a 7/10 for this project. On the techical review I did receive a 9/10 though, which is something I guess...

Download builds of the game [HERE](https://drive.google.com/open?id=1IoBqrV4zPO2ZC3OpqSieT7vr5cUenXKf).
If you find any bugs feel free to report them on the public github page this project is attached too(see links above)

[back](https://tdsrock.github.io/Projects)
