import java.util.Vector;
import java.util.Iterator;
import org.json.*;
 
class NepotistThread extends Thread implements QPidCallback
{
  String sourceUrl;
  CopyOnWriteArrayList nepoSet;
  QPidClient _client;
  int mapWidth, mapHeight;
  public NepotistThread(String _sourceUrl, CopyOnWriteArrayList _nepoSet, int mWidth, int mHeight)
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
         this.sleep(10000);
       }
    } catch(InterruptedException e) {}
  }
  
  void handleTextMessage(String message)
  {
    try
    {
      //println(message);
      try {
        JSONObject narcData = new JSONObject(message);
        JSONArray latlong = narcData.getJSONArray("features").getJSONObject(0).getJSONObject("geometry").getJSONArray("coordinates");
        float _lat = (float)latlong.getDouble(0);
        float _long = (float)latlong.getDouble(1);
        
        println("Lat: " + _lat + "  Long: " + _long);
        }
        catch (JSONException e) {
          println ("There was an error parsing the JSONObject.");
        }
//      
////      Lat: -77.6376 Long: 43.089905
////      Lat: 204.7248 Long: 187.64038
////      Lat: -77.6376 Long: 43.089905
////      Lat: 204.7248 Long: 187.64038
//      
//      float x = (mapWidth/2.0) + loc.longitude*(mapWidth/360.0);
//      float y = log( tan(loc.latitude)+ (1.0/cos(loc.latitude)) )*(mapHeight/180.0);
//      nepoSet.add(new NepoPoint(x, ((-1 * loc.latitude) + 90) * (mapHeight / 180), 255));
    } catch (Exception e) {}
  }
}


class Nepotist extends WidgetBase {
  PImage worldMap;
  float xMove;
  CopyOnWriteArrayList<NepoPoint> points;
  Semaphore sema;
  Thread tThread;
  
  public Nepotist() {
    super(0, 0, screenWidth, screenHeight);
    worldMap = loadImage("Worldmap-"+screenHeight+".tga");
    worldMap.loadPixels();
    xMove = 3000;
    this.points = new CopyOnWriteArrayList<NepoPoint>();
    sema = new Semaphore(1, true);
    tThread = new NepotistThread("", this.points, worldMap.width, worldMap.height);
    tThread.start();
    //points.add(new NepoPoint((worldMap.width/2.0) + (-77.6376)*(worldMap.width/360.0), GudermannianInv(43.089905), 255));
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
      //brightness-=1;
      ellipseMode(CENTER);
      noStroke();
      fill(0, 255, 0, brightness);
      ellipse(x, y, 15, 15);
      if (brightness <= 0) {finalized = true;}
    } 
  }  
}
