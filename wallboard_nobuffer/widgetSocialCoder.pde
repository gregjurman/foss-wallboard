import com.github.api.v2.schema.User;
import com.github.api.v2.services.GitHubServiceFactory;
import com.github.api.v2.services.UserService;
import java.awt.Color;

interface RepoHostAPI {
  RepoUser getUserInfo(RepoUser _username);
  //Repo getRepoInfo(String _username, String _reponame);
}

class RepoUser {
  String userName;
  String fullName;
  int publicRepos;
  int followers;
  int watching;
  int following;
  PImage userIcon;
  PGraphics userBuffer;
  
  public RepoUser(String _username)
  {
    userName = _username;
  }
  
    boolean equals(String u)
  {
    return (u == this.userName);
  }
}

class GitHubUser extends RepoUser {
 public GitHubUser(String _username) {
  super(_username);
 }
}

class RepoHost {
   PImage repoIcon;
   public RepoHost() {}
}

class GitHubApi extends RepoHost implements RepoHostAPI {
  GitHubServiceFactory ghFactory;
  UserService usrService;
  
  public GitHubApi() 
  {
    ghFactory = GitHubServiceFactory.newInstance();
    usrService = ghFactory.createUserService();
    repoIcon = loadImage("github.png");

    repoIcon.loadPixels();
  }
  
  RepoUser getUserInfo(RepoUser ghu)
  {
    User user = usrService.getUserByUsername(ghu.userName);
    ghu.fullName = user.getName();
    ghu.publicRepos = user.getPublicRepoCount();
    ghu.followers = user.getFollowersCount(); 
    ghu.following = user.getFollowingCount();
    ghu.watching = -1;
    PImage tmp = loadImage("http://gravatar.com/avatar/" + user.getGravatarId(), "jpg");
    tmp.loadPixels();
    
    ghu.userIcon = roundRectImage(tmp, 10);
    tmp = null;
    
    return ghu;
  }
  
  void drawUserInfo(RepoUser user, int _w, int _h) 
  {
    if (user.userBuffer != null) user.userBuffer.dispose();
    user.userBuffer = null;
    user.userBuffer = createGraphics(_w, _h, JAVA2D);
    user.userBuffer.beginDraw();
    user.userBuffer.textAlign(LEFT);
    user.userBuffer.fill(0,127);
    _roundRect(15, 15, _w-50, 70, 30, user.userBuffer);
    user.userBuffer.textFont(headerFont);
    user.userBuffer.smooth();
    user.userBuffer.image(user.userIcon, 10, 10);
    user.userBuffer.fill(255);
    user.userBuffer.text(((user.fullName == null) ? user.userName : user.fullName), 90, 34);
    user.userBuffer.textFont(subheaderFont);
    user.userBuffer.text(((user.fullName == null) ? "" : user.userName), 95, 54);
    user.userBuffer.textFont(tinyFont);
    user.userBuffer.textAlign(CENTER);
    user.userBuffer.text("public repos", _w-380, 82);
    user.userBuffer.text("following", _w-100, 82);
    user.userBuffer.text("followers", _w-240, 82);
    user.userBuffer.textFont(bigNumFont);
    user.userBuffer.text(user.publicRepos, _w-380, 64);
    user.userBuffer.text(user.following, _w-100, 64);
    user.userBuffer.text(user.followers, _w-240, 64);
    user.userBuffer.image(this.repoIcon, 95, 62);
    user.userBuffer.endDraw();
  }
}

String[][] gitHubUsers = { {"decause", "jlew", "gregjurman", "ralphbean", "lmacken", "jeresig"}, {"mansam", "ryansb", "RyanWoods", "thequbit"}};

class RepoWatcherThread extends Thread {
  Semaphore avail;
  Vector<RepoUser> userMap;
  GitHubApi ghApi;
  RepoWatcherThread(Semaphore _avail, Vector<RepoUser> _userMap) {
    avail = _avail;
    userMap = _userMap;
    ghApi = new GitHubApi();
  }
  
  void run()
  {
    RepoUser u = null;
    boolean nextI = true;

    for (Iterator<RepoUser> i = userMap.iterator(); i.hasNext(); ) 
    {
      if(nextI) u = (RepoUser)i.next();
      nextI = false;
      
      try
      {
        avail.acquire();
        ghApi.getUserInfo(u);
        ghApi.drawUserInfo(u, width, height/7);
        avail.release();
        nextI = true;
      }
      catch(InterruptedException e) {nextI = false;}
      catch(ConcurrentModificationException cme) {nextI = false;}
    }
  }
}


class RepoWatcherWidget extends DataWidget {
  Vector<RepoUser> users;
  Semaphore avail;
  int screenNum = 0;
  int totalScreens = 1;
  
  public RepoWatcherWidget(int _x, int _y, int _w, int _h)
  {
    super(_x, _y, _w, _h, 900);
    users = new Vector<RepoUser>();
    for (String u: gitHubUsers[0]) { users.add(new RepoUser(u));}
    avail = new Semaphore(1, true);
    cacheData();
  }
  
  public RepoWatcherWidget(int _x, int _y, int _w, int _h, int _screen, int _totalScreens)
  {
    super(_x, _y, _w, _h, 900);
    users = new Vector<RepoUser>();
    for (String u: gitHubUsers[_screen]) { users.add(new RepoUser(u));}
    avail = new Semaphore(1, true);
    screenNum = _screen;
    totalScreens = _totalScreens;
    cacheData();
  }
  
  void cacheData()
  {
    if(tThread == null)
    {
      tThread = new RepoWatcherThread(avail, users);
      tThread.setName("RepoWatcher-GitHub");
      tThread.start();
    }
  }
  
  void drawImpl(int _alpha) 
  {
    int ya = 24;
    fill(255, _alpha);
    textFont(titleFont);
    textAlign(LEFT);
    text("State of the FOSS ("+(screenNum+1)+"/"+totalScreens+")", 0, 0);
    for(RepoUser ru : users) 
    {
      if (ru.userBuffer != null)
      {
        try
        {
          avail.acquire();
          tint(255, _alpha);
          image(ru.userBuffer, 0, ya);
          avail.release();
        } catch (InterruptedException e) {}
        ya+=110;
      }
    }
  }
}
