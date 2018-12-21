class User{

  String userName;
  String userPassword;

  User(this.userName, this.userPassword);

  User.fromMap(Map map) {
    userName = map[userName];
    userPassword = map[userPassword];
  }

}