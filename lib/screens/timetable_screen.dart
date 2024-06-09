import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/dto/timetable_overview.dart';
import 'package:zkmf2024_app/dto/timetable_overview_entry.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/filter_dialog.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/random_sponsor.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final box = GetStorage();

  late Future<List<TimetableDayOverviewDTO>> _timetable;
  late String? _selectedVerein;

  Map<String, bool> dayFilter = {};
  List<String> availableDays = [];

  Map<String, bool> locationFilter = {};
  List<String> availableLocations = [];

  Map<String, bool> modulFilter = {};
  List<String> availableModule = [];

  Map<String, bool> klasseFilter = {};
  List<String> availableKlassen = [];

  Map<String, bool> besetzungFilter = {};
  List<String> availableBesetzungen = [];

  List<bool> favoritesOnly = [false];
  List<bool>? includeInPast = [false];

  @override
  void initState() {
    super.initState();
    _timetable = fetchTimetable();
    _selectedVerein = box.read(selectedVereinKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spielplan'),
        actions: homeAction(context),
      ),
      body: FutureBuilder<List<TimetableDayOverviewDTO>>(
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
                    trailing: Icon(
                      Icons.navigate_next_sharp,
                      color: isSelectedVerein(entry) ? gelb : Colors.white,
                    ),
                    dense: true,
                    title: Text(
                      entry.vereinsname,
                      style: TextStyle(
                          color: isSelectedVerein(entry) ? gelb : Colors.white,
                          fontWeight: isSelectedVerein(entry) ? FontWeight.bold : FontWeight.normal),
                    ),
                    subtitle: Text("${day.substring(0, 4)} ${entry.time}",
                        style: TextStyle(
                            color: isSelectedVerein(entry) ? gelb : Colors.white,
                            fontWeight: isSelectedVerein(entry) ? FontWeight.bold : FontWeight.normal)),
                    onTap: () {
                      context.push('/vereine/${entry.vereinIdentifier}');
                    },
                  ));
                }
              }
              widgets.add(const RandomSponsor());
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

          return const Center(child: CircularProgressIndicator());
        },
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
                  FilterCategory("Modul", availableModule, modulFilter),
                  FilterCategory("Klasse", availableKlassen, klasseFilter),
                  FilterCategory("Besetzung", availableBesetzungen, besetzungFilter),
                ],
                callback: () {
                  setState(() {});
                },
                favoritesOnly: favoritesOnly,
                includeInPast: includeInPast,
              );
            },
          );
        },
      ),
    );
  }

  bool isSelectedVerein(TimetableOverviewEntryDTO entry) => entry.vereinIdentifier == _selectedVerein;

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

    if (availableModule.isEmpty) {
      availableModule = requireData.expand((element) => element.entries.map((e) => e.modul)).toSet().toList();
      availableModule.sort((a, b) => a.compareTo(b));
      modulFilter = {for (var element in availableModule) element: true};
    }

    if (availableKlassen.isEmpty) {
      availableKlassen =
          requireData.expand((element) => element.entries.map((e) => e.klasse)).nonNulls.toSet().toList();
      availableKlassen.sort((a, b) => a.compareTo(b));
      klasseFilter = {for (var element in availableKlassen) element: true};
    }

    if (availableBesetzungen.isEmpty) {
      availableBesetzungen =
          requireData.expand((element) => element.entries.map((e) => e.besetzung)).nonNulls.toSet().toList();
      availableBesetzungen.sort((a, b) => a.compareTo(b));
      besetzungFilter = {for (var element in availableBesetzungen) element: true};
    }

    includeInPast = requireData.any((element) => element.entries.any((e) => e.inPast)) ? [false] : null;
  }

  _TimetableDayOverviewData _filterAndTransform(List<TimetableDayOverviewDTO> requireData) {
    List<String> days = List.empty(growable: true);

    var entriesPerDayAndLocation = <String, Map<int, List<TimetableOverviewEntryDTO>>>{};
    var availableLocations = <int, LocationDTO>{};

    for (var v in requireData) {
      if (dayFilter[v.day] ?? false) {
        var perDay = entriesPerDayAndLocation.putIfAbsent(v.day, () => <int, List<TimetableOverviewEntryDTO>>{});
        for (var entry in v.entries) {
          if ((locationFilter[entry.location.name] ?? false) &&
              (modulFilter[entry.modul] ?? false) &&
              (filterKlasse(entry)) &&
              (filterBesetzung(entry))) {
            if (!favoritesOnly.first || (box.read('favorite-${entry.vereinIdentifier}') ?? false)) {
              perDay.putIfAbsent(entry.location.id, () => []).add(entry);
              availableLocations[entry.location.id] = entry.location;
              days.add(v.day);
            }
          }
        }
      }
    }

    return _TimetableDayOverviewData(
        days: days.toSet().toList(),
        entriesPerDayAndLocation: entriesPerDayAndLocation,
        availableLocations: availableLocations);
  }

  bool filterKlasse(TimetableOverviewEntryDTO entry) {
    if (entry.klasse != null) {
      return klasseFilter[entry.klasse] ?? false;
    } else {
      // do not display entry if Klasse-filter is active
      return klasseFilter.entries.every((element) => element.value);
    }
  }

  bool filterBesetzung(TimetableOverviewEntryDTO entry) {
    if (entry.besetzung != null) {
      return besetzungFilter[entry.besetzung] ?? false;
    } else {
      // do not display entry if Besetzung-filter is active
      return besetzungFilter.entries.every((element) => element.value);
    }
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
        modulFilter.entries.any((element) => !element.value) ||
        klasseFilter.entries.any((element) => !element.value) ||
        besetzungFilter.entries.any((element) => !element.value) ||
        favoritesOnly.first ||
        (includeInPast?.first ?? false);
  }
}

class _TimetableDayOverviewData {
  final List<String> days;
  final Map<String, Map<int, List<TimetableOverviewEntryDTO>>> entriesPerDayAndLocation;
  final Map<int, LocationDTO> availableLocations;

  _TimetableDayOverviewData(
      {required this.days, required this.entriesPerDayAndLocation, required this.availableLocations});
}
