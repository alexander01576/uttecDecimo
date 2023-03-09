import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionamiento/paginas/administracion/EstacionamientoView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Estadisticas extends StatefulWidget {
  const Estadisticas({Key? key}) : super(key: key);

  @override
  State<Estadisticas> createState() => _EstadisticasState();
}

class _EstadisticasState extends State<Estadisticas> {
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String? userEmail = user?.email;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
    userEmail = user?.email;
  }

  @override
  Widget build(BuildContext context) {

    int numDocs = 0;

    void getNumDocs() {
      FirebaseFirestore.instance.collection('reservas').get()
          .then((QuerySnapshot snapshot) {
        setState(() {
          numDocs = snapshot.size;
          print(numDocs);
        });
      })
          .catchError((error) {
        print('Error al obtener el número de documentos: $error');
      });
    }

    @override
    void initState() {
      super.initState();
      getNumDocs();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Estadisticas Estacionamiento"),
        backgroundColor: Colors.amber,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: Image.network(
                            'https://cdn-icons-png.flaticon.com/512/2304/2304226.png')),
                    const Text(
                      "Usuario actual",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      userEmail ?? 'Usuario no identificado',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )),
            ListTile(
              leading: const Icon(Icons.view_compact),
              title: const Text('Estadisticas'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_compact),
              title: const Text('Estacionamientos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EstacionamientoView()),
                );
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: Text('Hay $numDocs documentos en la colección.'),
      ),

    );
  }
}
