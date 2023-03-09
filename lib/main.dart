import 'package:estacionamiento/paginas/administracion/EstacionamientoView.dart';
import 'package:estacionamiento/paginas/administracion/Estadisticas.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:estacionamiento/paginas/usuario/ReservasView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickalert/quickalert.dart';

import 'RegistroUsuario.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAHomJb4E03VUJ9hRIbN3AV2Sp3_GbpUlk",
          authDomain: "intedecimo.firebaseapp.com",
          projectId: "intedecimo",
          storageBucket: "intedecimo.appspot.com",
          messagingSenderId: "1035708083787",
          appId: "1:1035708083787:web:64adf9992e1a223d2027ce",
          measurementId: "G-SDD5PXMXRJ"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva estacionamiento',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Reservas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final txtUserController = TextEditingController();
  final txtPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.network(
                'https://png.pngtree.com/png-clipart/20220911/original/pngtree-parking-png-image_8542900.png',
                width: 200),
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
              child: const Text("Iniciar sesion"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                User? user;
                try {
                  print('Validando Usuario');
                  UserCredential userCredential =
                      await auth.signInWithEmailAndPassword(
                    email: txtUserController.text,
                    password: txtPassController.text,
                  );
                  user = userCredential.user;
                  print('User Found');
                } on FirebaseAuthException catch (e) {
                  print('Error: ${e.code} ${e.message}');
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided.');
                  }
                }
                if (user != null) {
                  print('Acceso Correcto');
                  if (!mounted) return;
                  if (txtUserController.text == 'a@a.com') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Estadisticas()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReservasView()),
                    );
                  }
                } else {
                  print('Usuario No Válido');
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      title: 'Mensaje del Sistema',
                      text: 'Usuario y/o contraseña son invalidos!!');
                }
              },
            ),
            TextButton(
              child: const Text("Registrarse"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistroUsuario()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
