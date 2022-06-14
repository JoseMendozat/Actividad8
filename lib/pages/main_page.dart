import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Container(
        child: Text("Usuario no encontrado"),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF008F5A),
        title: Text("CFE Inicio"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Salir",
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Ingresado como ${user.email}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Logo_neutral_de_la_Comisi%C3%B3n_Federal_de_Electricidad.svg/3814px-Logo_neutral_de_la_Comisi%C3%B3n_Federal_de_Electricidad.svg.png')
        ],
      ),
    );
  }

  _logout() {
    FirebaseAuth.instance.signOut().then((result) {
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (_) => false);
    });
  }
}
