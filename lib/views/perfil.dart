import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Animation/FadeAnimation.dart';
import 'package:flutter_app/Services/auth.dart';
import 'package:flutter_app/helper/autheticate.dart';
import 'package:flutter_app/helper/constants.dart';
import 'package:flutter_app/helper/helperFunctions.dart';
import 'package:flutter_app/views/busqueda.dart';
import 'package:flutter_app/views/salaChat.dart';

class perfilVer extends StatefulWidget {

  @override
  _perfilVerState createState() => _perfilVerState();
}

class _perfilVerState extends State<perfilVer> {

  int _currentIndex=1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: TextStyle(fontWeight:  FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontWeight:  FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.message),
                title: Text("Chats")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text("Perfil")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text("Buscar")
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              switch (_currentIndex) {
                case 0:
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => salaChat()
                  ));
                  break;
                case 2:
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => Busqueda()
                  ));
                  break;
              }
            });
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text("Perfil de ${Contants.myName}",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          actions: [
            GestureDetector(
              onTap: (){
                AuthMethods().salirCuenta();
                HelperFunctions.saveUserLoggedInSharedPreferences(false);
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Authenticate()
                ));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Icon(Icons.exit_to_app)),
            )
          ],
        ),
      body:Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 450,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                  ],
                ),
              )
            ],
          ),
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding:EdgeInsets.all(20),
              child : Text("Perfil", style: TextStyle(fontSize: 35, letterSpacing: 1.5, color: Colors.white, fontWeight: FontWeight.w600),),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width/2,
                height: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                      image :AssetImage('assets/images/perfil.jpg')
                  )
                ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: FadeAnimation(2,Container(
                      margin: EdgeInsets.only(top:50),
                      child: Center(
                        child: Text("Soy ${Contants.myName}", style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                    )),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 50.0),
                    child: FadeAnimation(2.3,Container(
                      margin: EdgeInsets.only(top:50),
                      child: Center(
                        child: Text("Email: ${Contants.myEmail}", style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                    )),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 100.0),
                    child: FadeAnimation(2.5,Container(
                      margin: EdgeInsets.only(top:50),
                      child: Center(
                        child: Text("Tengo ${Contants.myAge} años", style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                    )),
                  )
                ],
              )
            ],
          ),
        ],
      )
    );
  }
}

class HeaderCurvedContainer extends CustomPainter{
  @override
  void paint(Canvas canvas , Size size){
    Paint paint = Paint()..color=Colors.deepPurpleAccent;
    Path path= Path()..relativeLineTo(0, 150)..quadraticBezierTo(size.width/2, 225, size.width, 150)..relativeLineTo(0, -150)..close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate)=>false;
}
