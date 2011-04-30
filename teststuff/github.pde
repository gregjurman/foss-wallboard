import java.util.List;

import com.github.api.v2.schema.User;
import com.github.api.v2.services.GitHubServiceFactory;
import com.github.api.v2.services.UserService;

GitHubServiceFactory ghFactory = GitHubServiceFactory.newInstance();
UserService usrService = ghFactory.createUserService();

PImage gitHubLogo;

class GitHubUser {
  User user;
  PImage userIcon;
  String username, fullname;
  public GitHubUser(String _username) {
    username = _username;
    user = usrService.getUserByUsername(_username);
    userIcon = loadImage("http://gravatar.com/avatar/" + user.getGravatarId(), "jpg");
  }
  
  void draw(int x, int y) {
     fill(0, 70);
     _roundRect(x, y, 400, 85, 25);
     image(gitHubLogo, x+355, y+68);
     image(userIcon, x+5, y+5, 75*(userIcon.width/userIcon.height), 75);
     textAlign(LEFT);
     fill(255);
     textFont(headerFont, 36);
     text(user.getName(), x+85, y+36);
     
     textFont(subheaderFont, 24);
     text(user.getLogin(), x+90, y+64);
  } 
}
