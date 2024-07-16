import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:koofit/login/login.dart';

class KakaoLogin implements Sociallogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (error) {
          return false;
        }
      } else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (error) {
          return false;
        }
      }
    } catch (error) {
      return false;
    }
  }

  @override // 로그인 유지를 카카오톡으로 안해도 됨 (카카오톡 로그인 상태는 sdk에 unlink전까지 자동 유지)
  Future<bool> keeplogin() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        await UserApi.instance.accessTokenInfo();
        return true;
      } catch (error) {
        return false;
      }
    }
    return false;
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }
}
