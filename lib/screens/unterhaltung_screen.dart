import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/unterhaltung_type.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/filter_dialog.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class UnterhaltungScreen extends StatefulWidget {
  const UnterhaltungScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UnterhaltungScreenState();
}

class _UnterhaltungScreenState extends State<UnterhaltungScreen> {
  Map<String, bool> dayFilter = {
    for (var element in UnterhaltungEntryType.values.map((e) => e.labelShort)) element: true
  };
  List<String> availableDays = UnterhaltungEntryType.values.map((e) => e.labelShort).toList();

  Map<String, bool> locationFilter = {};
  List<String> availableLocations = [];

  List<UnterhaltungTypeDTO> allData = [];
  List<UnterhaltungTypeDTO> filteredData = [];

  final Future<List<UnterhaltungTypeDTO>> unterhaltung = fetchUnterhaltung();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unterhaltungsprogramm"),
        actions: homeAction(context),
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
            barrierDismissible: false,
            builder: (context) {
              return FilterDialog(
                  categories: [
                    FilterCategory("Tag", availableDays, dayFilter),
                    FilterCategory("Ort", availableLocations, locationFilter),
                  ],
                  callback: () {
                    setState(() {});
                  });
            },
          );
        },
      ),
    );
  }

  void filterData() {
    List<UnterhaltungTypeDTO> result = List.empty(growable: true);
    var filteredTypes = allData.where((element) => dayFilter[element.type.labelShort] ?? false);
    for (var value in filteredTypes) {
      var filteredEntries = value.entries.where((element) => locationFilter[element.location.name] ?? false).toList();
      if (filteredEntries.isNotEmpty) {
        result.add(UnterhaltungTypeDTO(type: value.type, entries: filteredEntries));
      }
    }
    filteredData = result;
  }

  List<Widget> buildUnterhaltung() {
    List<Widget> result = List.empty(growable: true);
    for (var value in filteredData) {
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
            if (entry.vereinIdentifier != null) {
              context.push('/vereine/${entry.vereinIdentifier}');
            } else if (entry.unterhaltungIdentifier != null) {
              context.push('/unterhaltung/${entry.unterhaltungIdentifier}');
            }
          },
          trailing: entry.vereinIdentifier != null || entry.unterhaltungIdentifier != null
              ? const Icon(
                  Icons.navigate_next_sharp,
                )
              : null,
        ));
      }
    }

    return result;
  }

  bool hasActiveFilter() {
    return dayFilter.entries.any((element) => !element.value) ||
        locationFilter.entries.any((element) => !element.value);
  }
}
