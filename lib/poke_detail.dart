import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokemon/const/pokeapi.dart';
import 'package:flutter_pokemon/models/favorite.dart';
import 'package:flutter_pokemon/models/pokemon.dart';
import 'package:provider/provider.dart';

class PokeDetail extends StatelessWidget {
  const PokeDetail({Key? key, required this.poke}) : super(key: key);
  final Pokemon poke;

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteNotifier>(
      builder: (context, favs, child) => Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                trailing: IconButton(
                  onPressed: () {
                    favs.toggle(Favorite(pokeId: poke.id));
                  },
                  icon: favs.isExist(poke.id) 
                    ? Icon(Icons.star, color: Colors.orangeAccent)
                    : Icon(Icons.star_outline),
                ),
              ),
              const Spacer(),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: Hero(
                      tag: poke.name,
                      child: CachedNetworkImage(
                        imageUrl: poke.imageUrl,
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "No.${poke.id}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  )
                ],
              ),
              Text(
                poke.name,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: poke.types
                  .map(
                    (type) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Chip(
                        backgroundColor: pokeTypeColors[type] ?? Colors.grey,
                        label: Text(
                          type,
                          style: TextStyle(                          
                            fontWeight: FontWeight.bold,
                            color: (pokeTypeColors[type] ?? Colors.grey)
                              .computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              ),
              const Spacer(),
            ],
          ),
        ),
      )
    );
  }
}
