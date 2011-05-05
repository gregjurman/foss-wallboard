class RssItem
{
  String title, content;
  long time;
  public RssItem(String _title, String _content, long _time)
  {
    title = _title;
    content = _content;
    time = _time;
  }
  
  boolean equals(long rhs)
  {
    return (this.time==rhs);
  }
}

class RssWidgetThread extends Thread 
{
  String sourceUrl;
  CopyOnWriteArrayList items;
  Semaphore sema;
  public RssWidgetThread(String _sourceUrl, CopyOnWriteArrayList _items, Semaphore _sema)
  {
    sourceUrl = _sourceUrl;
    items = _items;
    sema = _sema;
  }
  
  public void run()
  {
    println("RSSWidget: Getting \""+sourceUrl+"\"\n");
    XMLElement rss = new XMLElement(null, sourceUrl);
    XMLElement[] itemsXMLElements = rss.getChildren("channel/item");
    List<RssItem> _it = new Vector<RssItem>();
    
    for (int i = 0; i < itemsXMLElements.length; i++)
    {
      String title = (itemsXMLElements[i].getChildren("title")[0]).getContent();
      String body = ((itemsXMLElements[i].getChildren("description")[0]).getContent()).substring(0, 100);
      long date = getDateFromString((itemsXMLElements[i].getChildren("pubDate")[0]).getContent()).getTime();
      _it.add(new RssItem(title, body, date));
    }
    
    boolean failed = true;
    while(failed) 
    {
      try
      {
        sema.acquire();
        items.clear();
        items.addAll(_it);
        sema.release();
        failed = false;
      } 
      catch(InterruptedException e) {}
    }
  }
}

class RssWidget extends DataWidget 
{
  String sourceUrl, title;
  CopyOnWriteArrayList items;
  Semaphore sema;
  public RssWidget(int _x, int _y, int _h, int _w, String _sourceUrl)
  {
    super(_x, _y, _w, _h, 900);
    sema = new Semaphore(1, true);
    sourceUrl = _sourceUrl;
    title = "RSS";
    items = new CopyOnWriteArrayList();
    
    cacheData();
  }
  
  void cacheData()
  {
    if(tThread == null)
    {
      tThread = new RssWidgetThread(sourceUrl, items, sema);
      tThread.setName("RssWidgetThread");
      tThread.start();
    }
  }
  
  void drawImpl(int _alpha) 
  {
    int ya = 12;
    
    for(Object ri : items) 
    {
        try
        {
          sema.acquire();
          tint(255, _alpha);
          textFont(subheaderFont);
          text(((RssItem)ri).title, 0, ya);
          sema.release();
        } 
        catch (InterruptedException e) {}
        
        ya+=28;
    }
  }
}
