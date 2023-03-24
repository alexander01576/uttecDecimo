import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';


class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({Key? key}) : super(key: key);

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {

  final txtUserController = TextEditingController();
  final txtPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de usuario"),
        backgroundColor: Colors.amber,
      ),

      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
              child: TextField(
                controller: txtUserController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Usuario'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: TextField(
                controller: txtPassController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Contraseña'),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                User? user;
                try {
                  //print('Registrando Usuario');
                  UserCredential userCredential =
                  await auth.createUserWithEmailAndPassword(
                    email: txtUserController.text,
                    password: txtPassController.text,
                  );
                  user = userCredential.user;
                  //print('Usuario creado exitosamente');
                  // ignore: use_build_context_synchronously
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: 'Registro Exitoso: ',
                      text: 'Se ha registrado el correo electrónico: ${user?.email}');
                } on FirebaseAuthException catch (e) {
                  //print('Error: ${e.code} ${e.message}');
                  if (e.code == 'weak-password') {
                    //print('La contraseña es demasiado débil.');
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: 'Contraseña muy debil',
                        text: 'Intente de nuevo');
                  } else if (e.code == 'email-already-in-use') {
                    //print('El correo electrónico ya está en uso.');
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: 'El correo electrónico ya está en uso.',
                        text: 'Intente de nuevo');
                  }
                } catch (e) {
                  //print('Error: $e');
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      title: 'Error al registrar en:',
                      text: '$e');
                }
              },
              child: const Text("Registrarse"),
            ),
          ],
        ),
      ),
    );
  }
}
