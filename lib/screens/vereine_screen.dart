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
              return Column(
                children: [
                  // TODO add search field
                  Expanded(
                    child: ListView.separated(
                      itemCount: snapshot.requireData.length,
                      itemBuilder: (BuildContext context, int index) {
                        var requireData = snapshot.requireData[index];
                        return ListTile(
                          leading: FavoriteButton(
                            identifier: requireData.identifier,
                            valueChanged: (v) {
                              // TODO write to backend
                              // TODO schedule some notifications
                            },
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

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
