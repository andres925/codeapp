import 'package:app/basededatos/Foto.dart';
import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class pantallaFoto extends StatefulWidget {
  Foto foto;
  pantallaFoto(this.foto);
  @override
  _pantallaFotoState createState() => _pantallaFotoState(this.foto);
}

class _pantallaFotoState extends State<pantallaFoto> {
  Foto _foto;
  _pantallaFotoState(this._foto);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_foto.nombre),
      ),
      body: Container(
        child: Center(
          child: _foto.tipo == 0
              ? Image.network("http://192.168.1.4/appturismo/public/img/foto/" +
                  _foto.urlfoto)
              : Panorama(
                  child: Image.network(
                      "http://192.168.1.4/appturismo/public/img/foto/" +
                          _foto.urlfoto),
                ),
        ),
      ),
    );
  }
}
