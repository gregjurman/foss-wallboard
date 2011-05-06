//import fullscreen.*;

import processing.opengl.*;
import javax.media.opengl.GL;

List<ScreenSegment> screenSegs;

RepoWatcherWidget rww;
Nepotism nepo;
PGraphicsOpenGL pgl;
GL gl;
PGraphics csiLogo;
LogoWidget foLogo;
ImagineQR iQR;
//RssWidget hackADay;

iCalTimelineClock tl;
void setup()
{
  // Buffer and OpenGL Settings
  size(screenWidth, screenHeight, OPENGL);
  pgl = (PGraphicsOpenGL) g; //processing graphics object
  gl = pgl.beginGL(); //begin opengl
  gl.setSwapInterval(1); //set vertical sync on
  pgl.endGL();
  smooth();
  frameRate(60);
  
  // Load fonts
  loadFonts();
   
  // Initialize Screen Segments
  screenSegs = new Vector<ScreenSegment>();
  ScreenSegment s0 = new ScreenSegment(0);
  ScreenSegment s1 = new ScreenSegment(1);
  
  // Repo Watchmen
  s0.widgets.add(new RepoWatcherWidget(10, 260, screenWidth, screenHeight-100, 0, 2));
  s1.widgets.add(new RepoWatcherWidget(10, 260, screenWidth, screenHeight-100, 1, 2));
    
  // Add to ScreenSegment Vector

  
  // Load CSI Logo
  csiLogo = loadSVG("csi_logo_bw.svg", 200, 200);
  foLogo = new LogoWidget("fossLogo.png", screenWidth-400, screenHeight-400, 400, 400);
   
  // Start FOSS Calendar
  tl = new iCalTimelineClock(10, 10, screenWidth, 230, "http://foss.rit.edu/event/ical");
  tl.title = "FOSS@RIT Events";
   
  // Start Nepotism
  nepo = new Nepotism();
  
  // Imagine RIT QR code Widget (Remove after Imagine RIT)
  iQR = new ImagineQR(10, screenHeight-720);
  
  // Hack-a-Day RSS
  RssWidget hackADay = new RssWidget(500, screenHeight-720, screenWidth-510, 375, "http://feeds.feedburner.com/hackaday/LgoM?format=xml");
  hackADay.title = "Hack-A-Day";
  
  RssWidget osFeed = new RssWidget(500, screenHeight-720, screenWidth-510, 375, "http://opensource.com/feed");
  osFeed.title = "Opensource.com";
  
  s0.widgets.add(hackADay);
  s1.widgets.add(osFeed);
  
  lastSwap = (System.currentTimeMillis() / 1000L);
  screenSegs.add(s0);
  screenSegs.add(s1);
}

int al = 255;

int sIter = 0;
long waitTime = 5;
long lastSwap = (System.currentTimeMillis() / 1000L);

void draw()
{
  // Render Nepotism in background
  nepo.draw();
  
  // FOSSBox and CSI Logo
  foLogo.draw();
  image(csiLogo, 0, screenHeight-200);
  
  // Imagine RIT QR code (Remove after Imagine RIT)
  iQR.draw();
  
  // Foss Events Timeline
  tl.draw();
  
  // RepoWatcher Screen Segments
  screenSegs.get(sIter).draw();
  
  if ((System.currentTimeMillis() / 1000L) > lastSwap + waitTime)
  {
    lastSwap = (System.currentTimeMillis() / 1000L);
    sIter++;
    if (sIter >= screenSegs.size()) sIter=0;
  }
  
  // Hack-a-day RSS Feed
  //hackADay.draw();
  
  // Framerate
  fill(255);
  textFont(headerFont);
  textAlign(CENTER, CENTER);
  fill(255);
  text(round(frameRate), screenWidth/2, 100);
}
