import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String sharedPreferencesUserLoggedKey = "ISLOGGEDIN";
  static String sharedPreferencesUserNameKey = "USERNAMEKEY";
  static String sharedPreferencesUserEmailKey= "USEREMAIL";
  static String sharedPreferencesUserAgeKey = "USERAGE";

  // saving data to sharedPreferences

  static Future<void> saveUserLoggedInSharedPreferences (bool isUserLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferencesUserLoggedKey, isUserLoggedIn);
  }

  static Future<void> saveUserNameSharedPreferences (String userName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserNameKey, userName);
  }

  static Future<void> saveUserEmailSharedPreferences (String userEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserEmailKey, userEmail);
  }

  static Future<void> saveUserAgeSharedPreferences (String age) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserAgeKey, age);
  }



  //Getting data from SharedPreferences

  static Future<bool> GetUserLoggedInSharedPreferences () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferencesUserLoggedKey);
  }
  static Future<String> GetUserNameSharedPreferences () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferencesUserNameKey);
  }
  static Future<String> GetUserEmailSharedPreferences () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferencesUserEmailKey);
  }
  static Future<String> GetUserAgeSharedPreferences () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferencesUserAgeKey);
  }



  //Funciones conexión con mysql


}