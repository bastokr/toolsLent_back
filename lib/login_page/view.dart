import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'action.dart';
import 'state.dart';
import 'package:escroomtok/widgets/loading.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
SharedPreferences prefs;
FirebaseUser currentUser;
bool isLoading = false;
bool isLoggedIn = false;

@override
Widget buildView(LoginState state, Dispatch dispatch, ViewService viewService) {
  return Builder(builder: (context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Login Page",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Align(
            alignment: Alignment.center,
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
                      child: Column(children: <Widget>[
                        Image.asset(
                          'assets/icon/launcher_icon.png',
                          fit: BoxFit.cover,
                          height: 100.0,
                        ),
                      ])),
                  Container(
                      alignment: Alignment.center,
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Column(children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: SignInButton(
                            Buttons.GoogleDark,
                            //color: Colors.indigo[300],
                            text: "Google 계정 로그인",
                            onPressed: () => dispatch(
                                LoginActionCreator.handleSignInAction()),
                          ),
                        ),
                        Positioned(
                          child:
                              state.isLoading ? const Loading() : Container(),
                        )
                      ])),
                  Container(
                      alignment: Alignment.center,
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 0),
                      child: InkWell(
                          // onTap: () => _isKakaoTalkInstalled ? _loginWithTalk : _loginWithKakao,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Colors.yellow),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chat_bubble,
                                      color: Colors.black54),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '카카오계정 로그인',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15),
                                  ),
                                ],
                              ))))
                ])));
  });
}
