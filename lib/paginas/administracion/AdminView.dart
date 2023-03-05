import 'package:estacionamiento/paginas/administracion/UsuariosView.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EstacionamientoEdit.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);
  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administracion"),
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
                      "Administracion",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
            ListTile(
              leading: const Icon(Icons.view_compact),
              title: const Text('Estacionamiento'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_compact),
              title: const Text('Usuarios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsuariosView()),
                );
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
                      children: <Widget>[Text("Capacidad: " +
                            documentSnapshot['capacidad'].toString()),
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
