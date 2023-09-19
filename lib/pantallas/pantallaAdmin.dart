import 'dart:convert';
import 'package:app/basededatos/DBmanager.dart';
import 'package:app/pantallas/pantallaAdminAgregar.dart';
import 'package:app/pantallas/pantallaAdminEditar.dart';
import 'package:app/pantallas/pantallaRutas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/api/Api.dart';
import 'package:flutter/material.dart';

var basededatos = new DBmanager();

class pantallaAdmin extends StatefulWidget {
  @override
  _pantallaAdminState createState() => _pantallaAdminState();
}

class _pantallaAdminState extends State<pantallaAdmin> {
  var user_id = 0;
  void _verificarUsuario() async {
    SharedPreferences preferencia = await SharedPreferences.getInstance();
    var user = json.decode(preferencia.getString("user"));
    if (user!=null) {
      setState(() {
        user_id = user['id'];
        print(user_id);
      });
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaRutas()));
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
        title: Text("Administración"),
        actions: [
          IconButton(
              icon: Icon(Icons.input),
              onPressed: () {
                _logout();
              })
        ],
      ),
      backgroundColor: Colors.amber,
      body: Container(
        padding: EdgeInsets.all(10),
        child: Card(
          child: user_id != 0
              ? FutureBuilder(
              future: basededatos
                  .obtenerEmpresas(" user_id=" + user_id.toString()),
              builder: (c, s) {
                if ((s.hasData) && (s.data.length > 0)) {
                  return Padding(padding: EdgeInsets.all(20), child: ListView.builder(
                      itemCount: s.data == null ? 0 : s.data.length,
                      itemBuilder: (_c, _i) {
                        return Row(
                          children: [
                            Text(s.data[_i].razonsocial),
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext) =>
                                        pantallaAdminEditar(s.data[_i])));
                              },
                              child: Text("EDITAR"),
                            ),
                            RaisedButton(
                              onPressed: () {
                                _eliminarEmpresa(s.data[_i].id);
                              },
                              child: Text("ELIMINAR"),
                            )
                          ],
                        );
                      }));
                } else {
                  return Center(child: Text("No tienes empresa"));
                }
              })
              : Center(child: Text("No tienes empresas")),
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext) => pantallaAdminAgregar()));
          },
          label: Text("AGREGAR")),
    );
  }

  void _logout() async {
    var respuesta = await Api().logout("logout");
    var contenido = json.decode(respuesta.body);
    if (contenido['success']) {
      SharedPreferences logout = await SharedPreferences.getInstance();
      logout.remove("token");
      logout.remove("user");
      print("logout");
      //
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaRutas()));
    } else {
      print(contenido['mensaje']);
    }
  }
  void _eliminarEmpresa(id) async{
    var respuesta = await Api().borrarData("empresas",id.toString());
    var contenido = json.decode(respuesta.body);

    if(contenido['success']) {
      print(contenido.toString());

      basededatos.borrarTablaId("empresa", id.toString());

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaAdmin()));
    }

  }
}
