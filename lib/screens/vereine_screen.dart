import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/verein_overview.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/favorite_button.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class VereineScreen extends StatefulWidget {
  const VereineScreen({super.key});

  @override
  State<StatefulWidget> createState() => _VereineScreenState();
}

class _VereineScreenState extends State<VereineScreen> {
  final box = GetStorage();
  final controller = TextEditingController();

  late Future<List<VereinOverviewDTO>> _vereine;
  late String? _selectedVerein;

  String? filterText;
  bool favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _vereine = fetchVereine();
    _selectedVerein = box.read(selectedVereinKey);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vereine'),
        actions: homeAction(context),
      ),
      body: Center(
        child: FutureBuilder<List<VereinOverviewDTO>>(
          future: _vereine,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var requireData = snapshot.requireData;
              var filteredData = _filter(requireData);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                filterText = controller.text;
                              });
                            },
                            controller: controller,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.search,
                                color: gruen,
                              ),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: silber)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              filled: true,
                              fillColor: blau,
                              hintStyle: TextStyle(color: gruen),
                              hintText: "Suchen",
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                favoritesOnly = !favoritesOnly;
                              });
                            },
                            icon: Icon(
                              favoritesOnly ? Icons.star : Icons.star_outline,
                              color: gelb,
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                        children: filteredData.map((dto) {
                      var favoriteKey = UniqueKey();
                      return ListTile(
                        key: Key('list-tile-${dto.identifier}'),
                        leading: FavoriteButton(
                          key: favoriteKey,
                          identifier: dto.identifier,
                          offColor: Colors.white,
                          onColor: gelb,
                        ),
                        trailing: Icon(
                          Icons.navigate_next_sharp,
                          color: dto.identifier == _selectedVerein ? gelb : Colors.white,
                        ),
                        onTap: () {
                          context.push('/vereine/${dto.identifier}').then((_) {
                            setState(() {
                              favoriteKey = UniqueKey();
                            });
                          });
                        },
                        title: Text(
                          dto.name,
                          style: TextStyle(
                            color: dto.identifier == _selectedVerein ? gelb : Colors.white,
                            fontWeight: dto.identifier == _selectedVerein ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList()),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const GeneralErrorWidget();
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  List<VereinOverviewDTO> _filter(List<VereinOverviewDTO> data) {
    List<bool Function(VereinOverviewDTO)> predicates = List.empty(growable: true);
    predicates.add((element) => true);
    if (filterText?.isNotEmpty ?? false) {
      predicates.add((element) => element.name.toLowerCase().contains(filterText!.trim().toLowerCase()));
    }
    if (favoritesOnly) {
      predicates.add((element) => box.read('favorite-${element.identifier}') ?? false);
    }
    return data.where((element) => predicates.every((test) => test(element))).toList();
  }
}
