import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class ReservaEdit extends StatefulWidget {
  final String idDoc;
  const ReservaEdit({Key? key, required this.idDoc}) : super(key: key);

  @override
  State<ReservaEdit> createState() => _ReservaEditState(idDoc);
}

class _ReservaEditState extends State<ReservaEdit> {
  CollectionReference collectionEstacionamiento =
  FirebaseFirestore.instance.collection('reservas');

  final txtNombreEstacionamientoController = TextEditingController();
  final txtFechaReservaController = TextEditingController();
  final String idDoc;
  var selectedValue;

  final StreamController<QuerySnapshot> controllerEstacionamientos =
  StreamController<QuerySnapshot>.broadcast();
  Stream<QuerySnapshot> get outReservas => controllerEstacionamientos.stream;
  Sink<QuerySnapshot> get inReservas => controllerEstacionamientos.sink;

  bool isVisible = true;

  _ReservaEditState(this.idDoc);

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
              txtFechaReservaController.text = value['fecha_reserva'].toString(),
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
        title: const Text('Nueva Reserva'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: TextField(
                controller: txtNombreEstacionamientoController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nombre del estacionamiento'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    onConfirm: (date) {
                      setState(() {
                        // Asigna la fecha seleccionada al controlador de texto correspondiente
                        txtFechaReservaController.text =
                        "${date.year}-${date.month}-${date.day}";
                      });
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.es, // Opcional: define el idioma del selector de fecha
                  );
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: txtFechaReservaController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Fecha reserva',
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
                child: const Text("Generar Reserva"),
                style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  if (idDoc.isEmpty) {
                    collectionEstacionamiento.add({
                      'nombre_estacionamiento': txtNombreEstacionamientoController.text,
                      'fecha_reserva': txtFechaReservaController.text,
                    });
                  } else {
                    collectionEstacionamiento.doc(idDoc).update({
                      'nombre_estacionamiento': txtNombreEstacionamientoController.text,
                      'fecha_reserva': txtFechaReservaController.text,
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
