import 'package:flutter/material.dart';
//import 'package:jiktok/module/contacts/jiktokMain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  AppDrawerState createState() {
    return AppDrawerState();
  }
}

class AppDrawerState extends State<AppDrawer> {
  String _myEmail = '';
  String _loginOrLogOut = '로그인';

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print(prefs.getString('email'));
    if (prefs.getString('email') == null) {
      _myEmail = '';
      _loginOrLogOut = '로그인';
    } else {
      setState(() {
        _myEmail = prefs.getString('email');
        _loginOrLogOut = '로그아웃';
      });
    }
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print(prefs.getString('email'));
    //prefs.getString('email') =null;
    prefs.setString('email', null);
    setState(() {
      _myEmail = '';
      _loginOrLogOut = '로그인';
    });

    //final snackBar = SnackBar(content: Text('로그아웃 되었습니다. 감사합니다.'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('로그아웃 되었습니다. 감사합니다.')));
  }

  int cnt = 0;
  @override
  void initState() {
    print("open");
    super.initState();
    setState(() {
      _getUser();

      ///myEmail = prefs.getString('email');
      // myEmail = myEmail + "111a";
    });
  }

  @override
  void dispose() {
    print("close");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Color(0xfff65b87),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: new Color(0xfff65b87),
            ),
            accountName: Text(_myEmail),
            accountEmail: Text("#Traval#Trade#Couppon#Event"),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  'assets/jiktok/logo-pk.png',
                )),
          ),
          UserAccountsDrawerHeader(
            accountName: Text('생활의 지혜'),
            accountEmail: Text('강서/마곡 톡톡 할인'),
            currentAccountPicture: Image.asset(
              'assets/jiktok/logo.png',
              width: 300,
              // height: 150,
              fit: BoxFit.contain,
            ),
            decoration: BoxDecoration(color: Color(0xfff65b87)),
          ),
        ],
      ),

/*
        BoxDecoration(
        
            image: DecorationImage(
                fit: BoxFit.fill,
                image:
                    AssetImage('assets/jiktok/drawer_header_background.png'))),
  */
/*
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Flutter Step-by-Step",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ])
        
        */
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
