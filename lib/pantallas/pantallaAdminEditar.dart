import 'dart:convert';
import 'dart:io';
import 'package:app/api/Api.dart';
import 'package:app/pantallas/pantallaAdmin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/basededatos/DBmanager.dart';
import 'package:app/basededatos/Empresa.dart';
import 'package:app/pantallas/pantallaRutas.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var basededatos = new DBmanager();
class pantallaAdminEditar extends StatefulWidget {
  Empresa empresa;
  pantallaAdminEditar(this.empresa);

  @override
  _pantallaAdminEditarState createState() => _pantallaAdminEditarState(this.empresa);
}

class _pantallaAdminEditarState extends State<pantallaAdminEditar> {
  Empresa empresa;
  _pantallaAdminEditarState(this.empresa);

  TextEditingController _razonsocial = new TextEditingController();
  TextEditingController _descripcion = new TextEditingController();
  //ruta_id
  var _rutaelegida;
  var _listarutas = List<DropdownMenuItem>();
  _obtenerListaRutas() async{
    var lista = await basededatos.obtenerRutas("1");
    lista.forEach((element) {
      setState(() {
        _listarutas.add(DropdownMenuItem( child: Text(element.nombre),value: element.id,));
      });
    });
  }
  // logo
  String _path;
  String _image64;
  // user_id
  var user_id = 0;
  void _verificarUsuario() async {
    SharedPreferences preferencia = await SharedPreferences.getInstance();
    var user = json.decode(preferencia.getString("user"));
    if (user!=null) {
      setState(() {
        user_id = user['id'];
      });
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaRutas()));
    }
  }

  @override
  void initState() {
    _razonsocial.text = empresa.razonsocial;
    _descripcion.text = empresa.descripcion;
    _rutaelegida = empresa.ruta_id;
    _verificarUsuario();
    _obtenerListaRutas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("INSERTAR EMPRESA"),),
      body: Container(
        child: Column(
          children: [
            TextField(controller: _razonsocial, decoration: new InputDecoration(hintText: "RAZÓN SOCIAL:") , ),
            TextField(controller: _descripcion, decoration: new InputDecoration(hintText: "DESCRIPCIÓN:") , ),
            DropdownButtonFormField(
              items: _listarutas,
              value: _rutaelegida,
              onChanged: (valor){
                setState(() {
                  _rutaelegida = valor;
                });
              },
            ),
            (_path== null ) ? Container() : Image.file(File(_path),width: 200,),
            RaisedButton(onPressed: () async{
              final ImagePicker _picker = ImagePicker();
              PickedFile _archivo = await _picker.getImage(source: ImageSource.gallery);
              setState(() {
                _path = _archivo.path;
              });

              List b = await File(_path).readAsBytesSync();
              _image64 = base64.encode(b);

            }, child: Text("SELECCIONAR IMAGEN"),),
            RaisedButton(onPressed: () async{
              _enviarFormulario();

            }, child: Text("ENVIAR FORMULARIO"),),

          ],
        ),
      ),
    );
  }
  void  _enviarFormulario() async {
    var data = {
      'razonsocial' : _razonsocial.text,
      'descripcion' : _descripcion.text,
      'ruta_id': _rutaelegida
    };
    if(_image64!= null){
      data = {
        'razonsocial' : _razonsocial.text,
        'descripcion' : _descripcion.text,
        'ruta_id': _rutaelegida,
        'urllogo' : _image64,
      };
    };
    var respuesta = await Api().editarData(data, "empresas",empresa.id.toString());
    var contenido = json.decode(respuesta.body);
    if(contenido['success']){
      print(contenido.toString());
      basededatos.actualizarEmpresa(Empresa(
          contenido['empresa']['id'],
          contenido['empresa']['razonsocial'],
          contenido['empresa']['descripcion'],
          contenido['empresa']['urllogo'],
          contenido['empresa']['ruta_id'],
          contenido['empresa']['user_id'])
      );

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaAdmin()));
    }else{
      print("fallo la edición");
    }

  }
}
