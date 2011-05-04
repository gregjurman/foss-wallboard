class LogoWidget extends WidgetBase 
{
  PImage logo;
  public LogoWidget(String _fileName, int _x, int _y, int _w, int _h) {
     super(_x, _y, _w, _h);
     logo = loadPicture(_fileName, _w, _h);
  }
  
  void drawImpl(int _alpha)
  {
    tint(255, 255*(_alpha/255.0));
    image(logo, width-logo.width, height-logo.height);
  }
}
