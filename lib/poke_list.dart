import 'package:flutter/material.dart';
import 'package:flutter_pokemon/const/pokeapi.dart';
import 'package:flutter_pokemon/models/favorite.dart';
import 'package:flutter_pokemon/models/pokemon.dart';
import 'package:provider/provider.dart';
import './poke_list_item.dart';

class PokeList extends StatefulWidget {
  const PokeList({Key? key}) : super(key: key);

  @override
  _PokeListState createState() => _PokeListState();
}

List<Favorite> favMock = [
  Favorite(pokeId: 1),
  Favorite(pokeId: 3),
  Favorite(pokeId: 5),
];

class _PokeListState extends State<PokeList> {
  static const int pageSize = 30;
  bool isFavoriteMode = false;
  int _currentPage = 1;

  int itemCount(int page) {
    int ret = page * pageSize;
    if (isFavoriteMode && ret > favMock.length) {
      ret = favMock.length;
    }
    if (ret > pokeMaxId) {
      ret = pokeMaxId;
    }
    return ret;
  }

  int itemId(int index) {
    int ret = index + 1;
    if (isFavoriteMode) {
      ret = favMock[index].pokeId;
    }
    return ret;
  }

  bool isLastPage(int page) {
    if (isFavoriteMode) {
      if (_currentPage * pageSize < favMock.length) {
        return false;
      }
      return true;
    }
    else {
      if (_currentPage * pageSize < pokeMaxId) {
        return false;
      }
      return true;
    }
  }

  void changeMode(bool fav) {
    setState(() {
      isFavoriteMode = !fav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 24,
          alignment: Alignment.topRight,
          child: IconButton(
            padding: const EdgeInsets.all(0),
            icon: const Icon(Icons.auto_awesome_outlined),
            onPressed: () async {
              var ret = await showModalBottomSheet<bool>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                builder: (BuildContext context) {
                  return ViewModeBottomSheet(
                    favMode: isFavoriteMode,
                  );
                },
              );
              if (ret != null && ret) {
                changeMode(isFavoriteMode);
              }
            },
          ),
        ),
        Expanded(
          child: Consumer<PokemonsNotifier>(
            builder: (context, pokes, child) => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              itemCount: itemCount(_currentPage) + 1,
              itemBuilder: (context, index) {
                if (index == itemCount(_currentPage)) {
                  return OutlinedButton(
                    child: const Text("Load More"),
                    onPressed: isLastPage(_currentPage)
                      ? null
                      : () => {
                        setState(() => _currentPage++),
                      },
                  );
                }
                else {
                  return PokeListItem(
                    poke: pokes.byId(itemId(index)),
                  );
                }
              },
            ),
          )
        )
      ]
    );
  }
}

class ViewModeBottomSheet extends StatelessWidget {
  const ViewModeBottomSheet({
    Key? key,
    required this.favMode,
  }) : super(key: key);
  final bool favMode;

  String mainText(bool fav) {
    if (fav) {
      return "Showing Favorites";
    } else {
      return "Showing All";
    }
  }

  String menuTitle(bool fav) {
    if (fav) {
      return "Switch to All";
    } else {
      return "Switch to Favorites";
    }
  }

  String menuSubtitle(bool fav) {
    if (fav) {
      return "View all Pokémon";
    } else {
      return "View only favorites";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 5,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Text(
                  mainText(favMode),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: Text(
                  menuTitle(favMode),
                ),
                subtitle: Text(
                  menuSubtitle(favMode),
                ),
                onTap: () {
                  Navigator.pop(context, true);
                },
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Cancel"),
              )
            ]
          )
        )
      )
    );
  }
}