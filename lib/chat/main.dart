import 'package:flutter/material.dart';

import 'const.dart';
import 'login.dart';

void chatApp() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: ThemeData(
        primaryColor: themeColor,
      ),
      home: LoginScreen(title: '방탈출톡'),
      debugShowCheckedModeBanner: false,
    );
  }
}
