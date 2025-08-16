import 'package:flutter/material.dart';
import 'package:flutter_pokemon/models/pokemon.dart';
import 'package:provider/provider.dart';
import './poke_list_item.dart';

class PokeList extends StatelessWidget {
  const PokeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PokemonsNotifier>(
      builder: (context, pokes, child) => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return PokeListItem(
            poke: pokes.byId( index + 1)
          );
        },
      ),
    );
  }
}