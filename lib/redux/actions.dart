import 'dart:io';

class LoginAction {
  LoginAction(this.payload);
  final Cookie payload;
}

class LogoutAction {
  LogoutAction();
}

class TitleAction {
  TitleAction(this.payload);
  final String payload;
}