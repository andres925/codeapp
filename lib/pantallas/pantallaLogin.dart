import 'dart:convert';
import 'package:app/pantallas/pantallaAdmin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/api/Api.dart';
import 'package:flutter/material.dart';
class pantallaLogin extends StatefulWidget {
  @override
  _pantallaLoginState createState() => _pantallaLoginState();
}

class _pantallaLoginState extends State<pantallaLogin> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  void _verificarUsuario() async {
    SharedPreferences preferencia = await SharedPreferences.getInstance();
    var user = json.decode(preferencia.getString("user"));
    if (user!=null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaAdmin()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _verificarUsuario();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LOGIN"),
        ),
        backgroundColor: Colors.amber,
        body: Container(
          padding: EdgeInsets.all(20),
          child:Card(
            elevation: 20,
            child:  Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: _email,
                      decoration: InputDecoration(hintText: "Correo :")),
                  TextField(
                    controller: _password,
                    decoration: InputDecoration(hintText: "Password :"),
                    obscureText: true,
                  ),
                  FlatButton(
                    onPressed: (_login),
                    child: Text("LOGIN", style: TextStyle(color: Colors.white),),
                    color: Colors.amber,
                  )
                ],
              ),
            ),
          ),
        ));
  }
  void _login() async {
    // validacion
    var datos = {
      'email': _email.text,
      'password': _password.text
    };

    var respuesta = await Api().autenticacion(datos, "login");
    var contenido = json.decode(respuesta.body);
    if (contenido['success']) {
      SharedPreferences login = await SharedPreferences.getInstance();
      login.setString("token", contenido['token']);
      login.setString("user", json.encode(contenido['user']));

      print(contenido['token']);
      //
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext)=>pantallaAdmin()));

    } else {
      print(contenido['mensaje']);
    }
  }
}
