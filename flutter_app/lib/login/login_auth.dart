import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import "package:google_sign_in/google_sign_in.dart";

abstract class BaseAuth{
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> signInWithGoogle();
  Future<FirebaseUser> getCurrentUser() ;
  Future<void> signOut();
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signIn(String email, String password) async{
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async{
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async{
    return _firebaseAuth.signOut();
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    return user.uid; //user 정보를 넘기게 되면 이름 및 사진 같은것도 받을 수 있음
  }
}
