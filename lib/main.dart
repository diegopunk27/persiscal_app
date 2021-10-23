import 'package:flutter/material.dart';
import 'package:proypersical/app/routes/routes.dart';

import 'package:proypersical/app/service/authentication_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:proypersical/app/service/product_service.dart';
import 'package:proypersical/app/ui/pages/loading_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await FirebaseApp.initializeApp();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
        ChangeNotifierProvider<ProductService>(create: (_) => ProductService()),
      ],
      child: MaterialApp(
        title: 'Persiscal',
        debugShowCheckedModeBanner: false,
        initialRoute: 'loading',
        routes: appRoutes,
        home: Scaffold(
          appBar: AppBar(
            title: Text('PersiscalApp'),
          ),
          body: Center(
            child: Container(
              child: Text('Hello World'),
            ),
          ),
        ),
      ),
    );
  }
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        title: 'Persiscal',
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.LOGIN,
        //routes: appRoutes,
        home: AuthLayer(),
      ),
    );
  }
}*/
