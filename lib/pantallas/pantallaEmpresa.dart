import 'package:app/basededatos/Empresa.dart';
import 'package:flutter/material.dart';
class pantallaEmpresa extends StatefulWidget {
  Empresa _empresa;
  pantallaEmpresa(this._empresa);
  @override
  _pantallaEmpresaState createState() => _pantallaEmpresaState( this._empresa);
}

class _pantallaEmpresaState extends State<pantallaEmpresa> {
  Empresa _empresa;
  _pantallaEmpresaState(this._empresa);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_empresa.razonsocial),),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Image.network("http://192.168.1.4/appturismo/public/img/empresa/"+_empresa.urllogo),
            Text(_empresa.descripcion)
          ],
        ),
      ),
    );
  }
}
