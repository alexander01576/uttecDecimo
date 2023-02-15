import 'package:flutter/material.dart';
import 'package:estacionamiento/paginas/reservasView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva estacionamiento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.network(
                'https://static.vecteezy.com/system/resources/previews/002/392/698/large_2x/car-parking-roadsign-vector.jpg',
                width: 200),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
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
                  print('Validando User');

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

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReservasView()),
                  );
                } else {
                  print('Usuario No Válido');

                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      title: 'Mensaje del Sistema',
                      text: 'Usuario y/o contraseña son invalidos!!');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
