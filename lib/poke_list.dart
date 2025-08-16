import 'package:flutter/material.dart';
import 'package:flutter_pokemon/const/pokeapi.dart';
import 'package:flutter_pokemon/models/favorite.dart';
import 'package:flutter_pokemon/models/pokemon.dart';
import 'package:flutter_pokemon/poke_grid_item.dart';
import 'package:provider/provider.dart';
import './poke_list_item.dart';

class PokeList extends StatefulWidget {
  const PokeList({Key? key}) : super(key: key);

  @override
  _PokeListState createState() => _PokeListState();
}

class _PokeListState extends State<PokeList> {
  static const int pageSize = 30;
  bool isFavoriteMode = false;
  int _currentPage = 1;
  bool isGridMode = true;

  int itemCount(int favsCount, int page) {
    int ret = page * pageSize;
    if (isFavoriteMode && ret > favsCount) {
      ret = favsCount;
    }
    if (ret > pokeMaxId) {
      ret = pokeMaxId;
    }
    return ret;
  }

  int itemId(List<Favorite> favs, int index) {
    int ret = index + 1;
    if (isFavoriteMode && index < favs.length) {
      ret = favs[index].pokeId;
    }
    return ret;
  }

  bool isLastPage(int favsCount, int page) {
    if (isFavoriteMode) {
      if (_currentPage * pageSize < favsCount) {
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

  void changeFavMode(bool fav) {
    setState(() {
      isFavoriteMode = !fav;
    });
  }

  void changeGridMode(bool grid) {
    setState(() {
      isGridMode = !grid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteNotifier>(
      builder: (context, favs, child) => Column(
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
                      changeFavMode: changeFavMode,
                      gridMode: isGridMode,
                      changeGridMode: changeGridMode,
                    );
                  },
                );
                if (ret != null && ret) {
                  changeFavMode(isFavoriteMode);
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<PokemonsNotifier>(
              builder: (context, pokes, child) {
                if (itemCount(favs.favs.length, _currentPage) == 0) {
                  return const Text("no data");
                }
                else {
                  if (isGridMode) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      itemCount: itemCount(favs.favs.length, _currentPage) + 1,
                      itemBuilder: (context, index) {
                        if (index == itemCount(favs.favs.length, _currentPage)) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: OutlinedButton(
                              child: const Text("more"),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: isLastPage(favs.favs.length, _currentPage)
                                ? null
                                : () => {
                                  setState(() => _currentPage++),
                                },
                            ),
                          );
                        }
                        else {
                          return PokeGridItem(
                            poke: pokes.byId(itemId(favs.favs, index)),
                          );
                        }
                      },
                    );
                  }
                  else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      itemCount: itemCount(favs.favs.length, _currentPage) + 1,
                      itemBuilder: (context, index) {
                      if (index == itemCount(favs.favs.length, _currentPage)) {
                        return OutlinedButton(
                          child: const Text("Load More"),
                          onPressed: isLastPage(favs.favs.length, _currentPage)
                            ? null
                            : () => {
                              setState(() => _currentPage++),
                            },
                        );
                      }
                      else {
                        return PokeListItem(
                          poke: pokes.byId(itemId(favs.favs, index)),
                        );
                      }
                    },
                    );
                  }
                }
              },
            )
          )
        ]
      ),
    );
  }
}

class ViewModeBottomSheet extends StatelessWidget {
  const ViewModeBottomSheet({
    Key? key,
    required this.favMode,
    required this.changeFavMode,
    required this.gridMode,
    required this.changeGridMode,
  }) : super(key: key);
  final bool favMode;
  final Function(bool) changeFavMode;
  final bool gridMode;
  final Function(bool) changeGridMode;

  String mainText(bool fav) {
    return "Display Settings";
  }

  String menuFavTitle(bool fav) {
    if (fav) {
      return "Show All";
    } else {
      return "Show Favorites";
    }
  }

  String menuFavSubtitle(bool fav) {
    if (fav) {
      return "View all Pokémon";
    } else {
      return "View only favorites";
    }
  }

  String menuGridTitle(bool grid) {
    if (grid) {
      return "Change to List";
    } else {
      return "Change to Grid";
    }
  }

  String menuGridSubtitle(bool grid) {
    if (grid) {
      return "Showing grid view";
    } else {
      return "Showing list view";
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
                  menuFavTitle(favMode),
                ),
                subtitle: Text(
                  menuFavSubtitle(favMode),
                ),
                onTap: () {
                  changeFavMode(favMode);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.grid_3x3),
                title: Text(
                  menuGridTitle(gridMode),
                ),
                subtitle: Text(
                  menuGridSubtitle(gridMode),
                ),
                onTap: () {
                  changeGridMode(gridMode);
                  Navigator.pop(context);
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