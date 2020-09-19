import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Pipem/AndroidStudioProjects/flutter_app/lib/Animation/FadeAnimation.dart';
import 'package:flutter_app/Services/auth.dart';
import 'package:flutter_app/Services/database.dart';
import 'package:flutter_app/helper/helperFunctions.dart';
import 'package:flutter_app/views/salaChat.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget{

  final Function toggle;
  HomePage(this.toggle);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshotUserInfo;

  GoogleSignIn googleSignIn= GoogleSignIn(scopes: ["email"]);

  logInGoogle()async{
    try{
      await googleSignIn.signIn();
      HelperFunctions.saveUserLoggedInSharedPreferences(true);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => salaChat()
      ));
      setState(() {
        isLoading=true;
      });
    }catch(err){
      print(err);
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();


  loguear(){
    if(formKey.currentState.validate()){
      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo=val;
        HelperFunctions.saveUserNameSharedPreferences(snapshotUserInfo.documents[0].data["nombre"]);
      });
      setState(() {
        isLoading = true;
      });


      authMethods.entrarConCorreoYContrasena(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        //print("${val.uid}");
        if(val != null){

          HelperFunctions.saveUserLoggedInSharedPreferences(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => salaChat()
          ));
        }

      });

    }
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator(),),
    ) : Container(
      child: Column(
      children: <Widget>[
            Container(
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fill
                  )
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeAnimation(1.5,Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/light-1.png')
                          )
                      ),
                    )),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeAnimation(1.8, Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/light-1.png')
                          )
                      ),
                    )),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 200,
                    child: FadeAnimation(2,Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/clock.png')
                          )
                      ),
                    )),
                  ),
                  Positioned(
                    child: FadeAnimation(2,Container(
                      margin: EdgeInsets.only(top:50),
                      child: Center(
                        child: Text("Entrar", style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.bold),),
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
                      children: <Widget>[
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
                                    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$").hasMatch(val) ? null : "Ingrese una cuenta de correo valida";
                                  },
                                  controller: emailTextEditingController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Correo de la cuenta",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (val){
                                    return val.length>6 ? null :"Ingresa una contraseña de min 7 valores";
                                  },
                                  controller: passwordTextEditingController,
                                  obscureText: true,
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
                  SizedBox(height: 40,),
                  GestureDetector(
                    onTap: (){
                      loguear();
                    },
                    child: Container(
                      height: 50,
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
                        child: Text("Entrar",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      logInGoogle();
                    },
                    child: Container(
                      height: 50,
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
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("¿No tienes cuenta? Crea una ahora",style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1),fontWeight: FontWeight.bold),)),
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