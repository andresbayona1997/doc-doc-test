import 'package:flutter/material.dart';
import 'package:flutter_app/Services/database.dart';
import 'package:flutter_app/helper/constants.dart';
import 'package:flutter_app/views/busqueda.dart';

class ConversationScreen extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  ConversationScreen(this.chatRoomId,this.userName);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessageStream;

  Widget chatMensajeListas(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return MessageTile(snapshot.data.documents[index].data["mensaje"],
                snapshot.data.documents[index].data["enviadoPor"] == Contants.myName);
          },
        ) : Container();
      },
    );
  }

  enviarMensajes(){

    if(messageController.text.isNotEmpty){
      Map<String,String> messageMap={
        "mensaje" : messageController.text,
        "enviadoPor" : Contants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch.toString()
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text="";
    }
  }
  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream=value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Chat con ${widget.userName}",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[

            chatMensajeListas(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                width: double.infinity,
                color: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Digite el mensaje",
                              hintStyle: TextStyle(color: Colors.white),
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        enviarMensajes();
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
                          child: Image.asset("assets/images/send.png")),
                    )

                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 24 , right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [Colors.deepPurpleAccent , Colors.blue] : [Colors.blue, Colors.black],
          ),
          borderRadius: isSendByMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
              ) :
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          )
        ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 15
        )),
      ),
    );
  }
}

