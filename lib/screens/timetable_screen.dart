import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/dto/timetable_overview.dart';
import 'package:zkmf2024_app/dto/timetable_overview_entry.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/filter_dialog.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late Future<List<TimetableDayOverviewDTO>> _timetable;

  Map<String, bool> dayFilter = {};
  List<String> availableDays = [];

  Map<String, bool> locationFilter = {};
  List<String> availableLocations = [];

  Map<String, bool> competitionFilter = {};
  List<String> availableCompetitions = [];

  bool favoriteOnlyFilter = false;

  @override
  void initState() {
    super.initState();
    _timetable = fetchTimetable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spielplan'),
        actions: homeAction(context),
      ),
      body: Center(
        child: FutureBuilder<List<TimetableDayOverviewDTO>>(
          future: _timetable,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              initFilters(snapshot.requireData);
              var data = _filterAndTransform(snapshot.requireData);

              List<Widget> widgets = [];
              for (var day in data.days) {
                widgets.add(Text(
                  day,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ));

                for (var location in _locations(day, data)) {
                  widgets.add(ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(
                      location.name,
                      style: const TextStyle(color: gruen),
                    ),
                    onTap: () {
                      context.push('/wettspiellokale/${location.identifier}');
                    },
                  ));

                  for (var entry in _entries(day, location.id, data)) {
                    widgets.add(ListTile(
                      trailing: const Icon(
                        Icons.navigate_next_sharp,
                        color: Colors.white,
                      ),
                      dense: true,
                      title: Text(entry.vereinsname),
                      subtitle: Text("${day.substring(0, 4)} ${entry.time}"),
                      onTap: () {
                        context.push('/vereine/${entry.vereinIdentifier}');
                      },
                    ));
                  }
                }
                widgets.add(const Divider());
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: widgets,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const GeneralErrorWidget();
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
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
                  FilterCategory("Modul", availableCompetitions, competitionFilter)
                ],
                callback: () {
                  setState(() {});
                },
              );
            },
          );
        },
      ),
    );
  }

  void initFilters(List<TimetableDayOverviewDTO> requireData) {
    if (availableDays.isEmpty) {
      availableDays = requireData.map((e) => e.day).toList();
      dayFilter = {for (var element in availableDays) element: true};
    }

    if (availableLocations.isEmpty) {
      availableLocations =
          requireData.expand((element) => element.entries.map((e) => e.location.name)).toSet().toList();
      availableLocations.sort((a, b) => a.compareTo(b));
      locationFilter = {for (var element in availableLocations) element: true};
    }

    if (availableCompetitions.isEmpty) {
      availableCompetitions =
          requireData.expand((element) => element.entries.map((e) => e.competition)).toSet().toList();
      availableCompetitions.sort((a, b) => a.compareTo(b));
      competitionFilter = {for (var element in availableCompetitions) element: true};
    }
  }

  _TimetableDayOverviewData _filterAndTransform(List<TimetableDayOverviewDTO> requireData) {
    List<String> days = List.empty(growable: true);

    var entriesPerDayAndLocation = <String, Map<int, List<TimetableOverviewEntryDTO>>>{};
    var availableLocations = <int, LocationDTO>{};

    for (var v in requireData) {
      if (dayFilter[v.day] ?? false) {
        var perDay = entriesPerDayAndLocation.putIfAbsent(v.day, () => <int, List<TimetableOverviewEntryDTO>>{});
        for (var entry in v.entries) {
          if ((locationFilter[entry.location.name] ?? false) && (competitionFilter[entry.competition] ?? false)) {
            perDay.putIfAbsent(entry.location.id, () => []).add(entry);
            availableLocations[entry.location.id] = entry.location;
            days.add(v.day);
          }
        }
      }
    }

    return _TimetableDayOverviewData(
        days: days.toSet().toList(),
        entriesPerDayAndLocation: entriesPerDayAndLocation,
        availableLocations: availableLocations);
  }

  List<LocationDTO> _locations(String day, _TimetableDayOverviewData data) {
    var locations = data.entriesPerDayAndLocation[day]!.keys.map((e) => data.availableLocations[e]!).toList();
    locations.sort(
      (a, b) => a.sortOrder - b.sortOrder,
    );
    return locations;
  }

  List<TimetableOverviewEntryDTO> _entries(String day, int locationId, _TimetableDayOverviewData data) {
    return data.entriesPerDayAndLocation[day]![locationId]!;
  }

  bool hasActiveFilter() {
    return dayFilter.entries.any((element) => !element.value) ||
        locationFilter.entries.any((element) => !element.value) ||
        competitionFilter.entries.any((element) => !element.value);
  }
}

class _TimetableDayOverviewData {
  final List<String> days;
  final Map<String, Map<int, List<TimetableOverviewEntryDTO>>> entriesPerDayAndLocation;
  final Map<int, LocationDTO> availableLocations;

  _TimetableDayOverviewData(
      {required this.days, required this.entriesPerDayAndLocation, required this.availableLocations});
}
