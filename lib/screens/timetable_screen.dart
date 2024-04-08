import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/dto/timetable_overview.dart';
import 'package:zkmf2024_app/dto/timetable_overview_entry.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

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
        title: const Text('Zeitplan'),
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

            // By default, show a loading spinner.
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
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setStateDialog) {
                  return SimpleDialog(
                    title: const Text("Filter"),
                    backgroundColor: blau,
                    contentPadding: const EdgeInsets.all(10.0),
                    children: [
                      const ListTile(
                        title: Text("Tag"),
                      ),
                      ...availableDays.map((e) => CheckboxListTile(
                            value: dayFilter[e],
                            onChanged: (value) {
                              setStateDialog(() {
                                dayFilter[e] = value ?? false;
                              });
                            },
                            dense: true,
                            title: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                      const Divider(),
                      const ListTile(
                        title: Text("Modul"),
                      ),
                      ...availableCompetitions.map((e) => CheckboxListTile(
                            dense: true,
                            title: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: competitionFilter[e],
                            onChanged: (value) {
                              setStateDialog(() {
                                competitionFilter[e] = value ?? false;
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
