import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:stairstepsport/src/di/locator.dart';
import 'package:stairstepsport/src/states/user_state.dart';

class SplashController extends ControllerMVC {
  GoogleSignIn _googleSignIn = locator<GoogleSignIn>();

  void checkLogin(Function(bool) callback) async {
    await UserState.initState();
    bool logedIn = await _googleSignIn.isSignedIn();
    if (logedIn) {
      if (UserState.getUserData().weight != null) {
        callback(true);
      } else {
        callback(false);
      }
    } else {
      callback(false);
    }
  }
}
