import 'dart:convert';
import 'package:app/pantallas/pantallaAdmin.dart';
import 'package:app/pantallas/pantallaRutas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/api/Api.dart';
import 'package:flutter/material.dart';

class pantallaRegistro extends StatefulWidget {
  @override
  _pantallaRegistroState createState() => _pantallaRegistroState();
}

class _pantallaRegistroState extends State<pantallaRegistro> {
  TextEditingController _nombre = TextEditingController();
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
          title: Text("REGISTRO"),
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
                    controller: _nombre,
                    decoration: InputDecoration(hintText: "Nombre :"),
                  ),
                  TextField(
                      controller: _email,
                      decoration: InputDecoration(hintText: "Correo :")),
                  TextField(
                    controller: _password,
                    decoration: InputDecoration(hintText: "Password :"),
                    obscureText: true,
                  ),
                  FlatButton(
                    onPressed: (_registro),
                    child: Text("REGISTRO", style: TextStyle(color: Colors.white),),
                    color: Colors.amber,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _registro() async {
    // validacion
    var datos = {
      'name': _nombre.text,
      'email': _email.text,
      'password': _password.text
    };

    var respuesta = await Api().autenticacion(datos, "registro");
    var contenido = json.decode(respuesta.body);
    if (contenido['success']) {
      SharedPreferences registro = await SharedPreferences.getInstance();
      registro.setString("token", contenido['token']);
      registro.setString("user", json.encode(contenido['user']));

      print(contenido['token']);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext)=>pantallaAdmin()));

    } else {
      print(contenido['mensaje']);
    }
  }
}
