import 'package:flutter/material.dart';
import 'package:zkmf2024_app/dto/festprogramm_day.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class FestprogrammScreen extends StatefulWidget {
  const FestprogrammScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FestprogrammScreenState();
}

class _FestprogrammScreenState extends State<FestprogrammScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Festprogramm"),
      ),
      body: FutureBuilder(
          future: fetchFestprogramm(),
          builder: (BuildContext context, AsyncSnapshot<List<FestprogrammDayDTO>> snapshot) {
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
