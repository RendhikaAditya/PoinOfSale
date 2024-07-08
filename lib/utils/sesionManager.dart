import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{
  bool? value;
  String? id;
  String? username;
  String? role;
  String? idBranch;

  //simpan sesi
  Future<void> saveSession(bool val, String id, String username, String role, String idBranch) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("sukses", val);
    pref.setString("id", id);
    pref.setString("username", username);
    pref.setString("role", role);
    pref.setString("idBranch", idBranch);

  }

  Future getSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    value = pref.getBool("sukses");
    id = pref.getString("id");
    username = pref.getString("username");
    role = pref.getString("role");
    idBranch = pref.getString("idBranch");

  }
  //remove --> logout
  Future clearSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

}

//instance class biar d panggil
SessionManager sessionManager = SessionManager();