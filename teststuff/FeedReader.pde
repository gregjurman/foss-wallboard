// feedParser.pde
//
// Reads RSS and Atom feeds. Requires ROME
// (https://rome.dev.java.net/)
// and JDOM (http://www.jdom.org/), just make
// a code folder and copy "jdom.jar" and "rome-*.jar"
// into it.
//
// Marius Watz - http://workshop.evolutionzone.com

import com.sun.syndication.feed.synd.*;
import com.sun.syndication.io.*;

class FeedReader {
  SyndFeed feed;
  String url,description,title;
  int numEntries;
  FeedEntry entry[];

  public FeedReader(String _url) {
    url=_url;
    try {
      feed=new SyndFeedInput().build(new XmlReader(new URL(url)));
      description=feed.getDescription();
      title=feed.getTitle();
      
      java.util.List entrl=feed.getEntries();
      Object [] o=entrl.toArray();
      numEntries=o.length;
      
      entry=new FeedEntry[numEntries];
      for(int i=0; i< numEntries; i++) {
        entry[i]=new FeedEntry((SyndEntryImpl)o[i]);
        //println(i+": "+entry[i]);
      }
    }
    catch(Exception e) {
      println("Exception in Feedreader: "+e.toString());
      e.printStackTrace();
    }
  }

}

class FeedEntry {
  Date pubdate;
  SyndEntryImpl entry;
  String author, contents, description, url, title;
  public String newline = System.getProperty("line.separator");

  public FeedEntry(SyndEntryImpl _entry) {
    try {
      entry=_entry;
      author=entry.getAuthor();
      Object [] o=entry.getContents().toArray();
      if(o.length>0) contents=((SyndContentImpl)o[0]).getValue();
      else contents="[No content.]";

//      description=entry.getDescription().getValue();
//      print("herp");
//      if(description.charAt(0)==
//        System.getProperty("line.separator").charAt(0))
//          description=description.substring(1);

//      url=entry.getLink();
      title=entry.getTitle();
      pubdate=entry.getPublishedDate();
    }
    catch(Exception e) {
      println("Exception in FeedEntry: "+e.toString());
      e.printStackTrace();
    }

  }
}
//  public String toString() {
//    String s;
//
//    s="Title: "+title+newline+
//      "URL: "+url+newline+
//      "Date: "+pubdate.toString()+newline;
//
//    if(description.length()>50)
//      s+="Descr: ["+description.substring(0,50)+
//        "...]"+newline;
//    else s+="Descr: ["+description+"]"+newline;
//
//    if(contents.length()>50)
//      s+="Contents: ["+contents.substring(0,50)+
//        "...]"+newline;
//    else s+="Contents: ["+contents+"]"+newline;
//    return s;
//  }

