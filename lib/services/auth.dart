import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wol_pro_1/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/upload_photo.dart';
import 'package:wol_pro_1/screens/register_login/refugee/register/register_refugee.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/register/register_volunteer_1.dart';
import 'package:wol_pro_1/services/database.dart';
import 'package:http/http.dart' as http;

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
            "The email address is already in use by another account.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}

class AuthService {
  static late AuthStatus status;
  String? tokenFirst;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  Users? _userFromCredUser(User? user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<Users?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromCredUser(user));
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromCredUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign in with email and password refugee
  Future signInWithEmailAndPasswordRef(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign in with email and password volunteer
  Future signInWithEmailAndPasswordVol(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

// register with email and password refugee
  Future registerWithEmailAndPasswordRef(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData('New refugee', '2',
          userNameRef, phoneNumberRef, [], user.uid, 0, 0, '', "", 0);
      return _userFromCredUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

// register with email and password volunteer
  Future registerWithEmailAndPasswordVol(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData(
          'New volunteer',
          '1',
          userName,
          phoneNumber,
          chosenCategoryListChanges,
          user.uid,
          volunteerRate,
          volunteerAge,
          image_url_volunteer,
          "",
          1);
      return _userFromCredUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> changePassword(String newPassword) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    tokenFirst = sharedPreferences.getString("token");
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:update?key='AIzaSyDxovtIAVt8ka_uAA9UrrypBBBLlrbev-w";
    try {
      await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'idToken': tokenFirst,
            'password': newPassword,
            'returnSecureToken': true,
          },
        ),
      );
    } catch (error) {
      throw error;
    }
  }

// sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    // await _auth
    //     .sendPasswordResetEmail(email: email)
    //     .then((value) => status = AuthStatus.successful)
    //     .catchError((e) => status = AuthExceptionHandler.handleAuthException(e));
    // return status;
  }
}
