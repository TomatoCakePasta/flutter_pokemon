import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_pokemon/models/pokemon.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './poke_detail.dart';
import './poke_list_item.dart';
import './poke_list.dart';
import './settings.dart';
import './utils/theme_mode.dart';
import './models/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final themeModelNotifier = ThemeModeNotifier(pref);
  final pokemonsNotifier = PokemonsNotifier();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModeNotifier>(
          create:(context) => themeModelNotifier,
        ),
        ChangeNotifierProvider<PokemonsNotifier>(
          create: (context) => pokemonsNotifier,  
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ThemeMode mode = ThemeMode.system;

  // @override
  // void initState() {
  //   super.initState();
  //   loadThemeMode().then((val) => setState(() => mode = val));
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
      builder: (context, mode, child) => MaterialApp(
        title: "Pokemon Flutter",
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: mode.mode,
        home: const TopPage(),
      ),
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