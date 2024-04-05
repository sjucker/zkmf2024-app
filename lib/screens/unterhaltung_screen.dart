import 'package:flutter/material.dart';
import 'package:zkmf2024_app/dto/unterhaltung_type.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class UnterhaltungScreen extends StatefulWidget {
  const UnterhaltungScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UnterhaltungScreenState();
}

class _UnterhaltungScreenState extends State<UnterhaltungScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unterhaltungsprogramm"),
      ),
      body: FutureBuilder(
          future: fetchUnterhaltung(),
          builder: (BuildContext context, AsyncSnapshot<List<UnterhaltungTypeDTO>> snapshot) {
            if (snapshot.hasData) {
              var requireData = snapshot.requireData;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // TODO
                    Text(requireData.length.toString())
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const GeneralErrorWidget();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
