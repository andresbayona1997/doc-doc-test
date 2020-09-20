import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Animation/FadeAnimation.dart';
import 'package:flutter_app/Services/auth.dart';
import 'package:flutter_app/Services/database.dart';
import 'package:flutter_app/helper/helperFunctions.dart';
import 'package:flutter_app/views/entrar.dart';
import 'package:flutter_app/views/salaChat.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ValidarEntrar extends StatefulWidget{

  final Function toggle;
  ValidarEntrar(this.toggle);
  @override
  _ValidarEntrarState createState() => _ValidarEntrarState();
}

class _ValidarEntrarState extends State<ValidarEntrar>{


  bool processing = false;
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController ageTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();



  void registerUser() async{

    setState(() {
      processing = true;
    });
    var url = "https://doc-doc-test.000webhostapp.com/login_flutter/signup.php";
    var data = {
      "email":emailTextEditingController.text,
      "name":userNameTextEditingController.text,
      "pass":passwordTextEditingController.text,
      "age":ageTextEditingController.text,
    };

    var res = await http.post(url, body: data);

      if(jsonDecode(res.body) == "true"){
        Fluttertoast.showToast(msg: "account created",toastLength: Toast.LENGTH_SHORT);
      }else{
        Fluttertoast.showToast(msg: "error",toastLength: Toast.LENGTH_SHORT);
      }
    setState(() {
      processing = false;
    });
  }


  signMeUP(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      authMethods.crearCuentaConCorreoYContrasena(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        //print("${val.uid}");
        Map <String, String> userInfoMap = {
          "nombre" : userNameTextEditingController.text,
          "email" : emailTextEditingController.text,
          "edad" : ageTextEditingController.text
        };

        HelperFunctions.saveUserNameSharedPreferences(userNameTextEditingController.text);
        HelperFunctions.saveUserEmailSharedPreferences(emailTextEditingController.text);
        HelperFunctions.saveUserAgeSharedPreferences(ageTextEditingController.text);



        databaseMethods.uploadUserInfo(userInfoMap);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => salaChat()
        ));
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator(),),
      ) : Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fill
                  )
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: FadeAnimation(2,Container(
                      margin: EdgeInsets.only(top:50),
                      child: Center(
                        child: Text("Crear Cuenta", style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.bold),),
                      ),
                    )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, 2),
                              blurRadius: 20.0,
                              offset: Offset(0,10)
                          )
                        ]

                    ),
                    child: Column(
                      children:  [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(bottom:  BorderSide(color: Colors.grey[100]))
                                ),
                                child: TextFormField(
                                  validator: (val){
                                    return val.isEmpty || val.length < 2 ? "Ingresa un usuario valido":null;
                                    },
                                  controller: userNameTextEditingController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Nombre de Usuario",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(bottom:  BorderSide(color: Colors.grey[100]))
                                ),
                                child: TextFormField(
                                  validator: (val){
                                    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$").hasMatch(val) ? null : "Ingrese una cuenta de correo valida";
                                  },
                                  controller: emailTextEditingController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Correo Electronico",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(bottom:  BorderSide(color: Colors.grey[100]))
                                ),
                                child: TextFormField(
                                  validator: (val){
                                    return val.isEmpty  ? "Ingresa una edad valida":null;
                                  },
                                  controller: ageTextEditingController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Edad",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  obscureText: true,
                                  validator: (val){
                                    return val.length>6 ? null :"Ingresa una contraseña de min 7 valores";
                                  },
                                  controller: passwordTextEditingController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Contraseña",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                ),
                              )
                            ],
                          ),
                    ),
                            ],
                          ),
                        ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                       //TODO
                      signMeUP();
                    },
                    child: Container(

                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, 6),
                              ]
                            //
                          )
                      ),
                      child: Center(
                        child: Text("Crear Cuenta",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      registerUser();
                    },
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, 6),
                              ]
                            //
                          )
                      ),
                      child: Center(
                        child: Text("Entrar con google",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                      height: 40,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Tengo una cuenta",style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1),fontWeight: FontWeight.bold),)),
                  )
                ],
              ),
            )
          ],
        ),

      ),
    );

  }
  
}