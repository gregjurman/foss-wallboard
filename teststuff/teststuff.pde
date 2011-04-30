import guru.ical4p.*;
import fullscreen.*;
import java.util.List;
/**
 * Words. 
 * 
 * The text() function is used for writing words to the screen. 
 */


int x = 30;
PFont fontA, fontSm;
PImage fossLogo;
PImage proLogo;
FullScreen fs;
FossCalendar fossCal;
List<GitHubUser> ghUsers;
PFont headerFont, subheaderFont, tinyFont, calSmallFont;
PImage worldMap;
float loc;

String[] ghUsernames = {"decause", "jlew", "gregjurman", "ralphbean", "lmacken"};

void setup() 
{
  headerFont = loadFont("PTSans-NarrowBold-36.vlw");
  subheaderFont = loadFont("PTSans-NarrowBold-24.vlw");
  tinyFont = loadFont("PTSans-Regular-14.vlw");
  calSmallFont = loadFont("PTSans-NarrowBold-12.vlw");
  ghUsers = new ArrayList<GitHubUser>();
  worldMap = loadImage("Worldmap-1280.png");
  gitHubLogo = loadImage("github.png");
  for(String user : ghUsernames) {
    GitHubUser temp = new GitHubUser(user);
    ghUsers.add(temp);
  }
  
  fossCal = new FossCalendar();
  size(screenWidth, screenHeight);
  fs = new FullScreen(this);
  frameRate(12);
  fossLogo = loadImage("logo.png");
  proLogo = loadImage("proc-logo.png");
  fs.enter();
  loc = 0;
  // Load the font. Fonts must be placed within the data 
  // directory of your sketch. Use Tools > Create Font 
  // to create a distributable bitmap font. 
  // For vector fonts, use the createFont() function. 
  fontA = loadFont("PTSans-NarrowBold-48.vlw");
  fontSm = loadFont("PTSans-Narrow-30.vlw");
  smooth();
  // Set the font and its size (in units of pixels)
}

void draw() {
  loc+=1;
  background(0);
  // Use fill() to change the value or color of the text
  drawStatic();
  int y = 25;
  for(GitHubUser ghu : ghUsers) {
    ghu.draw(25, y);
    y+=120;
  }
  //fossCal.drawTimeline(10, 160, 600);
  fossCal.drawTimeline(25, screenHeight-195, 450);
  text(round(frameRate)+"", 50, 50);
}

void drawStatic() {
  //Background
  if (loc >= worldMap.width) loc=1;
  image(worldMap,-(loc), 0);
  image(worldMap, worldMap.width-loc, 0);
  
  //Foss Logo
  image(fossLogo, screenWidth-(fossLogo.width/2)-5, screenHeight-(fossLogo.height/2)-5, 
        fossLogo.width/2, fossLogo.height/2);
  
  //Clock
  fill(255);
  textFont(fontA, 48);
//  String time = ((hour()<10) ? "0" : "") + hour() + ":" + 
//    ((minute()<10) ? "0" : "") + minute() + ":" + 
//    ((second()<10) ? "0" : "") + second() + " " +
//    ((hour() < 12) ? "AM" : "PM");
  textAlign(RIGHT);
  text(getClock(), screenWidth-5, 48);
  
  //Room Number
  text("CSI-1680", screenWidth-10, screenHeight-(fossLogo.height/2)+40);
  
  //Powered by Processing
//  image(proLogo, 2, screenHeight-27, 25*(proLogo.width/proLogo.height), 25);
//  textFont(tinyFont, 14);
//  textAlign(LEFT);
//  fill(39, 40, 210);
//  text("powered by processing.org", 30, screenHeight-7);
  
}
