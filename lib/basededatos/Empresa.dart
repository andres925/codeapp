class Empresa{
  final int id;
  final String razonsocial;
  final String descripcion;
  final String urllogo;
  final int ruta_id;
  final int user_id;


  Empresa(this.id, this.razonsocial, this.descripcion, this.urllogo,
      this.ruta_id, this.user_id);

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['razonsocial'] = razonsocial;
    map['descripcion'] = descripcion;
    map['urllogo'] = urllogo;
    map['ruta_id'] = ruta_id;
    map['user_id'] = user_id;
    return map;
  }
}