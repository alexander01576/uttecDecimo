import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionamiento/paginas/administracion/EstacionamientoView.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:quickalert/quickalert.dart';

class LecturaQR extends StatefulWidget {
  const LecturaQR({Key? key}) : super(key: key);

  @override
  State<LecturaQR> createState() => _LecturaQRState();
}

class _LecturaQRState extends State<LecturaQR> {
  final txtMatriculaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leer QR'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 200, 30, 30),
              child: TextField(
                  controller: txtMatriculaController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Escane el codigo QR',
                      suffixIcon: Icon(
                        Icons.camera_alt,
                      )),
                  onTap: () async {
                    var status = await Permission.camera.status;
                    await Permission.camera.request();
                    await Permission.storage.request();
                    String? cameraScanResult = await scanner.scan();
                    txtMatriculaController.text = cameraScanResult!;
                  }),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                // Obtén el ID de la reserva escaneada
                String reservaID = txtMatriculaController.text;

                // Verifica si la cadena está vacía o nula
                if (reservaID.isEmpty || reservaID == null) {
                  // Muestra una alerta de error si está vacío
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: 'Error',
                    text: 'No hay código que verificar.',
                    onConfirmBtnTap: () async {
                      // Vuelve a la pantalla anterior
                      Navigator.pop(context);
                    },
                  );
                } else {
                  // Verifica si la reserva existe en la base de datos
                  DocumentSnapshot reservaSnapshot = await FirebaseFirestore
                      .instance
                      .collection('reservas')
                      .doc(reservaID)
                      .get();
                  if (!reservaSnapshot.exists) {
                    // Muestra una alerta de error si la reserva no existe
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Error',
                      text: 'La reserva no existe.',
                      onConfirmBtnTap: () async {
                        // Vuelve a la pantalla anterior
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    // Verifica si el campo "estatus" ya está establecido en 0
                    var reservaSnapshot = await FirebaseFirestore.instance
                        .collection('reservas')
                        .doc(reservaID)
                        .get();
                    if (reservaSnapshot.exists &&
                        reservaSnapshot.data()!['estatus'] == 0) {
                      // Muestra una alerta de advertencia si el campo "estatus" ya está establecido en 0
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: 'Advertencia',
                        text: 'La reserva ya ha sido validada.',
                        onConfirmBtnTap: () async {
                          // Vuelve a la pantalla anterior
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      // Actualiza el documento de la reserva en la colección 'reservas'
                      await FirebaseFirestore.instance
                          .collection('reservas')
                          .doc(reservaID)
                          .update({
                        'estatus': 0,
                      });
                      // Muestra un diálogo de éxito
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: 'QR validado',
                        text: 'El QR ha sido validado con éxito.',
                        onConfirmBtnTap: () async {
                          // Vuelve a la pantalla anterior
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EstacionamientoView()),
                          );
                        },
                      );
                    }
                  }
                }
              },
              child: const Text("Validar QR"),
            ),
          ],
        ),
      ),
    );
  }
}
