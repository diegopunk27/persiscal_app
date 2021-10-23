import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proypersical/app/ui/pages/home_page.dart';
import 'package:proypersical/app/ui/pages/login_page.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();

    if (firebaseuser != null) {
      return HomePage();
    }
    return LoginPage();
  }

  Future loading(BuildContext context) async {
    final firebaseuser = context.watch<User>();
    if (firebaseuser != null) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => HomePage(),
      ));
    } else {
      Navigator.of(context).pushReplacementNamed("login");
    }
  }
}
