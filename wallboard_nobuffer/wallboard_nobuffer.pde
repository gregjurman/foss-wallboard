//import fullscreen.*;

import processing.opengl.*;
import javax.media.opengl.GL;

iCalTimelineClock tl, inno;
RepoWatcherWidget rww;
Nepotism nepo;
PGraphicsOpenGL pgl;
GL gl;
PGraphics csiLogo;
LogoWidget foLogo;
ImagineQR iQR;
void setup()
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
 
 tl = new iCalTimelineClock(10, 30, screenWidth, 230, "http://foss.rit.edu/event/ical");
 tl.title = "FOSS@RIT Events";
 
 nepo = new Nepotism();
 rww = new RepoWatcherWidget(10, 270, screenWidth, screenHeight-100);
 foLogo = new LogoWidget("fossLogo.png", screenWidth-400, screenHeight-400, 400, 400);
 iQR = new ImagineQR(10, screenHeight-720);
}

int al = 255;

void draw()
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
