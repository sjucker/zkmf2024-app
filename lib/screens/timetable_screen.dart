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
              // TODO add search

              var data = _transform(snapshot);

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
    );
  }

  _TimetableDayOverviewData _transform(AsyncSnapshot<List<TimetableDayOverviewDTO>> snapshot) {
    var days = snapshot.requireData.map((e) => e.day).toList();

    var entriesPerDayAndLocation = <String, Map<int, List<TimetableOverviewEntryDTO>>>{};
    var availableLocations = <int, LocationDTO>{};

    for (var v in snapshot.requireData) {
      var perDay = entriesPerDayAndLocation.putIfAbsent(v.day, () => <int, List<TimetableOverviewEntryDTO>>{});
      for (var entry in v.entries) {
        perDay.putIfAbsent(entry.location.id, () => []).add(entry);
        availableLocations[entry.location.id] = entry.location;
      }
    }

    return _TimetableDayOverviewData(
        days: days, entriesPerDayAndLocation: entriesPerDayAndLocation, availableLocations: availableLocations);
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
}

class _TimetableDayOverviewData {
  final List<String> days;
  final Map<String, Map<int, List<TimetableOverviewEntryDTO>>> entriesPerDayAndLocation;
  final Map<int, LocationDTO> availableLocations;

  _TimetableDayOverviewData(
      {required this.days, required this.entriesPerDayAndLocation, required this.availableLocations});
}
