import 'package:estacionamiento/paginas/administracion/estadisticas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'formularios/estacionamiento_edit.dart';

class EstacionamientoView extends StatefulWidget {
  const EstacionamientoView({Key? key}) : super(key: key);
  @override
  State<EstacionamientoView> createState() => _EstacionamientoViewState();
}

class _EstacionamientoViewState extends State<EstacionamientoView> {
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
        title: const Text("Estacionamientos"),
        backgroundColor: Colors.amber,
      ),
      //vista del menu izquierdo
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Estadisticas()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_compact),
              title: const Text('Estacionamientos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),

      //vista de la pagina de estacionamientos (primera vista de administracion)
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('estacionamientos')
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
                    leading: const Icon(Icons.menu_book),
                    title: Text(documentSnapshot['nombre_estacionamiento']),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Capacidad: ${documentSnapshot['capacidad']}"),
                      ],
                    ),
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EstacionamientoEdit(
                                      idDoc: docs[index].id.toString(),
                                    )),
                          )
                        });
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const EstacionamientoEdit(
                      idDoc: '',
                    )),
          );
        },
      ),
    );
  }
}
