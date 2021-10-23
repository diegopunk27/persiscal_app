import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostrarDialogo(BuildContext context, String titulo, String subtitulo) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ok"),
            elevation: 5,
            color: Colors.blue,
          ),
        ],
      );
    },
  );
}

mostrarDialogoWithRoute(
    BuildContext context, String titulo, String subtitulo, String route) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, route, (Route<dynamic> route) => false),
            child: Text("Ok"),
            elevation: 5,
            color: Colors.blue,
          ),
        ],
      );
    },
  );
}
