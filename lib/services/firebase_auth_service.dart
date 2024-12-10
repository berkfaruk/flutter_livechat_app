import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/services/auth_base.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel?> currentUser() async {
    try {
      User user = await _firebaseAuth.currentUser!;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  UserModel? _userFromFirebase(User? user) {
    if(user == null) {
      return null;
    } else {
      return UserModel(userID: user.uid, email: user.email!);
    }
    
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(result.user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

      final _facebookLogin = FacebookLogin();
      await _facebookLogin.logOut();

      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential result = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User _user = result.user!;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    final _facebookLogin = FacebookLogin();
    FacebookLoginResult _facebookResult = await _facebookLogin.logIn(
        permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email
        ]);

    switch (_facebookResult.status) {
      case FacebookLoginStatus.success:
        if (_facebookResult.accessToken != null) {
          UserCredential _firebaseResult = await _firebaseAuth
              .signInWithCredential(FacebookAuthProvider.credential(
                  _facebookResult.accessToken!.token));
          User _user = _firebaseResult.user!;
          return _userFromFirebase(_user);
        }
        break;

      case FacebookLoginStatus.cancel:
        print("Facebook Login Canceled by User");
        break;

      case FacebookLoginStatus.error:
        print("Error : ${_facebookResult.error}");
        break;
    }
    return null;
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(result.user!);
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(result.user!);
  }
}
