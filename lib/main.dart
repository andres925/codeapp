import 'package:app/pantallas/pantallaRutas.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PaginaInicio()
    );
  }
}

class PaginaInicio extends StatefulWidget {
  @override
  _PaginaInicioState createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:[Colors.yellow,Colors.orange],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/ic_logo.png"),
              Padding(
                padding: EdgeInsets.only(bottom: 100, top:20),
                child: Text(
                  "TURISMO VIRTUAL",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepOrange, fontSize: 25),
                ),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext) => pantallaRutas())
                  );
                },
                shape: CircleBorder(),
                color: Colors.green,
                padding: EdgeInsets.all(15.0),
                child: Icon(Icons.chevron_right, color: Colors.white,),

              )
            ],
          ),
        ),
      ),
    );
  }
}

