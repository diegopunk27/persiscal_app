import 'package:flutter/material.dart';
import 'package:proypersical/app/ui/pages/home_page.dart';

import 'package:proypersical/app/ui/pages/loading_page.dart';
import 'package:proypersical/app/ui/pages/login_page.dart';
import 'package:proypersical/app/ui/pages/register_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'home': (_) => HomePage(),
  'login': (_) => LoginPage(),
  'loading': (_) => LoadingPage(),
  'register': (_) => RegisterPage(),
};

/*'usuarios': (_) => UsuariosPage(),
  'chat': (_) => ChatPage(),
  'register': (_) => RegisterPage(),*/
