import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Services/auth.dart';
import 'package:flutter_app/Services/database.dart';
import 'package:flutter_app/helper/autheticate.dart';
import 'package:flutter_app/helper/constants.dart';
import 'package:flutter_app/helper/helperFunctions.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/views/busqueda.dart';
import 'package:flutter_app/views/entrar.dart';
import 'package:flutter_app/views/pantallaChat.dart';
import 'package:flutter_app/views/perfil.dart';

class salaChat extends StatefulWidget {
  @override
  _salaChatState createState() => _salaChatState();
}

class _salaChatState extends State<salaChat> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  salir(){
    authMethods.salirCuenta();
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => salaChat()
    ));
  }

  Stream chatRoomsStream;

  Widget chatRoomsList(){

    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(

          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return ChatRoomTile(snapshot.data.documents[index].data["chatRoomId"]
                .toString().replaceAll("_", "").
            replaceAll(Contants.myName, ""),
                snapshot.data.documents[index].data["chatRoomId"]
            );
          },
        ) : Container();
      },
    );
  }
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }


  getUserInfo() async{
    Contants.myName = await HelperFunctions.GetUserNameSharedPreferences();
    Contants.myEmail= await HelperFunctions.GetUserEmailSharedPreferences();
    Contants.myAge = await HelperFunctions.GetUserAgeSharedPreferences();
    databaseMethods.getChatRooms(Contants.myName).then((value){
      setState(() {
        chatRoomsStream = value;

      });
    });
    setState(() {

    });
  }

  int _currentIndex=0;

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
              case 1:
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => perfilVer()
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
        title: Text("Chats",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
      body: chatRoomsList() ,

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.search),
      //   onPressed: (){
      //     Navigator.push(context, MaterialPageRoute(
      //       builder: (context) => Busqueda()
      //     ));
      //   },
      // ),
    );

  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;

  final String chatRoom;

  ChatRoomTile(this.userName, this.chatRoom);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoom, userName)
        ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text("${userName.substring(0,1).toUpperCase()}"),
              maxRadius: 30,
              backgroundColor: Colors.deepPurpleAccent,
            ),
            SizedBox(width: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(userName, style: TextStyle(fontSize: 16, color: Colors.grey.shade600),),
                SizedBox(height: 6,)
              ],
            ),

          ],
        ),
      ),


    );
  }
}




