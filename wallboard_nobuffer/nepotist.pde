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
  
  protected float lat2y(float lat)
  {
    return (180.0/PI) * log(tan((PI/4.0)+(lat*PI/360.0)));
  }
  
  void handleTextMessage(String message)
  {
    println(message);
    try {
      JSONObject narcData = new JSONObject(message);
      JSONArray latlong = narcData.getJSONArray("features").getJSONObject(0).getJSONObject("geometry").getJSONArray("coordinates");
      //float _long = (float)latlong.getDouble(0);
      //float _lat = (float)latlong.getDouble(1);
      float _long = 0;
      float _lat = 0;
      float z = pow(2, 4); //Zoom is at 4
      float x = ((_long + 180)/360.0) * z * 256;
      float y =2048;
      print ("("+x+","+y+")");
      if (nepoSet.size() < 100) nepoSet.add(new NepoPoint(x, y, 255));
    }
    catch (JSONException e) {
      println ("There was an error parsing the JSONObject.");
    }
    catch (Exception e) {}
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
    xMove = 0;
    this.points = new CopyOnWriteArrayList<NepoPoint>();
    sema = new Semaphore(1, true);
    tThread = new NepotistThread("", this.points, worldMap.width, worldMap.height);
    //tThread.start();
    
      float _long = -77.67;
      float _lat = 42.5;
      float z = 16; //Zoom is 4
      //256) * (worldMap.width/4096.0)
      float x = ((_long + 180)/360.0) * z;
      float y = ( 1 - ( log( tan(_lat) + (1.0/cos(_lat)) ) / PI) ) / 2.0 * z;
      x*=(256 * (800/4096.0));
      y*=(256 * (800/4096.0));
      print ("("+x+","+y+")");
      if (points.size() < 100) points.add(new NepoPoint(x, y, 255));
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
    //sema.acquire();
    Iterator itr = points.iterator();
    List<NepoPoint> delSet = new Vector<NepoPoint>();
    while(itr.hasNext()) {
      NepoPoint item = (NepoPoint)itr.next();
      //item.draw(0, 0);
      if (item.finalized) {delSet.add(item);}
      if (xMove > worldMap.width-screenWidth) {
        item.draw(worldMap.width-xMove, 0);
      }
    }
    //sema.acquire();
    points.removeAll(delSet);
    //sema.release();
    delSet.clear();
    delSet = null;
    } catch (Exception e) {}
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
      //brightness-=5;
      ellipseMode(CENTER);
      noStroke();
      fill(0, 255, 0, brightness);
      ellipse(x, y, 5, 5);
      if (brightness <= 0) {finalized = true;}
    } 
  }  
}
