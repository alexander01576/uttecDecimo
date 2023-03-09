import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Location.dart';


class EstacionamientoEdit extends StatefulWidget {
  final String idDoc;
  const EstacionamientoEdit({Key? key, required this.idDoc}) : super(key: key);

  @override
  State<EstacionamientoEdit> createState() => _EstacionamientoEditState(idDoc);
}

class _EstacionamientoEditState extends State<EstacionamientoEdit> {

  CollectionReference collectionEstacionamiento =
  FirebaseFirestore.instance.collection('estacionamientos');

  final txtNombreEstacionamientoController = TextEditingController();
  final txtCapacidadController = TextEditingController();
  final txtPrecioHoraController = TextEditingController();
  final txtDireccionController = TextEditingController();
  final String idDoc;
  var selectedValue;

  final StreamController<QuerySnapshot> controllerEstacionamientos =
  StreamController<QuerySnapshot>.broadcast();
  Stream<QuerySnapshot> get outEstacionamientos => controllerEstacionamientos.stream;
  Sink<QuerySnapshot> get inEstacionamientos => controllerEstacionamientos.sink;

  bool isVisible = true;

  _EstacionamientoEditState(this.idDoc);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    {
      if (idDoc.isNotEmpty) {
        collectionEstacionamiento.doc(idDoc).get().then((value) => {
          if (value.exists)
            {
              txtNombreEstacionamientoController.text = value['nombre_estacionamiento'].toString(),
              txtCapacidadController.text = value['capacidad'].toString(),
              txtPrecioHoraController.text = value['precio_hora'],
              txtDireccionController.text = value['direccion'].toString(),
            }
        });
      } else {
        isVisible = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar/Añadir Estacionamiento'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
              child: TextField(
                controller: txtNombreEstacionamientoController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Nombre clave'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: TextField(
                controller: txtCapacidadController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Capacidad'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: TextField(
                controller: txtPrecioHoraController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Precio por hora'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: txtDireccionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Direccion',
                      ),
                    ),
                  ),
                  ElevatedButton.icon(

                    icon: Icon(Icons.my_location),
                    label: Text('ubicar'),
                    onPressed: () async {
                      // Obtener ubicación actual
                      final position = await Location.determinePosition();
                      // Actualizar campo de texto de dirección con la dirección obtenida
                      txtDireccionController.text = position.toString();
                    },
                  ),
                ],
              ),
            ),


            Visibility(
              visible: isVisible,
              child: TextButton(
                child: const Text("Eliminar"),
                style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  collectionEstacionamiento.doc(idDoc).delete();
                  Navigator.pop(context);
                },
              ),
            ),
            TextButton(
                child: const Text("Guardar"),
                style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  int capacidad = int.tryParse(txtCapacidadController.text) ?? 0;
                  if (idDoc.isEmpty) {
                    collectionEstacionamiento.add({
                      'nombre_estacionamiento': txtNombreEstacionamientoController.text,
                      'capacidad': capacidad,
                      'precio_hora': txtPrecioHoraController.text,
                      'direccion': txtDireccionController.text
                    });
                  } else {
                    collectionEstacionamiento.doc(idDoc).update({
                      'nombre_estacionamiento': txtNombreEstacionamientoController.text,
                      'capacidad': capacidad,
                      'precio_hora': txtPrecioHoraController.text,
                      'direccion': txtDireccionController.text
                    });
                  }
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
