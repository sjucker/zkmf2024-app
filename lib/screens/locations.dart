import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  late Future<List<LocationDTO>> futureLocations;

  @override
  void initState() {
    super.initState();
    futureLocations = fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wettspiellokale'),
        ),
        body: Center(
          child: FutureBuilder<List<LocationDTO>>(
            future: futureLocations,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: TextButton(
                        onPressed: () {
                          context.go(
                              '/wettspiellokale/${snapshot.requireData[index].identifier}');
                        },
                        child: Text(
                          snapshot.requireData[index].name,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Color.fromARGB(255, 213, 215, 217),
                      height: 32,
                    );
                  },
                );
                return Text(snapshot.data!.length as String);
              } else if (snapshot.hasError) {
                return const GeneralErrorWidget();
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ));
  }
}
