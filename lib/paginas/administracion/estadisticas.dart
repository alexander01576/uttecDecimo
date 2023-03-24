import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionamiento/paginas/administracion/estacionamiento_view.dart';
import 'package:estacionamiento/paginas/administracion/lectura_qr.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int numDocs = 0;

  void cargarReserva (){
    FirebaseFirestore.instance.collection('reservas').get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        numDocs = snapshot.size;
        //print(numDocs);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
    userEmail = user?.email;
    cargarReserva();
  }

  @override
  Widget build(BuildContext context) {

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
                FirebaseFirestore.instance.collection('reservas').get()
                    .then((QuerySnapshot snapshot) {
                  setState(() {
                    numDocs = snapshot.size;
                    //print(numDocs);
                  });
                })
                    .catchError((error) {
                  //print('Error al obtener el número de documentos: $error');
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_compact),
              title: const Text('Estacionamientos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EstacionamientoView()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_compact),
              title: const Text('Lectura de QR'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LecturaQR()),
                );
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[300],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(20),
          child: Text(
            'Hay $numDocs reservas.',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),


    );
  }
}
