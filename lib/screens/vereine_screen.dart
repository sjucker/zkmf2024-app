import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/verein_overview.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/favorite_button.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class VereineScreen extends StatefulWidget {
  const VereineScreen({super.key});

  @override
  State<StatefulWidget> createState() => _VereineScreenState();
}

class _VereineScreenState extends State<VereineScreen> {
  late Future<List<VereinOverviewDTO>> _vereine;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Home',
            onPressed: () {
              context.go('/');
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<VereinOverviewDTO>>(
          future: _vereine,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              late TextEditingController fieldTextEditingController;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Autocomplete<VereinOverviewDTO>(
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return [];
                        } else {
                          return snapshot.requireData
                              .where(
                                  (element) => element.name.toLowerCase().contains(textEditingValue.text.toLowerCase()))
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
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: gruen)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: gruen, width: 2)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            filled: true,
                            fillColor: blau,
                            hintStyle: TextStyle(color: silber),
                            hintText: "Suchen",
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: snapshot.requireData.length,
                      itemBuilder: (BuildContext context, int index) {
                        var requireData = snapshot.requireData[index];
                        return ListTile(
                          leading: FavoriteButton(
                            identifier: requireData.identifier,
                            offColor: Colors.white,
                            onColor: gelb,
                          ),
                          trailing: const Icon(
                            Icons.navigate_next_sharp,
                            color: Colors.white,
                          ),
                          onTap: () {
                            context.push('/vereine/${requireData.identifier}');
                          },
                          title: Text(
                            requireData.name,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    ),
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
}
