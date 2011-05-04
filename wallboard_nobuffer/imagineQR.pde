class ImagineQR extends LogoWidget {
  PImage imagineLogo;
  public ImagineQR(int _x, int _y)
  {
    super("qrcode.png", _x, _y, 400, 400);
    imagineLogo = loadSVG("imagine_logo.svg", round(35*4.5), 35);
  }
  
  void drawImpl(int _alpha)
  {
    fill(0, 127*(_alpha/255.0));
    _roundRect(15, 15, width+30, height+80, 30);
    image(imagineLogo, width-imagineLogo.width+40, 15);
    fill(255, 255*(_alpha/255.0));
    textFont(titleFont);
    textAlign(LEFT);
    text("CSI-106", 15, 45);
    textFont(subheaderFont);
    textAlign(LEFT);
    text("Open Source Language Learning & Translation Tools", 22, 67);
    
    tint(255, 255*(_alpha/255.0));
    imageMode(CENTER);
    image(logo, 232, 285);
    imageMode(CORNER);
  }
}
