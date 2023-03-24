import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'perfil.dart';
import 'qr_reserva.dart';
import 'reserva_edit.dart';

class ReservasView extends StatefulWidget {
  const ReservasView({Key? key}) : super(key: key);

  @override
  State<ReservasView> createState() => _ReservasViewState();
}

class _ReservasViewState extends State<ReservasView> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservas"),
        backgroundColor: Colors.purpleAccent,
      ),
      //vista del menu izquierdo
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: Image.network(
                            'https://cdn-icons-png.flaticon.com/512/1177/1177568.png')),
                    const SizedBox(height: 10),
                    const Text(
                      "Usuario:",
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
              title: const Text('Reservas'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.portrait),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Perfil()),
                );
              },
            ),
          ],
        ),
      ),

      //vista de los registros de reservas
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reservas')
            .where('usuario', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = docs[index];

                return ListTile(
                    leading: const Icon(Icons.directions_car),
                    title: Text(documentSnapshot['nombre_estacionamiento']),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Fecha reserva: ${documentSnapshot['fecha_reserva']}"),
                      ],
                    ),
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QrReserva(
                                      idDoc: docs[index].id.toString(),
                                    )),
                          )
                        });
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReservaEdit(idDoc: '')),
          );
        },
      ),
    );
  }
}
