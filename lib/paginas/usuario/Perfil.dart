  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  class Perfil extends StatefulWidget {
    const Perfil({Key? key}) : super(key: key);

    @override
    State<Perfil> createState() => _PerfilState();
  }

  class _PerfilState extends State<Perfil> {
    @override
    Widget build(BuildContext context) {
      final user = FirebaseAuth.instance.currentUser;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Perfil'),
          backgroundColor: Colors.purpleAccent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Perfil del usuario',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black12,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Nombre: ${user?.displayName ?? 'No disponible'}',
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                'Correo electrónico: ${user?.email ?? 'No disponible'}',
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }
  }
