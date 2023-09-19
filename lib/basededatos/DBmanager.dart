import 'package:app/basededatos/Empresa.dart';
import 'package:app/basededatos/Foto.dart';
import 'package:app/basededatos/Lugar.dart';
import 'package:app/basededatos/Ruta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';

class DBmanager {
  // BASE
  static late Future<Database> _bd;
  Future<Database> get bd async {
    _bd = await initDb();
    return _bd;
  }

  initDb() async {
    io.Directory d = await getApplicationDocumentsDirectory();
    String path = join(d.path, "bdturismo.db");
    var base = await openDatabase(path, version: 1, onCreate: _onCreate);
    return base;
  }

  void _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE ruta(id INTEGER, nombre TEXT, urlfoto TEXT)");
    await db.execute(
        "CREATE TABLE empresa(id INTEGER, razonsocial TEXT, descripcion TEXT, urllogo TEXT, ruta_id INTEGER, user_id INTEGER)");
    await db.execute(
        "CREATE TABLE lugar(id INTEGER, nombre TEXT, descripcion TEXT, urlfoto TEXT, latitud TEXT, longitud TEXT, ruta_id INTEGER)");
    await db.execute(
        "CREATE TABLE foto(id INTEGER, nombre TEXT, urlfoto TEXT, tipo INTEGER, lugar_id INTEGER)");
  }

// métodos
// rutas
  Future<int> insertarRuta(Ruta modelo) async {
    var basededatos = await bd;
    int respuesta = await basededatos.insert("ruta", modelo.toMap());
    return respuesta;
  }

  Future<List<Ruta>> obtenerRutas(String condicion) async {
    var basededatos = await bd;
    List<Map> lista =
        await basededatos.rawQuery("SELECT * FROM ruta WHERE " + condicion);
    List<Ruta> rutas = [];
    for (int i = 0; i < lista.length; i++) {
      rutas.add(
          new Ruta(lista[i]['id'], lista[i]['nombre'], lista[i]['urlfoto']));
    }
    return rutas;
  }

// EMPRESA
  Future<int> insertarEmpresa(Empresa empresa) async {
    var basedetados = await bd;
    int respuesta = await basedetados.insert("empresa", empresa.toMap());
    return respuesta;
  }

  Future<List<Empresa>> obtenerEmpresas(String condicion) async {
    var basededatos = await bd;
    List<Map> lista =
        await basededatos.rawQuery("SELECT * FROM empresa WHERE " + condicion);
    List<Empresa> empresas = [];
    for (int i = 0; i < lista.length; i++) {
      empresas.add(new Empresa(
        lista[i]['id'],
        lista[i]['razonsocial'],
        lista[i]['descripcion'],
        lista[i]['urllogo'],
        lista[i]['ruta_id'],
        lista[i]['user_id'],
      ));
    }
    return empresas;
  }

  Future<int> actualizarEmpresa(Empresa empresa) async {
    var base = await bd;
    return await base.update("empresa", empresa.toMap(),
        where: 'id= ?', whereArgs: [empresa.id]);
  }

  Future<int> borrarTablaId(tabla,id) async {
    var base = await bd;
    return await base.delete(tabla,
        where: 'id= ?',
        whereArgs: [id]);
  }


  // LUGAR
  Future<int> insertarLugar(Lugar lugar) async {
    var base = await bd;
    int respuesta = await base.insert("lugar", lugar.toMap());
    return respuesta;
  }

  Future<List<Lugar>> obtenerLugares(String condicion) async {
    var base = await bd;
    List<Map> lista =
        await base.rawQuery("SELECT * FROM lugar WHERE " + condicion);
    List<Lugar> lugares = [];
    for (int i = 0; i < lista.length; i++) {
      lugares.add(new Lugar(
          lista[i]['id'],
          lista[i]['nombre'],
          lista[i]['descripcion'],
          lista[i]['urlfoto'],
          lista[i]['latitud'],
          lista[i]['longitud'],
          lista[i]['ruta_id']));
    }
    return lugares;
  }

  // FOTOS
  Future<int> insertarFoto(Foto foto) async {
    var base = await bd;
    int respuesta = await base.insert("foto", foto.toMap());
    return respuesta;
  }

  Future<List<Foto>> obtenerFotos(String condicion) async {
    var base = await bd;
    List<Map> lista =
        await base.rawQuery("SELECT * FROM foto WHERE " + condicion);
    List<Foto> fotos = [];
    for (int i = 0; i < lista.length; i++) {
      fotos.add(new Foto(lista[i]['id'], lista[i]['nombre'],
          lista[i]['urlfoto'], lista[i]['tipo'], lista[i]['lugar_id']));
    }
    return fotos;
  }

  // delete
  Future<int> borrarTabla(String tabla) async {
    var base = await bd;
    return await base.rawDelete("DELETE FROM " + tabla);
  }
}
