import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/ranking_list.dart';
import 'package:zkmf2024_app/dto/ranking_list_entry.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class RankingScreen extends StatefulWidget {
  final int id;

  const RankingScreen({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final box = GetStorage();

  late Future<RankingListDTO> _ranking;
  late String? _selectedVerein;

  @override
  void initState() {
    super.initState();
    _ranking = fetchRanking(widget.id);
    _selectedVerein = box.read(selectedVereinKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rangliste'),
        actions: homeAction(context),
      ),
      body: FutureBuilder<RankingListDTO>(
        future: _ranking,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var requireData = snapshot.requireData;
            return ListView.separated(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      title: Text(
                        requireData.description,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: gruen),
                      ),
                      subtitle: requireData.status == "INTERMEDIATE" ? const Text("Zwischenrangliste") : Container(),
                    );
                  }
                  var entry = requireData.entries[index - 1];
                  return ListTile(
                    leading: Text(
                      entry.rank.toString(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: getColor(entry)),
                    ),
                    title: Text(entry.vereinsName, style: TextStyle(fontSize: 16, color: getColor(entry))),
                    subtitle: entry.additionalInfo != null ? Text(entry.additionalInfo!) : Container(),
                    trailing:
                        Text(entry.score.toStringAsFixed(2), style: TextStyle(fontSize: 16, color: getColor(entry))),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: silber,
                  );
                },
                // header row
                itemCount: requireData.entries.length + 1);
          } else if (snapshot.hasError) {
            return const GeneralErrorWidget();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Color getColor(RankingListEntryDTO entry) => entry.vereinIdentifier == _selectedVerein ? gelb : Colors.white;
}
