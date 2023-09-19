import 'package:app/basededatos/DBmanager.dart';
import 'package:app/basededatos/Lugar.dart';
import 'package:app/pantallas/PantallaFoto.dart';
import 'package:flutter/material.dart';

var basededatos = new DBmanager();
class pantallaLugar extends StatefulWidget {
  Lugar lugar;
  pantallaLugar(this.lugar);
  @override
  _pantallaLugarState createState() => _pantallaLugarState(this.lugar);
}

class _pantallaLugarState extends State<pantallaLugar> {
  Lugar _lugar;
  _pantallaLugarState(this._lugar);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_lugar.nombre),),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Image.network("http://192.168.1.4/appturismo/public/img/lugar/"+_lugar.urlfoto),
            Padding(padding: EdgeInsets.all(10),child: Text(_lugar.descripcion),),
            Flexible(
                child: FutureBuilder(
                  future: basededatos.obtenerFotos("lugar_id="+_lugar.id.toString()),
                  builder: (c,s){
                    if(s.hasData){
                      return GridView.builder(
                        itemCount: s.data == null ? 0 : s.data.length,

                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: MediaQuery.of(context).size.width/(MediaQuery.of(context).size.height/1.5)
                          ),
                          itemBuilder: (_c,_i){
                            return GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext) =>
                                        pantallaFoto(s.data[_i])));

                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    Image.network("http://192.168.1.4/appturismo/public/img/foto/"+s.data[_i].urlfoto),
                                    Text(s.data[_i].nombre)
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }else{
                      return Center(child: Text("No hay fotos"),);
                    }
                  },

            )
            )
          ],
        ),
      ),
    );
  }
}
