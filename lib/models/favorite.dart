import 'package:flutter/material.dart';
import 'package:flutter_pokemon/db/favorites.dart';

class FavoriteNotifier extends ChangeNotifier {
  final List<Favorite> _favs = [];

  FavoriteNotifier() {
    syncDb();
  }

  void syncDb() async {
    FavoritesDb.read().then(
      (val) => _favs
        ..clear()
        ..addAll(val),
      );
      notifyListeners();
  }

  List<Favorite> get favs => _favs;

  void toggle(Favorite fav) {
    if (isExist(fav.pokeId)) {
      delete(fav.pokeId);
    }
    else {
      add(fav);
    }
  }

  bool isExist(int id) {
    if (_favs.indexWhere((fav) => fav.pokeId == id) < 0) {
      return false;
    }
    return true;
  }

  void add(Favorite fav) async{
    await FavoritesDb.create(fav);
    syncDb();
  }

  void delete(int id) async {
    await FavoritesDb.delete(id);
    syncDb();
  }
}

class Favorite {
  final int pokeId;

  Favorite({
    required this.pokeId,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": pokeId,
    };
  }
}