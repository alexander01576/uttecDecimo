import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrReserva extends StatefulWidget {
  final String idDoc;
  const QrReserva({Key? key, required this.idDoc}) : super(key: key);

  @override
  State<QrReserva> createState() => _QrReservaState(idDoc);
}

class _QrReservaState extends State<QrReserva> {
  CollectionReference collectionEstacionamiento =
  FirebaseFirestore.instance.collection('estacionamientos');

  Map<String, dynamic> data = {};


  final String idDoc;

  _QrReservaState(this.idDoc);

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('reservas')
        .doc(widget.idDoc)
        .get()
        .then((value) {
      setState(() {
        data = value.data()!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nombre del estacionamiento: ${data['nombre_estacionamiento']}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              "Fecha de reserva: ${data['fecha_reserva']}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            QrImage(
              data: "${data['nombre_estacionamiento']}-${data['fecha_reserva']}",
              version: QrVersions.auto,
              size: 300.0,
            ),
          ],
        ),
      ),
    );
  }
}