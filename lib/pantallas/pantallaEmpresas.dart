import 'package:app/basededatos/DBmanager.dart';
import 'package:app/basededatos/Ruta.dart';
import 'package:app/pantallas/pantallaEmpresa.dart';
import 'package:flutter/material.dart';

var basededatos = new DBmanager();

class pantallaEmpresas extends StatefulWidget {
  Ruta ruta;
  pantallaEmpresas(this.ruta);
  @override
  _pantallaEmpresasState createState() => _pantallaEmpresasState(this.ruta);
}

class _pantallaEmpresasState extends State<pantallaEmpresas> {
  Ruta ruta;

  _pantallaEmpresasState(this.ruta);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EMPRESAS "+ruta.nombre),
      ),
      backgroundColor: Colors.amber,
      body: Container(
        child: FutureBuilder(
          future: basededatos.obtenerEmpresas("ruta_id=" + ruta.id.toString()),
          builder: (BuildContext c, AsyncSnapshot s) {
            if (s.hasData) {
              return ListView.builder(
                  itemCount: s.data == null ? 0 : s.data.length,
                  itemBuilder: (_c, _i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext) =>
                                pantallaEmpresa(s.data[_i])));
                      },
                      child: Card(
                        elevation: 10,
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              "http://192.168.1.4/appturismo/public/img/empresa/" +
                                  s.data[_i].urllogo,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            Padding(padding: EdgeInsets.all(10), child: Text(
                              s.data[_i].razonsocial,
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
