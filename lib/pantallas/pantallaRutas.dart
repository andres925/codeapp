import 'dart:convert';
import 'package:app/api/Api.dart';
import 'package:app/basededatos/DBmanager.dart';
import 'package:app/basededatos/Empresa.dart';
import 'package:app/basededatos/Foto.dart';
import 'package:app/basededatos/Lugar.dart';
import 'package:app/basededatos/Ruta.dart';
import 'package:app/pantallas/pantallaEmpresas.dart';
import 'package:app/pantallas/pantallaLogin.dart';
import 'package:app/pantallas/pantallaLugares.dart';
import 'package:flutter/material.dart';

var basededatos = new DBmanager();
class pantallaRutas extends StatefulWidget {
  @override
  _pantallaRutasState createState() => _pantallaRutasState();
}

class _pantallaRutasState extends State<pantallaRutas> {
  bool descargacompleta = false;
  void obtenerJson() async {
    var respuesta = await Api().listarData("listajson");
    var body = json.decode(respuesta.body);
    if (body['success']) {
      // ruta
      basededatos.borrarTabla("ruta");
      for (var registro in body['listarutas']) {
        Ruta ruta =
            Ruta(registro['id'], registro['nombre'], registro['urlfoto']);
        basededatos.insertarRuta(ruta);
      }
      // empresa
      basededatos.borrarTabla("empresa");
      for (var Data in body['listaempresas']) {
        Empresa empresa = Empresa(
            Data['id'],
            Data['razonsocial'],
            Data['descripcion'],
            Data['urllogo'],
            Data['ruta_id'],
            Data['user_id']);
        basededatos.insertarEmpresa(empresa);
        print("empresa" + empresa.toString());
      }
      // tabla lugar
      basededatos.borrarTabla("lugar");
      for (var Data in body['listalugares']) {
        Lugar lugar = Lugar(
            Data['id'],
            Data['nombre'],
            Data['descripcion'],
            Data['urlfoto'],
            Data['latitud'],
            Data['longitud'],
            Data['ruta_id']);
        basededatos.insertarLugar(lugar);
      }

      // tabla foto
      basededatos.borrarTabla("foto");
      for (var Data in body['listafotos']) {
        Foto foto =
            Foto(Data['id'], Data['nombre'], Data['urlfoto'], Data['tipo'],Data['lugar_id']);
        basededatos.insertarFoto(foto);
      }

      setState(() {
        descargacompleta = true;
      });
    } else {
      print("FALLO");
    }
  }

  @override
  void initState() {
    obtenerJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RUTAS"),
      ),
      backgroundColor: Colors.amber,
      body: Container(
        child: descargacompleta
            ? FutureBuilder(
                future: basededatos.obtenerRutas("1"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // listview
                    return ListView.builder(
                        itemCount:
                            snapshot.data == null ? 0 : snapshot.data.length,
                        itemBuilder: (_c, _i) {
                          return Card(
                            elevation: 20,
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(
                                  "http://192.168.1.4/appturismo/public/img/ruta/" +
                                      snapshot.data[_i].urlfoto, width: 155, height: 100, fit: BoxFit.cover ,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        snapshot.data[_i].nombre,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18,
                                            color: Colors.green),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        RaisedButton(
                                            child: Text("Empresas"),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext) =>
                                                          pantallaEmpresas(
                                                              snapshot.data[_i])));
                                            }),
                                        RaisedButton(
                                            child: Text("Lugares"),
                                            onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=> pantallaLugares(snapshot.data[_i]) ));
                                            })
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  } else {
                    return Center(child: Text("NO EXISTE INFO"));
                  }
                })
            : Center(
                child: Text("Cargando info"),
              ),
      ),
      drawer: menuLateral(),
    );
  }
}

class menuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("LOGIN"),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=> pantallaLogin()));
              },
            )
          ],
        ),
      ),
    );
  }
}

