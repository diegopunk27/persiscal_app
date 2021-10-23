import 'package:flutter/material.dart';

class LogoChat extends StatelessWidget {
  final String titulo;

  const LogoChat({@required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 20),
        width: 170,
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage(
                'assets/persiscal.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
