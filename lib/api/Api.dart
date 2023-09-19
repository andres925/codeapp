import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Api{
  //final String _dominio = "codea.app";  // produccion
  final String _dominio = "192.168.1.4";   // localhost
  final String _url1    = "/appturismo/public/api/";


  // autenticacion
  autenticacion(_data,String _url2) async {
    var ruta = _url1+_url2 ;
    return await http.post(
        Uri.http(_dominio, ruta),
        body :json.encode(_data),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
        }
    );
  }

  // logout
  logout(String _url2) async {
    var ruta = _url1+_url2 ;
    var parametros = {"token": await getToken() };
    return await http.post(
        Uri.http(_dominio, ruta,parametros),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
        }
    );
  }

  // listar datos
  listarData(String _url2) async {
    var ruta = _url1+_url2 ;
    return await http.get(
      Uri.http(_dominio, ruta),
      headers: {
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
      }
    );
  }

  // insertar un registro
  agregarData(_data, _url2) async {
    var ruta = _url1+_url2 ;
    var parametros = {"token": await getToken() };
    return await http.post(
        Uri.http(_dominio, ruta,parametros),
        body: json.encode(_data),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
        }
    );
  }

  //editar un registro
  editarData(_data, _url2, id) async {
    var ruta = _url1+_url2+"/"+id ;
    var parametros = {"token": await getToken() };
    return await http.put(
        Uri.http(_dominio, ruta,parametros),
        body: json.encode(_data),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
        }
    );
  }

  // borrar un registro
  borrarData(_url2, id) async {
    var ruta = _url1+_url2+"/"+id ;
    var parametros = {"token": await getToken() };
    return await http.delete(
        Uri.http(_dominio, ruta,parametros),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
        }
    );
  }

  // recuperar token
  getToken() async{
    SharedPreferences local = await SharedPreferences.getInstance();
    var token = local.getString("token");
    return token;
  }

  // guardar el token
  saveToken(String value) async{
    SharedPreferences local = await SharedPreferences.getInstance();
    local.setString("token", value);
  }
}