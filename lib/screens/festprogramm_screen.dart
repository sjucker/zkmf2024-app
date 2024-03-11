import 'package:flutter/material.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/festprogramm_day.dart';
import 'package:zkmf2024_app/dto/festprogramm_entry.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/filter_dialog.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class FestprogrammScreen extends StatefulWidget {
  const FestprogrammScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FestprogrammScreenState();
}

class _FestprogrammScreenState extends State<FestprogrammScreen> {
  Map<String, bool> dayFilter = {};
  List<String> availableDays = [];

  Map<String, bool> locationFilter = {};
  List<String> availableLocations = [];

  List<FestprogrammDayDTO> allData = [];
  List<FestprogrammDayDTO> filterdData = [];

  late Future<List<FestprogrammDayDTO>> _festprogramm;

  @override
  void initState() {
    super.initState();
    _festprogramm = fetchFestprogramm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Festprogramm"),
        ),
        body: FutureBuilder(
            future: _festprogramm,
            builder: (BuildContext context, AsyncSnapshot<List<FestprogrammDayDTO>> snapshot) {
              if (snapshot.hasData) {
                allData = snapshot.requireData;
                if (availableDays.isEmpty) {
                  availableDays = allData.map((e) => e.day).toList();
                  dayFilter = {for (var element in availableDays) element: true};
                }
                if (availableLocations.isEmpty) {
                  availableLocations = allData.expand((e) => e.entries.map((e) => e.location)).toSet().toList();
                  availableLocations.sort((a, b) => a.compareTo(b));
                  locationFilter = {for (var element in availableLocations) element: true};
                }
                filterData();

                return SingleChildScrollView(
                  child: Column(
                    children: buildFestprogramm(),
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
                  },
                );
              },
            );
          },
        ));
  }

  List<Widget> buildFestprogramm() {
    List<Widget> result = List.empty(growable: true);
    for (var value in filterdData) {
      result.add(const Divider());
      result.add(ListTile(
          title: Text(
        value.day,
        style: const TextStyle(fontWeight: FontWeight.bold, color: gruen),
      )));
      result.add(const Divider());
      for (var entry in value.entries) {
        result.add(ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              entry.description,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "${getTime(entry)}, ${entry.location}",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
      }
    }

    return result;
  }

  String getTime(FestprogrammEntryDTO entry) {
    if (entry.timeTo != null) {
      return "${entry.timeFrom}${entry.timeTo}";
    } else {
      return entry.timeFrom;
    }
  }

  void filterData() {
    List<FestprogrammDayDTO> result = List.empty(growable: true);
    var filteredDays = allData.where((element) => dayFilter[element.day] ?? false);
    for (var v in filteredDays) {
      var filteredEntries = v.entries.where((element) => locationFilter[element.location] ?? false).toList();
      if (filteredEntries.isNotEmpty) {
        result.add(FestprogrammDayDTO(day: v.day, entries: filteredEntries));
      }
    }
    filterdData = result;
  }

  bool hasActiveFilter() {
    return dayFilter.entries.any((element) => !element.value) ||
        locationFilter.entries.any((element) => !element.value);
  }
}
