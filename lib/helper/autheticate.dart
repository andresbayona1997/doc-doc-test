import 'package:flutter/material.dart';
import 'package:flutter_app/views/entrar.dart';
import 'package:flutter_app/views/validarEntrar.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool mostrarLog = true;


  void toggleView(){
    setState(() {
      mostrarLog = !mostrarLog;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(mostrarLog) {

      return HomePage(toggleView);
    }else{
      return ValidarEntrar(toggleView);
    }
  }
}
