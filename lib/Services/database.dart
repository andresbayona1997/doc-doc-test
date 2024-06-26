import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async{
    return await Firestore.instance.collection("usuarios").where("nombre", isEqualTo: username).getDocuments();
    
  }

  getUserByUserEmail(String userEmail) async{
    return await Firestore.instance.collection("usuarios").where("email", isEqualTo: userEmail).getDocuments();
  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("usuarios").add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance.collection("chatRoom").document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    Firestore.instance.collection("chatRoom").document(chatRoomId).collection("chats").add(messageMap).catchError((e){print(e.toString());});
  }

  getConversationMessages(String chatRoomId) async{
    return await Firestore.instance.collection("chatRoom").document(chatRoomId).collection("chats").orderBy("time").snapshots();
  }

  getChatRooms(String username)async{
    return await Firestore.instance.collection("chatRoom").where("usuarios",arrayContains: username).snapshots();
  }




}