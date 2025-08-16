import 'dart:ffi';

import 'package:flutter/material.dart';
import './poke_detail.dart';
import './poke_list_item.dart';
import './poke_list.dart';
import './settings.dart';
import './util/theme_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode mode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    loadThemeMode().then((val) => setState(() => mode = val));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Book',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: mode,
      home: const TopPage(), // const MyHomePage(title: 'Pokemon Book'),
    );
  }
}

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int currentbnb = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: currentbnb == 0 ? const PokeList() : const Settings(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          setState(() {
            currentbnb = index;
          })
        },
        currentIndex: currentbnb,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ]
      ),
    );
  }
}