import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Book',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Pokemon Book'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  child:  Image.network(
                    url,
                    height: 100,
                    width: 100,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    "No.25",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )
                  )
                )
              ],
            ),
            const Text(
              "pikachu",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Chip(
              label: Text("electric"),
              backgroundColor: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
