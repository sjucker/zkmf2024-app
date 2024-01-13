import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  @override
  Widget build(BuildContext context) {
    {
      var changelog = DefaultAssetBundle.of(context).loadString('assets/CHANGELOG.md');
      return Scaffold(
        appBar: AppBar(
          title: const Text("Changelog"),
        ),
        body: FutureBuilder(
          future: changelog,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Markdown(
                data: snapshot.requireData,
              );
            } else if (snapshot.error != null) {
              return Text(snapshot.error!.toString());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    }
  }
}
