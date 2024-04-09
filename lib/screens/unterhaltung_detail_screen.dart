import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zkmf2024_app/dto/unterhaltung_entry.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/cloudflare_image.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/location_tile.dart';
import 'package:zkmf2024_app/widgets/random_sponsor.dart';

class UnterhaltungDetailScreen extends StatefulWidget {
  final String identifier;

  const UnterhaltungDetailScreen({super.key, required this.identifier});

  @override
  State<StatefulWidget> createState() => _UnterhaltungDetailScreenState();
}

class _UnterhaltungDetailScreenState extends State<UnterhaltungDetailScreen> {
  late Future<UnterhaltungsEntryDTO> _entry;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _entry = fetchUnterhaltungDetail(widget.identifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _entry,
          builder: (context, snapshot) {
            return const Text("Info");
          },
        ),
      ),
      body: FutureBuilder<UnterhaltungsEntryDTO>(
        future: _entry,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var requireData = snapshot.requireData;

            return SingleChildScrollView(
              child: Column(
                children: buildContent(requireData),
              ),
            );
          } else if (snapshot.hasError) {
            return const GeneralErrorWidget();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  List<Widget> buildContent(UnterhaltungsEntryDTO entry) {
    return [
      CloudflareImage(
        cloudflareId: entry.cloudflareId,
        paddingOuter: EdgeInsets.zero,
        paddingInner: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
      ),
      ListTile(
        title: Text(
          entry.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.access_time),
        title: Text('${entry.type.labelShort}, ${entry.start.substring(0, 5)}'),
      ),
      LocationTileWidget(entry.location),
      ListTile(
        title: Text(
          entry.text ?? '',
        ),
      ),
      const RandomSponsor(),
    ];
  }
}
