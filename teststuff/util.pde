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

private String getDate() {
  DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
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
