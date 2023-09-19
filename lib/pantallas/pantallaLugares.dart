import 'package:app/basededatos/DBmanager.dart';
import 'package:app/basededatos/Ruta.dart';

import 'package:app/pantallas/pantallaLugar.dart';
import 'package:flutter/material.dart';

var basededatos = new DBmanager();

class pantallaLugares extends StatefulWidget {
  Ruta ruta;
  pantallaLugares(this.ruta);
  @override
  _pantallaLugaresState createState() => _pantallaLugaresState(this.ruta);
}

class _pantallaLugaresState extends State<pantallaLugares> {
  Ruta ruta;
  _pantallaLugaresState(this.ruta);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("LUGARES "+ruta.nombre),
      ),
      backgroundColor: Colors.amber,
      body: Container(
        child: FutureBuilder(
          future: basededatos.obtenerLugares("ruta_id=" + ruta.id.toString()),
          builder: (BuildContext c, AsyncSnapshot s) {
            if (s.hasData) {
              return ListView.builder(
                  itemCount: s.data == null ? 0 : s.data.length,
                  itemBuilder: (_c, _i) {
                    return GestureDetector(
                      onTap: () {

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext) =>
                                pantallaLugar(s.data[_i])));

                      },
                      child: Card(
                        elevation: 10,
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              "http://192.168.1.4/appturismo/public/img/lugar/" +
                                  s.data[_i].urlfoto,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                           Padding(padding: EdgeInsets.all(10),child:  Text(
                             s.data[_i].nombre,
                             style: TextStyle(
                               fontSize: 20,
                               fontWeight: FontWeight.w700,
                               color: Colors.green,
                             ),
                           ),)
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Text("NO EXISTEN EMPRESAS"),
              );
            }
          },
        ),
      ),
    );
  }
}
