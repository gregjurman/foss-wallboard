import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.Semaphore;
class RssItem
{
  String title, content;
  Date pubDate;
  public RssItem(String _title, String _content, Date _pubDate)
  {
    title = _title;
    content = _content;
    pubDate = _pubDate;
  }
}

class RssWidgetThread extends Thread 
{
  String sourceUrl;
  CopyOnWriteArrayList items;
  Semaphore sema;
  public RssWidgetThread(String _sourceUrl,  CopyOnWriteArrayList _items, Semaphore _sema)
  {
    sourceUrl = _sourceUrl;
    items = _items;
    sema = _sema;
  }
  
  public void run()
  {
    println("RSSWidget: Getting \""+sourceUrl+"\"\n");
    XMLElement rss = new XMLElement(createReader(sourceUrl));
    XMLElement[] itemsXMLElements = rss.getChildren("channel/item");
    List<RssItem> _it = new Vector<RssItem>();
    
    for (int i = 0; i < (itemsXMLElements.length > 10 ? 10 : itemsXMLElements.length); i++)
    {
      String title = (itemsXMLElements[i].getChildren("title")[0]).getContent();
      title = (title.length() >= 55 ? title.substring(0, 55).trim() : title) + "...";
      String body = ((itemsXMLElements[i].getChildren("description")[0]).getContent()).substring(0, 100) + "...";
      Date date = getDateFromString((itemsXMLElements[i].getChildren("pubDate")[0]).getContent());
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
  public RssWidget(int _x, int _y, int _w, int _h, String _sourceUrl)
  {
    super(_x, _y, _w, _h, 900);
    sema = new Semaphore(1, true);
    sourceUrl = _sourceUrl;
    title = "RSS Feed";
    items = new CopyOnWriteArrayList();
    
    cacheData();
  }
  
  void cacheData()
  {
    if(tThread == null)
    {
      tThread = new RssWidgetThread(sourceUrl, items, sema);
      tThread.setName("RssWidgetThread - "+ title);
      tThread.start();
    }
  }
  
  void drawImpl(int _alpha) 
  {
    int ya = 74;
    textAlign(LEFT);
    fill(0, 127*round((_alpha/255.0)));
    _roundRect(15, 15, width-30, height-30, 30);
    
    textFont(titleFont);
    fill(255, _alpha);
    text(title, 15, 45);
    
    textFont(subheaderFont);
    for(Object ri : items) 
    {
        try
        {
          sema.acquire();
          text(((RssItem)ri).title, 96, ya);
          sema.release();
        } 
        catch (InterruptedException e) {}
        
        ya+=28;
    }
    
    ya = 74;
    textFont(smallFont);  
    for(Object ri : items) 
    {
        try
        {
          sema.acquire();
          text("("+getDate(((RssItem)ri).pubDate)+")", 24, ya-1);
          sema.release();
        } 
        catch (InterruptedException e) {}
        
        ya+=28;
    }
  }
}
