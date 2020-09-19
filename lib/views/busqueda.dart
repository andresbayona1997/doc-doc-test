import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Services/database.dart';
import 'package:flutter_app/helper/constants.dart';
import 'package:flutter_app/helper/helperFunctions.dart';
import 'package:flutter_app/views/pantallaChat.dart';
import 'package:flutter_app/views/perfil.dart';
import 'package:flutter_app/views/salaChat.dart';

class Busqueda extends StatefulWidget {
  @override
  _BusquedaState createState() => _BusquedaState();
}
String _myName;

class _BusquedaState extends State<Busqueda> {


  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController busquedaControladaControlador= new TextEditingController();


  QuerySnapshot searchSnapshot;

  initiateSearch(){
    databaseMethods.getUserByUsername(busquedaControladaControlador.text).then((val){
      setState(() {
        searchSnapshot=val;
      });
    });
  }

//Crear chatroom y enviar al usuario a la sala de chat
  crearSalaChatYIniciarConversacion({String username}){

    if(username != Contants.myName){
      String chatRoomId = getChatRoomId(username , Contants.myName);

      List<String> users = [username, Contants.myName];
      Map<String,dynamic> chatRoomMap = {
        "usuarios": users,
        "chatRoomId": chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatRoomId,
            username
          )
      ));
    }else{
      print("No puedes enviarte mensajes a ti mismo");
    }
  }

  int _currentIndex=2;

  Widget SearchTile({String userName, String userEmail, String userEdad}){
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Usuario: " +userName),
              Text("Correo: "+userEmail),
              Text("Edad: "+userEdad)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              crearSalaChatYIniciarConversacion(username : userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(40)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Chatear"),
            ),
          )
        ],
      ),
    );
  }

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return SearchTile(
            userName: searchSnapshot.documents[index].data["nombre"],
            userEmail : searchSnapshot.documents[index].data["email"],
              userEdad : searchSnapshot.documents[index].data["edad"]
          );
        }) : Container();
  }



  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Busca con quien hablar",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      ),
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
              case 1:
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => perfilVer()
                ));
                break;
            }
          });
        },
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.deepPurpleAccent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: busquedaControladaControlador,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ingrese el nombre del usuario",
                            hintStyle: TextStyle(color: Colors.black)
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.blue
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/search_white.png")),
                  )

                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}


getChatRoomId(String a, String b){
  if(a.substring(0,1).codeUnitAt(0)> b.substring(0,1).codeUnitAt(0)) {
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}
