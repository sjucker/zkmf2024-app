import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/dto/ranking_list.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RankingsScreen();
}

class _RankingsScreen extends State<RankingsScreen> {
  late Future<List<RankingListDTO>> _rankings;

  @override
  void initState() {
    super.initState();
    _rankings = fetchRankings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranglisten"),
        actions: homeAction(context),
      ),
      body: FutureBuilder(
        future: _rankings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  var requireData = snapshot.requireData[index];
                  return ListTile(
                    title: Text(requireData.getDescription()),
                    subtitle: Text(requireData.location.name),
                    trailing: const Icon(
                      Icons.navigate_next_sharp,
                      color: Colors.white,
                    ),
                    onTap: () {
                      context.push('/ranglisten/${requireData.id}');
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemCount: snapshot.requireData.length);
          } else if (snapshot.hasError) {
            return const GeneralErrorWidget();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
