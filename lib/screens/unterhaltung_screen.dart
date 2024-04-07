import 'package:flutter/material.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/unterhaltung_type.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class UnterhaltungScreen extends StatefulWidget {
  const UnterhaltungScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UnterhaltungScreenState();
}

class _UnterhaltungScreenState extends State<UnterhaltungScreen> {
  Map<UnterhaltungEntryType, bool> typeFilter = {for (var element in UnterhaltungEntryType.values) element: true};
  List<UnterhaltungEntryType> availableTypes = UnterhaltungEntryType.values;
  Map<String, bool> locationFilter = {};
  List<String> availableLocations = [];

  List<UnterhaltungTypeDTO> allData = [];
  List<UnterhaltungTypeDTO> filterdData = [];

  final Future<List<UnterhaltungTypeDTO>> unterhaltung = fetchUnterhaltung();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unterhaltungsprogramm"),
      ),
      body: FutureBuilder(
          future: unterhaltung,
          builder: (BuildContext context, AsyncSnapshot<List<UnterhaltungTypeDTO>> snapshot) {
            if (snapshot.hasData) {
              allData = snapshot.requireData;
              allData.sort((a, b) => Enum.compareByIndex(a.type, b.type));
              if (availableLocations.isEmpty) {
                availableLocations = allData.expand((e) => e.entries.map((e) => e.location.name)).toSet().toList();
                availableLocations.sort((a, b) => a.compareTo(b));
              }
              if (locationFilter.isEmpty) {
                locationFilter = {for (var element in availableLocations) element: true};
              }
              filterData();

              return SingleChildScrollView(
                child: Column(
                  children: buildUnterhaltung(),
                ),
              );
            } else if (snapshot.hasError) {
              return const GeneralErrorWidget();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          hasActiveFilter() ? Icons.filter_alt : Icons.filter_alt_outlined,
          color: gruen,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setStateDialog) {
                  return SimpleDialog(
                    title: const Text("Filter"),
                    backgroundColor: blau,
                    contentPadding: const EdgeInsets.all(10),
                    children: [
                      const ListTile(
                        title: Text("Tag"),
                      ),
                      ...availableTypes.map((e) => CheckboxListTile(
                            dense: true,
                            title: Text(e.labelShort, overflow: TextOverflow.ellipsis),
                            value: typeFilter[e],
                            onChanged: (value) {
                              setStateDialog(() {
                                typeFilter[e] = value ?? false;
                              });
                            },
                          )),
                      const Divider(),
                      const ListTile(
                        title: Text("Ort"),
                      ),
                      ...availableLocations.map((e) => CheckboxListTile(
                            dense: true,
                            title: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: locationFilter[e],
                            onChanged: (value) {
                              setStateDialog(() {
                                locationFilter[e] = value ?? false;
                              });
                            },
                          )),
                      FilledButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"))
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void filterData() {
    List<UnterhaltungTypeDTO> result = List.empty(growable: true);
    var filteredTypes = allData.where((element) => typeFilter[element.type] ?? false);
    for (var value in filteredTypes) {
      var filteredEntries = value.entries.where((element) => locationFilter[element.location.name] ?? false).toList();
      if (filteredEntries.isNotEmpty) {
        result.add(UnterhaltungTypeDTO(type: value.type, entries: filteredEntries));
      }
    }
    filterdData = result;
  }

  List<Widget> buildUnterhaltung() {
    List<Widget> result = List.empty(growable: true);
    for (var value in filterdData) {
      result.add(const Divider());
      result.add(ListTile(
          title: Text(
        value.type.label,
        style: const TextStyle(fontWeight: FontWeight.bold, color: gruen),
      )));
      result.add(const Divider());
      for (var entry in value.entries) {
        result.add(ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(entry.title, overflow: TextOverflow.ellipsis),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "${entry.start.substring(0, 5)}, ${entry.location.name}",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          onTap: () {
            // TODO
          },
          trailing: const Icon(
            // TODO conditional
            Icons.navigate_next_sharp,
          ),
        ));
      }
    }

    return result;
  }

  bool hasActiveFilter() {
    return typeFilter.entries.any((element) => !element.value) ||
        locationFilter.entries.any((element) => !element.value);
  }
}
