class ScreenSegment 
{
  List<WidgetBase> widgets;
  int segNum;
  
  public ScreenSegment()
  {
    widgets = new Vector<WidgetBase>();
    segNum = 0;
  }
  
  public ScreenSegment(int segNumber)
  {
    widgets = new Vector<WidgetBase>();
    segNum = segNumber;
  }
  
  public void draw(int _alpha)
  {
    for(WidgetBase wid : widgets)
    {
      wid.draw(_alpha);
    }
  }
  
  public void draw() {
    this.draw(255);
  }
  
  public boolean equals(int rhs) {
    return segNum == rhs;
  }
  
}
