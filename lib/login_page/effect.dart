import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action, Page;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:escroomtok/globalbasestate/store.dart';
import 'package:escroomtok/home.dart';
import 'package:escroomtok/login_page/view.dart';
import 'package:escroomtok/views/setting_page/action.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'action.dart';
import 'state.dart';
import 'package:firebase_auth/firebase_auth.dart';

Effect<LoginState> buildEffect() {
  return combineEffects(<Object, Effect<LoginState>>{
    Lifecycle.initState: _onInit,
    LoginAction.action: _onAction,
    LoginAction.handleSignIn: _handleSignIn,
    LoginAction.onHomeScreen: _onHomeScreen
  });
}

Future _onInit(Action action, Context<LoginState> ctx) async {
  // ctx.dispatch(LoginActionCreator.onLodingAction());
  ctx.dispatch(SettingPageActionCreator.onUploading(true));
  prefs = await SharedPreferences.getInstance();

  isLoggedIn = await googleSignIn.isSignedIn();
  if (isLoggedIn) {
    Navigator.push(
      ctx.context,
      MaterialPageRoute(
          builder: (context) =>
              HomeScreen(currentUserId: prefs.getString('id'))),
    );
  }

  //ctx.dispatch(LoginActionCreator.onLodingAction());
  ctx.dispatch(SettingPageActionCreator.onUploading(false));
}

SharedPreferences prefs;
final FirebaseAuth _auth = FirebaseAuth.instance;
void _onAction(Action action, Context<LoginState> ctx) async {}

void _handleSignIn(Action action, Context<LoginState> ctx) {
  handleSignIn();
}

void _onHomeScreen(Action action, Context<LoginState> ctx) {
  final _user = GlobalStore.store.getState().user;

  Navigator.push(
      ctx.context,
      MaterialPageRoute(
          builder: (context) =>
              HomeScreen(currentUserId: _user.firebaseUser.uid)));

  /*    
  Navigator.of(ctx.context)
      .pushNamed('todo_edit', arguments: null)
      .then((dynamic toDo) {
    if (toDo != null &&
        (toDo.title?.isNotEmpty == true || toDo.desc?.isNotEmpty == true)) {
      ctx.dispatch(list_action.ToDoListActionCreator.add(toDo));
    }
  });
  */
}

Future<Null> handleSignIn() async {
  final _user = GlobalStore.store.getState().user;

  LoginActionCreator.onLodingAction();

  GoogleSignInAccount googleUser = await googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  FirebaseUser firebaseUser =
      (await firebaseAuth.signInWithCredential(credential)).user;

  if (firebaseUser != null) {
    // Check is already sign up
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: firebaseUser.uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      // Update data to server if new user
      Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .setData({
        'nickname': firebaseUser.displayName,
        'photoUrl': firebaseUser.photoUrl,
        'id': _user.firebaseUser.uid,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null
      });

      // Write data to local
      currentUser = firebaseUser;
      await prefs.setString('id', currentUser.uid);
      await prefs.setString('nickname', currentUser.displayName);
      await prefs.setString('photoUrl', currentUser.photoUrl);
    } else {
      // Write data to local
      await prefs.setString('id', documents[0]['id']);
      await prefs.setString('nickname', documents[0]['nickname']);
      await prefs.setString('photoUrl', documents[0]['photoUrl']);
      await prefs.setString('aboutMe', documents[0]['aboutMe']);
    }
    Fluttertoast.showToast(msg: "Sign in success");
    LoginActionCreator.onHomeScreen();
  } else {
    Fluttertoast.showToast(msg: "Sign in fail");
    LoginActionCreator.onLodingAction();
  }
}
