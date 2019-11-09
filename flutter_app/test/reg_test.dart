/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gteams/login/login_auth.dart';
import 'package:gteams/signup/sign_up.dart';

class AuthMock implements Auth{
  AuthMock({this.userId});
  String userId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool didRequestSignIn = false;
  bool didrequestCreateUser = false;
  bool didRequestLogout = false;

  Future<String> signIn(String email, String password) async{
    didRequestSignIn = true;
    return _userIdOrError();
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

  Future<String> signInWithGoogle() async{
    didRequestSignIn = true;
    return _userIdOrError();
  }

  Future<String> _userIdOrError() {
    if (userId != null) {
      return Future.value(userId);
    }
    else {
      throw StateError('no user');
    }
  }
}

void main(){
  Widget buildTestableWidget(Widget widget){
    return new MediaQuery(data: new MediaQueryData(),
        child: new MaterialApp(home: widget));
  }

  void _onSignedIn(){
    print("testing..");
  }

  testWidgets('cannot use empty email and password', (WidgetTester tester) async{
    AuthMock mock = new AuthMock(userId: 'uid');
    LoginPage loginPage = new LoginPage(auth: mock);
    await tester.pumpWidget(buildTestableWidget(loginPage));

    Finder loginButton = find.byKey(new Key('login_btn'));
    await tester.tap(loginButton);

    await tester.pump();

    Finder hintText = find.byKey(new Key('hint'));

    expect(mock.didRequestSignIn, false);
  });

  testWidgets('non-empty email and password, valid account, calls sign in, succeeds', (WidgetTester tester) async{
    AuthMock mock = new AuthMock(userId: 'uid');
    LoginPage loginPage = new LoginPage(auth: mock, onSignedIn: _onSignedIn,);
    await tester.pumpWidget(buildTestableWidget(loginPage));

    Finder emailField = find.byKey(new Key('email'));
    await tester.enterText(emailField, 'abc@gmail.com');

    Finder passField = find.byKey(new Key('pw'));
    await tester.enterText(passField, '111111');

    Finder loginButton = find.byKey(new Key('login_btn'));
    await tester.tap(loginButton);

    await tester.pump();
    expect(mock.didRequestSignIn, true);
  });

  testWidgets('non-empty email and password, non valid account makes fail', (WidgetTester tester) async{
    AuthMock mock = new AuthMock(userId: 'uid');
    LoginPage loginPage = new LoginPage(auth: mock, onSignedIn: _onSignedIn,);
    await tester.pumpWidget(buildTestableWidget(loginPage));

    Finder emailField = find.byKey(new Key('email'));
    await tester.enterText(emailField, 'wrongemail');

    Finder passField = find.byKey(new Key('pw'));
    await tester.enterText(passField, '@@@@@@');

    Finder loginButton = find.byKey(new Key('login_btn'));
    await tester.tap(loginButton);

    await tester.pump();

    expect(mock.didRequestSignIn, false);
  });
}
*/
