/**
 A Simple Timeline to Show the how ical4p is used.<br> 
 by <a href="http://www.local-guru.net/blog">Guru</a>
 */


import guru.ical4p.*;

long xmin = Long.MAX_VALUE, xmax = 0;

Set events;
PFont font;

void setup() {
  size(600,200);
  smooth();
  noLoop();
  
  font = loadFont("BitstreamVeraSans-Roman-12.vlw");
  textFont( font, 12 );
  ICal cal = new ICal();
  cal.parse( dataPath("test.ics"));
  events = cal.getEvents();
  
  for (Iterator i = events.iterator(); i.hasNext(); ) {
    ICalEvent e = (ICalEvent)i.next();
    if (e.getStart().getTime() < xmin) { xmin = e.getStart().getTime(); }
    if (e.getStart().getTime() > xmax) { xmax = e.getStart().getTime(); } 
  }
}
  
void draw() {
    background(255);
    stroke(0);
    line(0, 3*height/4, width, 3*height/4); 
    
   for( Iterator i = events.iterator(); i.hasNext(); ) { 
     ICalEvent e = (ICalEvent)i.next();
     int pos = (int)map( e.getStart().getTime(), xmin, xmax, 10, width-50 );
     
     line( pos, 3*height/4 - 10, pos, 3*height/4 + 10 );
 
     pushMatrix();
     fill(0);
     translate( pos, 3*height/4 - 10);
     rotate( radians( -45 ));
     text( e.getSummary(), 0, 0);
     popMatrix();    
   }
}
