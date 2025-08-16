import 'package:flutter/material.dart';
import './poke_detail.dart';

class PokeListItem extends StatelessWidget {
  const PokeListItem({Key? key, required this.index}) : super(key: key);
  final int index;
  final String url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        url,
        height: 50,
        width: 50,
      ),
      title: const Text('pikachu'),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => const PokeDetail(),
          ),
        );
      }
    );
  }
}