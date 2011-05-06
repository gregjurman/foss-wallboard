import java.util.Vector;
import java.util.Iterator;
 
class NepotismThread extends Thread implements QPidCallback
{
  String sourceUrl;
  CopyOnWriteArrayList nepoSet;
  QPidClient _client;
  int mapWidth, mapHeight;
  public NepotismThread(String _sourceUrl, CopyOnWriteArrayList _nepoSet, int mWidth, int mHeight)
  {
    sourceUrl = _sourceUrl;
    nepoSet = _nepoSet;
    mapWidth = mWidth;
    mapHeight = mHeight;
  }
  
  public void run()
  {
    _client = new QPidClient(this);
    try
    {
       while(true) {
         this.sleep(500);
         //nepoSet.add(new NepoPoint(random(mapWidth), random(mapHeight), round(random(50, 255))));
       }
    } catch(InterruptedException e) {}
  }
  
  void handleTextMessage(String message)
  {
    nepoSet.add(new NepoPoint(random(mapWidth), random(mapHeight), round(random(50, 255))));
  }
}


class Nepotism extends WidgetBase {
  PImage worldMap;
  float xMove;
  CopyOnWriteArrayList<NepoPoint> points;
  Semaphore sema;
  Thread tThread;
  
  public Nepotism() {
    super(0, 0, screenWidth, screenHeight);
    worldMap = loadImage("Worldmap-"+screenHeight+".tga");
    worldMap.loadPixels();
    xMove = 3000;
    this.points = new CopyOnWriteArrayList<NepoPoint>();
    sema = new Semaphore(1, true);
    tThread = new NepotismThread("", this.points, worldMap.width, worldMap.height);
    tThread.start();
//    for(int i=0; i<64; i++) {
//      this.points.add(new NepoPoint(random(worldMap.width), random(worldMap.height), round(random(50, 255))));
//    }
  }
  
  void finalize()
  {
    tThread.interrupt();
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
    
    // Get a lock
    try
    {
    sema.acquire();
    Iterator itr = points.iterator();
    List<NepoPoint> delSet = new Vector<NepoPoint>();
    while(itr.hasNext()) {
      NepoPoint item = (NepoPoint)itr.next();
      item.draw(-(xMove), 0);
      if (item.finalized) {delSet.add(item);}
      if (xMove > worldMap.width-screenWidth) {
        item.draw(worldMap.width-xMove, 0);
      }
    }

    points.removeAll(delSet);
    sema.release();
    delSet.clear();
    delSet = null;
    } catch (InterruptedException e) {}
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
      brightness-=1;
      ellipseMode(CENTER);
      noStroke();
      fill(0, 255, 0, brightness);
      ellipse(x, y, 15, 15);
      if (brightness <= 0) {finalized = true;}
    } 
  }  
}
