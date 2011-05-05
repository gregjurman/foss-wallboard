import guru.ical4p.*;

class iCalTimelineThread extends Thread {
  CopyOnWriteArraySet events;
  Semaphore sema;
  ICal cal;
  String sourceUrl;
  
  public iCalTimelineThread(CopyOnWriteArraySet _events, Semaphore _sema, String _calendar) {
    sema = _sema;
    events = _events;
    sourceUrl = _calendar;
    cal = new ICal();
  }
  
  public void run() {
    println("WidgetTimeline: Getting \""+sourceUrl+"\"\n");
    try
    {
      cal.parse(createInput(sourceUrl));
      sema.acquire();
      if (events != null)
      {
        events.clear();
        events.addAll(cal.getEvents());
      }
      else
      {
        events = new CopyOnWriteArraySet(cal.getEvents());
      }
      sema.release();
    } catch(InterruptedException e) {}
    
  }
  
}

class iCalTimelineClock extends iCalTimeline {
  public iCalTimelineClock(int _x, int _y, int _w, int _h, String _sourceUrl)
  {
    super(_x, _y, _w, _h, _sourceUrl);
  }
  
  void drawImpl(int _alpha)
  {
    super.drawImpl(_alpha);
    fill(255, _alpha);
    textFont(headerFont);
    textAlign(RIGHT);
    text(getDate(), width-30, 30);
    text(getTime(), width-30, 58);
  }
}
  

class iCalTimeline extends DataWidget {
  CopyOnWriteArraySet events;
  String sourceUrl;
  String title = "";
  Semaphore sema;
  public iCalTimeline(int _x, int _y, int _w, int _h, String _sourceUrl) {
    super( _x, _y, _w, _h, 3600);
    sourceUrl = _sourceUrl;
    sema = new Semaphore(1, true);
    events = new CopyOnWriteArraySet();
    cacheData();
  }
  
  void cacheData()
  {
    if(tThread == null)
    {
      tThread = new iCalTimelineThread(events, sema, sourceUrl);
      tThread.setName("iCalTimeline-Calendar("+title+")");
      tThread.start();
    }
  }

  void drawImpl(int _alpha) {
    float pixelPerSec = (width-50) / 1296000.0;
    long rTime = (long)(System.currentTimeMillis() / 1000L);
    int tlCenter = height - 70;
    float a = _alpha/255.0;  
  
    fill(0,127*a);
    _roundRect(15, 15, this.width-50, this.height-62, 30);
    
    //Background and title
    fill(255, 255*a);
    smooth();
    textFont(headerFont, 24);
    textAlign(LEFT, TOP);
    text((title != "") ? title : "Events Timeline", 15, 15);
    textFont(subheaderFont, 18);
    text("Upcoming Events (next 15-days):", 20, 37);
    
    // Base Timeline
    textFont(smallFont, 14);
    stroke(255, 255*a);
    strokeWeight(2); 
    line(50, tlCenter, width-40, tlCenter);
      
    // Current Month
    stroke(240,0,0, 255*a);
    strokeWeight(2);
    line(50, tlCenter-8, 50, tlCenter+8);
    textFont(headerFont, 24);
    textAlign(RIGHT, CENTER);
    text(getTextMonth(), 45, tlCenter);
    
    //Next Month
    if (getNumMonth((new Date()).getTime() + 1296000000L) != month()) {
      Date d = getNextMonth();
      long xPos = (long)(((long)(d.getTime()/1000L) - rTime) * pixelPerSec); 
      stroke(255, 0, 0, (((width-xPos) / (float)width) * 255)*a);
      line(50+xPos, tlCenter-8, 50+xPos, tlCenter+8);
      textFont(smallFont, 14);
      textAlign(CENTER);
      text(getTextMonth(d), 50+xPos, tlCenter+32);
    }
    
    //Events
    try
    {
      sema.acquire();
      if (events != null) {
        long totalEndTime = (long)(System.currentTimeMillis() / 1000L) + 1296000;
        int lastDay = 0;
        for( Iterator i = events.iterator(); i.hasNext(); ) { 
           ICalEvent e = (ICalEvent)i.next();
           if ((long)(e.getStart().getTime()/1000) <= totalEndTime)
           {
             long xPos = (long)(((long)(e.getStart().getTime()/1000L) - rTime) * pixelPerSec);
             stroke(255, (((width-xPos) / (float)width) * 255)*a);
             line(50+xPos, tlCenter-6, 50+xPos, tlCenter+6);
             int eDay = getDayNum(e.getStart());
             if (lastDay != eDay) {
              textFont(smallFont, 14);
              textAlign(CENTER); 
              text(eDay, xPos+50,tlCenter+22);
              lastDay = eDay;
             }
             textAlign(LEFT);
             pushMatrix();
             fill(255, 255*a);
             translate(xPos+50, tlCenter-10);
             smooth();
             rotate( radians( -45 ));
             textFont(smallFont, 14);
             String summary = e.getSummary();
             text(((summary.length() >= 18) ? summary.substring(0,17) + "..." : summary), 0, 0);
             popMatrix();
           }
        }
      }
      sema.release();
    } catch (InterruptedException e) {}
  }
}
