import guru.ical4p.*;

import java.util.Date;
import java.util.Calendar;
import java.text.DateFormat;
import java.text.SimpleDateFormat;



class FossCalendar
{
  ICal cal;
  Set events;
  public FossCalendar() {
    cal = new ICal();
    cal.parse( createInput("http://foss.rit.edu/event/ical"));
    events = cal.getEvents();
  }
  
  void drawTimeline(int x, int y, int w) {
      
      fill(0, 60);
      _roundRect(x, y, w, 170, 25);
      fill(255);
      textFont(subheaderFont, 24);
      textAlign(RIGHT);
      text(getTextMonth(), x+40, y+146);
      textAlign(LEFT);
      text("Upcoming Events (next 15-days):", x+4, y+22);
      
      textFont(tinyFont, 14);
      stroke(127, 50);
      strokeWeight(2);
      line(x+50, y+140, w, y+140);
      strokeWeight(1); 
      line(x+50, y+140, w, y+140);
      
      stroke(240,0,0);
      strokeWeight(2);
      line(x+50, y+132, x+50, y+148);
      
      float pixelPerSec = w / 1296000.0;
      
      long rTime = (long)(System.currentTimeMillis() / 1000L);
      
      if (getNumMonth((new Date()).getTime() + 1296000000L) != month()) {
        Date d = getNextMonth();
        long xPos = (long)(((long)(d.getTime()/1000L) - rTime) * pixelPerSec); 
        stroke(255,0,0, ((w-xPos) / (float)w) * 255);
        line(x+50+xPos, y+132, x+50+xPos, y+148);
        textAlign(CENTER);
        text(getTextMonth(d), x+50+xPos, y+162);
      }
      stroke(255);
      
      long totalEndTime = (long)(System.currentTimeMillis() / 1000L) + 1296000;
      int lastDay = 0;
      for( Iterator i = events.iterator(); i.hasNext(); ) { 
        
         ICalEvent e = (ICalEvent)i.next();
         
         if ((long)(e.getStart().getTime()/1000) <= totalEndTime)
         {
           long xPos = (long)(((long)(e.getStart().getTime()/1000L) - rTime) * pixelPerSec);
           stroke(255, ((w-xPos) / (float)w) * 255);
           line(x+50+xPos, y+134, x+50+xPos, y+146);
           int eDay = getDayNum(e.getStart());
           if (lastDay != eDay)
           {
            textAlign(CENTER); 
            text(eDay, x+xPos+50,y+162);
            lastDay = eDay;
           }
           textAlign(LEFT);
           pushMatrix();
           fill(255);
           translate(xPos+75, y+130);
           rotate( radians( -45 ));
           textFont(tinyFont, 14);
           String summary = e.getSummary();
           text(((summary.length() >= 18) ? summary.substring(0,17) + "..." : summary), 0, 0);
           popMatrix();
         }
      }
  }
}
