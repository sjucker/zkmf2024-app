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

  late Future<List<VereinOverviewDTO>> _vereine;

  bool favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _vereine = fetchVereine();
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
              late TextEditingController fieldTextEditingController;
              var requireData = snapshot.requireData;
              var filteredData = _filter(requireData);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Autocomplete<VereinOverviewDTO>(
                            optionsBuilder: (textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return [];
                              } else {
                                return requireData
                                    .where((element) =>
                                        element.name.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                                    .toList();
                              }
                            },
                            displayStringForOption: (option) => option.name,
                            onSelected: (option) {
                              context.push('/vereine/${option.identifier}');
                              fieldTextEditingController.text = '';
                            },
                            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                              fieldTextEditingController = textEditingController;
                              return TextField(
                                controller: fieldTextEditingController,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: gruen,
                                  ),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: silber)),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  filled: true,
                                  fillColor: blau,
                                  hintStyle: TextStyle(color: gruen),
                                  hintText: "Suchen",
                                ),
                              );
                            },
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
                        children: filteredData
                            .map((dto) => ListTile(
                                  key: Key('list-tile-${dto.identifier}'),
                                  leading: FavoriteButton(
                                    key: Key('favorite-${dto.identifier}'),
                                    identifier: dto.identifier,
                                    offColor: Colors.white,
                                    onColor: gelb,
                                  ),
                                  trailing: const Icon(
                                    Icons.navigate_next_sharp,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    context.push('/vereine/${dto.identifier}');
                                  },
                                  title: Text(
                                    dto.name,
                                  ),
                                ))
                            .toList()),
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
    if (!favoritesOnly) {
      return data;
    } else {
      return data.where((element) => box.read('favorite-${element.identifier}') ?? false).toList();
    }
  }
}
