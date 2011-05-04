import java.util.Date;
import java.util.concurrent.*;

class WidgetBase{
  int y , x;
  int height, width;
  public WidgetBase(int _x, int _y, int _width, int _height) {
    x = _x;
    y = _y;
    width = _width;
    height = _height;
  }
  
  void draw() {
    draw(x, y, 255);
  }
  
  void draw(int _alpha) {
    draw(x, y, _alpha);
  }
  
  void draw(int _x, int _y) {
    draw(_x, _y);
  }
  
  void draw(int _x, int _y, int _alpha) {
    pushMatrix();
    translate(x, y);
    drawImpl(_alpha);
    popMatrix();
    noTint();
  }
  
  void drawImpl(int _alpha) {}
}

class DataWidget extends WidgetBase {
  long dataCacheTime;
  long lastDataTime;
  Thread tThread;
  
  public DataWidget(int _x, int _y, int _width, int _height, long _dataCacheTime) {
    super(_x, _y, _width, _height);
    dataCacheTime = _dataCacheTime;
    lastDataTime = (System.currentTimeMillis() / 1000L);
  }
  
  void cacheData() {}
  
  void draw(int _x, int _y)
  {
    if ((tThread != null) && (!tThread.isAlive())) {
      println("DataWidget: Destroying finished interior thread. ("+tThread.getName()+")");
      tThread = null;
    }
    if (((System.currentTimeMillis() / 1000L)-lastDataTime > dataCacheTime))  {
      cacheData();
      lastDataTime = (System.currentTimeMillis() / 1000L);
    }
    
    super.draw(_x, _y);
  }

}

