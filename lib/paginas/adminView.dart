import 'package:flutter/material.dart';

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
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.cyan,
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: Image.network(
                            'https://static.wixstatic.com/media/e75e21_defd59f127ac4f0cb3c1352b7afeccf6~mv2.png')),
                    const Text(
                      "-> Administracion <-",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
            ListTile(
              leading: const Icon(Icons.accessibility),
              title: const Text('Administracion'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
