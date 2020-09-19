import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/helper/helperFunctions.dart';
import 'package:flutter_app/modal/user.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user){
    return user !=null ? User(userId: user.uid): null;
  }

  Future entrarConCorreoYContrasena(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebase(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }


  Future crearCuentaConCorreoYContrasena(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebase(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }





  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future salirCuenta() async{
    try{
      HelperFunctions.saveUserLoggedInSharedPreferences(false);
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }


}