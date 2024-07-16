import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:koofit/login/login.dart';

class Loginview {
  final Sociallogin _sociallogin;
  bool islogined = false;
  User? user;

  Loginview(this._sociallogin);

  Future login() async {
    islogined = await _sociallogin.login();
    if (islogined) {
      user = await UserApi.instance.me();
    }
  }

  Future logout() async {
    await _sociallogin.logout();
    islogined = false;
  }
}
