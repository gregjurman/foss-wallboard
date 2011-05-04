import java.util.Vector;
import java.util.Iterator;

class Nepotism extends WidgetBase {
  PImage worldMap;
  float xMove;
  Vector<NepoPoint> points;
  public Nepotism() {
    super(0, 0, screenWidth, screenHeight);
    worldMap = loadImage("Worldmap-"+screenHeight+".tga");
    worldMap.loadPixels();
    xMove = 3000;
    this.points = new Vector<NepoPoint>();
    for(int i=0; i<64; i++) {
      this.points.add(new NepoPoint(random(worldMap.width), random(worldMap.height), round(random(50, 255))));
    }
  }
  
  void draw() {
    this.draw(0,0);
  }
 
  void draw(int _x, int _y) {
    if (xMove > (worldMap.width))
    {
      xMove = 1;
    }
    image(worldMap, -(xMove), 0);
    xMove+=0.2;
    if (xMove > worldMap.width-screenWidth) 
    {
      image(worldMap, worldMap.width-xMove-1, 0);
    }
    
    stroke(0,1,42);
    strokeWeight(2);
    smooth();
    //line(worldMap.width-xMove, 0, worldMap.width-xMove, screenHeight);
    
    Iterator itr = points.iterator();
    Vector<NepoPoint> delSet = new Vector<NepoPoint>();
    while(itr.hasNext()) {
      NepoPoint item = ((NepoPoint)itr.next());
      item.draw(-(xMove), 0);
      if (item.finalized) delSet.add(item);
      if (xMove > worldMap.width-screenWidth) {
        item.draw(worldMap.width-xMove, 0);
      }
    }
    this.points.removeAll(delSet);
    delSet = null;
    
    if(round(xMove)%13 == 0) {
        this.points.add(new NepoPoint(random(worldMap.width), random(worldMap.height), round(random(50, 255))));
    }
  }
}

class NepoPoint {
  float x, y; 
  float brightness;
  boolean finalized;
  public NepoPoint(float _x, float _y) {
    x = _x;
    y = _y;
    brightness = 255;
    finalized = false;
  }
  
  public NepoPoint(float _x, float _y, int _brightness) {
    x = _x;
    y = _y;
    brightness = _brightness;
    finalized = false;
  }
  
  void draw(float x, float y) {
    if (!finalized){
      x+=this.x;
      y+=this.y;
      brightness-=0.5;
      ellipseMode(CENTER);
      noStroke();
      fill(0, 255, 0, brightness);
      ellipse(x, y, 15, 15);
      fill(0, 255, 0, brightness-50);
      ellipse(x, y, 16, 16);
      fill(0, 255, 0, brightness-200);
      ellipse(x, y, 17, 17);
      if (brightness <= 0) {finalized = true;}
    } 
  }  
}
