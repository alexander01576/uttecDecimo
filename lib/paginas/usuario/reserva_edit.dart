import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String? userEmail = user?.email;
  final txtNombreEstacionamientoController = TextEditingController();
  final txtFechaReservaController = TextEditingController();
  final String idDoc;
  String? selectedValue;
  final StreamController<QuerySnapshot> controllerEstacionamientos =
      StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot> get outReservas => controllerEstacionamientos.stream;

  Sink<QuerySnapshot> get inReservas => controllerEstacionamientos.sink;
  bool isVisible = true;

  _ReservaEditState(this.idDoc);

  @override
  void initState() {
    super.initState();
    {
      userEmail = user?.email;
      if (idDoc.isNotEmpty) {
        collectionEstacionamiento.doc(idDoc).get().then((value) => {
              if (value.exists)
                {
                  txtNombreEstacionamientoController.text =
                      value['nombre_estacionamiento'].toString(),
                  txtFechaReservaController.text =
                      value['fecha_reserva'].toString(),
                }
            });
      } else {
        isVisible = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? selectedEstacionamiento;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Reserva'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
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
                    locale: LocaleType
                        .es, // Opcional: define el idioma del selector de fecha
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
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('estacionamientos')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error al cargar los estacionamientos');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final estacionamientos = snapshot.data!.docs
                      .map((doc) => doc['nombre_estacionamiento'] as String)
                      .toList();

                  return DropdownButtonFormField<String>(
                    value: selectedEstacionamiento,
                    items: estacionamientos
                        .map(
                            (nombreEstacionamiento) => DropdownMenuItem<String>(
                                  value: nombreEstacionamiento,
                                  child: Text(nombreEstacionamiento),
                                ))
                        .toList(),
                    hint: const Text('Selecciona un estacionamiento'),
                    onChanged: (selectedEstacionamiento) {
                      setState(() {
                        selectedEstacionamiento = selectedEstacionamiento;
                      });
                    },
                  );
                },
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                if (idDoc.isEmpty) {
                  collectionEstacionamiento.add({
                    'nombre_estacionamiento': selectedEstacionamiento,
                    'fecha_reserva': txtFechaReservaController.text,
                    'usuario': userEmail,
                    'estatus': 0,
                  });
                }
                /*else {
                    collectionEstacionamiento.doc(idDoc).update({
                      'nombre_estacionamiento': _selectedEstacionamiento,
                      'fecha_reserva': txtFechaReservaController.text,
                      'usuario': userEmail,
                    });
                  }*/
                Navigator.pop(context);
              },
              child: const Text("Generar Reserva"),
            ),
          ],
        ),
      ),
    );
  }
}
