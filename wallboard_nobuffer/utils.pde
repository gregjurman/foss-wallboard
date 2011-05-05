  void _roundRect(int x, int y, int w, int h, int r) {
     noStroke();
     rectMode(CORNER);
    
     int  ax, ay, hr;
    
     ax=x+w;
     ay=y+h;
     hr = r/2;
    
     rect(x, y, w, h);
     arc(x, y, r, r, radians(180.0), radians(270.0));
     arc(ax, y, r,r, radians(270.0), radians(360.0));
     arc(x, ay, r,r, radians(90.0), radians(180.0));
     arc(ax, ay, r,r, radians(0.0), radians(90.0));
     rect(x, y-hr, w, hr);
     rect(x-hr, y, hr, h);
     rect(x, y+h, w, hr);
     rect(x+w,y,hr, h);

}

  void _roundRect(int x, int y, int w, int h, int r, PGraphics _buffer) {   
     int  ax, ay, hr;
    
     ax=x+w;
     ay=y+h;
     hr = r/2;
     
     _buffer.noStroke();
     _buffer.rectMode(CORNER);
     _buffer.rect(x, y, w, h);
     _buffer.arc(x, y, r, r, radians(180.0), radians(270.0));
     _buffer.arc(ax, y, r,r, radians(270.0), radians(360.0));
     _buffer.arc(x, ay, r,r, radians(90.0), radians(180.0));
     _buffer.arc(ax, ay, r,r, radians(0.0), radians(90.0));
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

private String getDate(Date _date) {
  DateFormat dateFormat = new SimpleDateFormat("MM/dd/yy");
  return dateFormat.format(_date);
}


private Date getDateFromString(String _date)
{
  DateFormat df = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss zzz", Locale.ENGLISH);
  Date date = null;
  try
  {
    date = df.parse(_date);
  } catch (ParseException p) {}
  
  return date;
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

PImage roundRectImage(PImage imgIn, int radius) {
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
