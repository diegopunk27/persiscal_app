import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proypersical/app/helpers/alert_dialog.dart';
import 'package:proypersical/app/service/authentication_service.dart';
import 'package:proypersical/app/widgets/blue_boton.dart';
import 'package:proypersical/app/widgets/custom_input.dart';
import 'package:proypersical/app/widgets/labels.dart';
import 'package:proypersical/app/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2F2),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              LogoChat(
                titulo: 'Registro',
              ),
              _FormLogin(),
              Labels(
                ruta: 'login',
                upText: '¿Ya tienes una cuenta?',
                downText: 'Ingresa desde aquí',
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("Powered By DieYan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<_FormLogin> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool noPress = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.email,
            text: 'Email',
            inputType: TextInputType.emailAddress,
            textEditingController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            text: 'Contraseña',
            inputType: TextInputType.visiblePassword,
            textEditingController: passCtrl,
            isPassword: true,
          ),
          BlueBoton(
            text: "Registrar",
            onPress: noPress
                ? () async {
                    setState(() {
                      noPress = false;
                    });
                    dynamic registerOk =
                        await context.read<AuthenticationService>().signUp(
                              email: emailCtrl.text.trim(),
                              password: passCtrl.text.trim(),
                            );

                    if (registerOk == 'ok') {
                      Navigator.of(context).pushReplacementNamed("home");
                    } else {
                      setState(() {
                        noPress = true;
                      });
                      mostrarDialogo(context, "Error de registro", registerOk);
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
