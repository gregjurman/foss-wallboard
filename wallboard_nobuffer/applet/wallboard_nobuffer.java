import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import javax.media.opengl.GL; 
import java.util.Vector; 
import java.util.Iterator; 
import java.util.Date; 
import java.util.concurrent.*; 
import com.github.api.v2.schema.User; 
import com.github.api.v2.services.GitHubServiceFactory; 
import com.github.api.v2.services.UserService; 
import java.awt.Color; 
import guru.ical4p.*; 

import com.sun.syndication.feed.module.impl.*; 
import com.github.api.v2.services.auth.*; 
import com.sun.syndication.feed.rss.*; 
import com.sun.syndication.feed.synd.impl.*; 
import com.sun.syndication.feed.synd.*; 
import com.sun.syndication.feed.module.*; 
import org.jdom.*; 
import com.sun.syndication.feed.*; 
import com.github.api.v2.services.impl.*; 
import com.github.api.v2.services.constant.*; 
import org.jdom.adapters.*; 
import com.google.gson.*; 
import com.google.gson.reflect.*; 
import org.jdom.input.*; 
import com.sun.syndication.feed.impl.*; 
import com.google.gson.internal.*; 
import com.github.api.v2.services.*; 
import com.github.api.v2.services.util.*; 
import com.sun.syndication.io.impl.*; 
import org.jdom.xpath.*; 
import com.google.gson.stream.*; 
import com.google.gson.annotations.*; 
import org.jdom.output.*; 
import com.github.api.v2.schema.*; 
import org.jdom.filter.*; 
import com.sun.syndication.feed.atom.*; 
import com.sun.syndication.io.*; 
import org.jdom.transform.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class wallboard_nobuffer extends PApplet {

//import fullscreen.*;




iCalTimelineClock tl, inno;
RepoWatcherWidget rww;
Nepotism nepo;
PGraphicsOpenGL pgl;
GL gl;
PGraphics csiLogo;
LogoWidget foLogo;
ImagineQR iQR;
public void setup()
{
 size(screenWidth, screenHeight, OPENGL);
 loadFonts();
 csiLogo = loadSVG("csi_logo_bw.svg", 200, 200);
 pgl = (PGraphicsOpenGL) g; //processing graphics object
 gl = pgl.beginGL(); //begin opengl
 gl.setSwapInterval(1); //set vertical sync on
 pgl.endGL();
 
 smooth();
 frameRate(60);
 
 tl = new iCalTimelineClock(10, 10, screenWidth, 230, "http://foss.rit.edu/event/ical");
 tl.title = "FOSS@RIT Events";
 
 nepo = new Nepotism();
 rww = new RepoWatcherWidget(10, 260, screenWidth, screenHeight-100);
 foLogo = new LogoWidget("fossLogo.png", screenWidth-400, screenHeight-400, 400, 400);
 iQR = new ImagineQR(10, screenHeight-720);
}

int al = 255;

public void draw()
{
  nepo.draw();
  foLogo.draw();
  image(csiLogo, 0, screenHeight-200);
  iQR.draw();
  tl.draw();
  rww.draw();
  fill(255);
  textFont(headerFont);
  
  textAlign(CENTER, CENTER);
  fill(255);
  text(round(frameRate), screenWidth/2, screenHeight-40);
}
PFont headerFont, subheaderFont, smallFont, tinyFont, bigNumFont, titleFont;

public void loadFonts() {
  headerFont = loadFont("PTSans-NarrowBold-24.vlw");
  subheaderFont = loadFont("PTSans-NarrowBold-18.vlw");
  tinyFont = loadFont("PTSans-Bold-16.vlw");
  smallFont = loadFont("PTSans-Regular-14.vlw");
  bigNumFont = loadFont("PTSans-Bold-64.vlw");
  titleFont = loadFont("PTSans-NarrowBold-40.vlw");
}
class ImagineQR extends LogoWidget {
  PImage imagineLogo;
  public ImagineQR(int _x, int _y)
  {
    super("qrcode.png", _x, _y, 400, 400);
    imagineLogo = loadSVG("imagine_logo.svg", round(35*4.5f), 35);
  }
  
  public void drawImpl(int _alpha)
  {
    fill(0, 127*(_alpha/255.0f));
    _roundRect(15, 15, width+30, height+80, 30);
    image(imagineLogo, width-imagineLogo.width+40, 15);
    fill(255, 255*(_alpha/255.0f));
    textFont(titleFont);
    textAlign(LEFT);
    text("CSI-106", 15, 45);
    textFont(subheaderFont);
    textAlign(LEFT);
    text("Open Source Language Learning & Translation Tools", 22, 67);
    
    tint(255, 255*(_alpha/255.0f));
    imageMode(CENTER);
    image(logo, 232, 285);
    imageMode(CORNER);
  }
}
class LogoWidget extends WidgetBase 
{
  PImage logo;
  public LogoWidget(String _fileName, int _x, int _y, int _w, int _h) {
     super(_x, _y, _w, _h);
     logo = loadPicture(_fileName, _w, _h);
  }
  
  public void drawImpl(int _alpha)
  {
    tint(255, 255*(_alpha/255.0f));
    image(logo, width-logo.width, height-logo.height);
  }
}



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
  
  public void draw() {
    this.draw(0,0);
  }
 
  public void draw(int _x, int _y) {
    if (xMove > (worldMap.width))
    {
      xMove = 1;
    }
    image(worldMap, -(xMove), 0);
    xMove+=0.2f;
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
  
  public void draw(float x, float y) {
    if (!finalized){
      x+=this.x;
      y+=this.y;
      brightness-=0.5f;
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
  public void _roundRect(int x, int y, int w, int h, int r) {
     noStroke();
     rectMode(CORNER);
    
     int  ax, ay, hr;
    
     ax=x+w;
     ay=y+h;
     hr = r/2;
    
     rect(x, y, w, h);
     arc(x, y, r, r, radians(180.0f), radians(270.0f));
     arc(ax, y, r,r, radians(270.0f), radians(360.0f));
     arc(x, ay, r,r, radians(90.0f), radians(180.0f));
     arc(ax, ay, r,r, radians(0.0f), radians(90.0f));
     rect(x, y-hr, w, hr);
     rect(x-hr, y, hr, h);
     rect(x, y+h, w, hr);
     rect(x+w,y,hr, h);

}

  public void _roundRect(int x, int y, int w, int h, int r, PGraphics _buffer) {   
     int  ax, ay, hr;
    
     ax=x+w;
     ay=y+h;
     hr = r/2;
     
     _buffer.noStroke();
     _buffer.rectMode(CORNER);
     _buffer.rect(x, y, w, h);
     _buffer.arc(x, y, r, r, radians(180.0f), radians(270.0f));
     _buffer.arc(ax, y, r,r, radians(270.0f), radians(360.0f));
     _buffer.arc(x, ay, r,r, radians(90.0f), radians(180.0f));
     _buffer.arc(ax, ay, r,r, radians(0.0f), radians(90.0f));
     _buffer.rect(x, y-hr, w, hr);
     _buffer.rect(x-hr, y, hr, h);
     _buffer.rect(x, y+h, w, hr);
     _buffer.rect(x+w,y,hr, h);
}

private String getDate() {
  DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
  Date date = new Date();
  return dateFormat.format(date);
}

private String getTime() {
  DateFormat dateFormat = new SimpleDateFormat("hh:mm:ss a");
  Date date = new Date();
  return dateFormat.format(date);
}

private String getTextMonth() {
  DateFormat dateFormat = new SimpleDateFormat("MMM");
  Date date = new Date();
  return dateFormat.format(date);
}

private String getTextMonth(Date stamp) {
  DateFormat dateFormat = new SimpleDateFormat("MMM");
  return dateFormat.format(stamp);
}

private int getDayNum(Date stamp) {
  DateFormat dateFormat = new SimpleDateFormat("dd");
  return Integer.parseInt(dateFormat.format(stamp));
}

private int getNumMonth(long timestamp) {
  DateFormat dateFormat = new SimpleDateFormat("MM");
  return Integer.parseInt(dateFormat.format(new Date(timestamp)));
}

private String getClock() {
  DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy\n hh:mm:ss a");
  Date date = new Date();
  return dateFormat.format(date);
}

private Date getNextMonth() {
  DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
  Date date = new Date(month()+1 + "/01/" + year());
  return date;
}

private PGraphics loadSVG(String fileName, int _width, int _height)
{
  PShape svgFile = loadShape(fileName);
  PGraphics _rastImage = createGraphics(_width, _height, JAVA2D);
  _rastImage.beginDraw();
  _rastImage.smooth();
  _rastImage.shape(svgFile, 2, 2, _width-4, _height-4);
  _rastImage.endDraw();
  
  svgFile = null;
  
  return _rastImage;
}

private PGraphics loadPicture(String fileName, int _width, int _height)
{
  PImage imgFile = loadImage(fileName);
  imgFile.resize(((_width >= _height) ? _width : 0), ((_width <= _height) ? 0 : _height));
  PGraphics _rastImage = createGraphics(imgFile.width+4, imgFile.height+4, JAVA2D);
  _rastImage.beginDraw();
  _rastImage.smooth();
  _rastImage.image(imgFile, 2, 2, imgFile.width-4, imgFile.height-4);
  _rastImage.endDraw();
  
  imgFile = null;
  
  return _rastImage;
}

public PImage roundRectImage(PImage imgIn, int radius) {
  PGraphics tempMask = createGraphics(imgIn.width, imgIn.height, JAVA2D);
  //tempMask.doNotCache = true;
  tempMask.beginDraw();
  tempMask.background(0);
  tempMask.fill(255);
  _roundRect(radius, radius, imgIn.width-(radius*2), imgIn.height-(radius*2), radius, tempMask);
  tempMask.endDraw();
  tempMask.loadPixels();
  imgIn.mask(tempMask);
  tempMask = null;
  //imgIn.doNotCache = false;
  return imgIn;
}



class WidgetBase{
  int y , x;
  int height, width;
  public WidgetBase(int _x, int _y, int _width, int _height) {
    x = _x;
    y = _y;
    width = _width;
    height = _height;
  }
  
  public void draw() {
    draw(x, y, 255);
  }
  
  public void draw(int _alpha) {
    draw(x, y, _alpha);
  }
  
  public void draw(int _x, int _y) {
    draw(_x, _y);
  }
  
  public void draw(int _x, int _y, int _alpha) {
    pushMatrix();
    translate(x, y);
    drawImpl(_alpha);
    popMatrix();
    noTint();
  }
  
  public void drawImpl(int _alpha) {}
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
  
  public void cacheData() {}
  
  public void draw(int _x, int _y)
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






interface RepoHostAPI {
  public RepoUser getUserInfo(RepoUser _username);
  //Repo getRepoInfo(String _username, String _reponame);
}

class RepoUser {
  String userName;
  String fullName;
  int publicRepos;
  int followers;
  int watching;
  int following;
  PImage userIcon;
  PGraphics userBuffer;
  
  public RepoUser(String _username)
  {
    userName = _username;
  }
  
    public boolean equals(String u)
  {
    return (u == this.userName);
  }
}

class GitHubUser extends RepoUser {
 public GitHubUser(String _username) {
  super(_username);
 }
}

class RepoHost {
   PImage repoIcon;
   public RepoHost() {}
}

class GitHubApi extends RepoHost implements RepoHostAPI {
  GitHubServiceFactory ghFactory;
  UserService usrService;
  
  public GitHubApi() 
  {
    ghFactory = GitHubServiceFactory.newInstance();
    usrService = ghFactory.createUserService();
    repoIcon = loadImage("github.png");

    repoIcon.loadPixels();
  }
  
  public RepoUser getUserInfo(RepoUser ghu)
  {
    User user = usrService.getUserByUsername(ghu.userName);
    ghu.fullName = user.getName();
    ghu.publicRepos = user.getPublicRepoCount();
    ghu.followers = user.getFollowersCount(); 
    ghu.following = user.getFollowingCount();
    ghu.watching = -1;
    PImage tmp = loadImage("http://gravatar.com/avatar/" + user.getGravatarId(), "jpg");
    tmp.loadPixels();
    
    ghu.userIcon = roundRectImage(tmp, 10);
    tmp = null;
    
    return ghu;
  }
  
  public void drawUserInfo(RepoUser user, int _w, int _h) 
  {
    if (user.userBuffer != null) user.userBuffer.dispose();
    user.userBuffer = null;
    user.userBuffer = createGraphics(_w, _h, JAVA2D);
    user.userBuffer.beginDraw();
    user.userBuffer.textAlign(LEFT);
    user.userBuffer.fill(0,127);
    _roundRect(15, 15, _w-50, 70, 30, user.userBuffer);
    user.userBuffer.textFont(headerFont);
    user.userBuffer.smooth();
    user.userBuffer.image(user.userIcon, 10, 10);
    user.userBuffer.fill(255);
    user.userBuffer.text(user.fullName, 90, 34);
    user.userBuffer.textFont(subheaderFont);
    user.userBuffer.text(user.userName, 95, 54);
    user.userBuffer.textFont(tinyFont);
    user.userBuffer.textAlign(CENTER);
    user.userBuffer.text("public repos", _w-240, 82);
    user.userBuffer.text("following", _w-100, 82);
    user.userBuffer.textFont(bigNumFont);
    user.userBuffer.text(user.publicRepos, _w-240, 64);
    user.userBuffer.text(user.following, _w-100, 64);
    user.userBuffer.image(this.repoIcon, 95, 62);
    user.userBuffer.endDraw();
  }
}

String gitHubUsers[] = { "decause", "jlew", "gregjurman", "ralphbean", "lmacken", "jeresig" };

class RepoWatcherThread extends Thread {
  Semaphore avail;
  Vector<RepoUser> userMap;
  GitHubApi ghApi;
  RepoWatcherThread(Semaphore _avail, Vector<RepoUser> _userMap) {
    avail = _avail;
    userMap = _userMap;
    ghApi = new GitHubApi();
  }
  
  public void run()
  {
    RepoUser u = null;
    boolean nextI = true;

    for (Iterator<RepoUser> i = userMap.iterator(); i.hasNext(); ) 
    {
      if(nextI) u = (RepoUser)i.next();
      nextI = false;
      
      try
      {
        avail.acquire();
        ghApi.getUserInfo(u);
        ghApi.drawUserInfo(u, width, height/7);
        avail.release();
        nextI = true;
      }
      catch(InterruptedException e) {nextI = false;}
      catch(ConcurrentModificationException cme) {nextI = false;}
    }
  }
}


class RepoWatcherWidget extends DataWidget {
  Vector<RepoUser> users;
  Semaphore avail;
  
  public RepoWatcherWidget(int _x, int _y, int _w, int _h)
  {
    super(_x, _y, _w, _h, 900);
    users = new Vector<RepoUser>();
    for (String u: gitHubUsers) { users.add(new RepoUser(u));}
    avail = new Semaphore(1, true);
    cacheData();
  }
  
  public void cacheData()
  {
    if(tThread == null)
    {
      tThread = new RepoWatcherThread(avail, users);
      tThread.setName("RepoWatcher-GitHub");
      tThread.start();
    }
  }
  
  public void drawImpl(int _alpha) 
  {
    int ya = 12;
    fill(255, _alpha);
    textFont(titleFont);
    textAlign(LEFT);
    text("State of the FOSS", 0, 0);
    for(RepoUser ru : users) 
    {
      if (ru.userBuffer != null)
      {
        try
        {
          avail.acquire();
          tint(255, _alpha);
          image(ru.userBuffer, 0, ya);
          avail.release();
        } catch (InterruptedException e) {}
        ya+=110;
      }
    }
  }
}


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
  
  public void drawImpl(int _alpha)
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
  
  public void cacheData()
  {
    if(tThread == null)
    {
      tThread = new iCalTimelineThread(events, sema, sourceUrl);
      tThread.setName("iCalTimeline-Calendar("+title+")");
      tThread.start();
    }
  }

  public void drawImpl(int _alpha) {
    float pixelPerSec = (width-50) / 1296000.0f;
    long rTime = (long)(System.currentTimeMillis() / 1000L);
    int tlCenter = height - 70;
    float a = _alpha/255.0f;  
  
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
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "wallboard_nobuffer" });
  }
}
