import 'package:flutter/material.dart';
import 'package:zkmf2024_app/dto/judge.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/cloudflare_image.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class JuryScreen extends StatefulWidget {
  const JuryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _JuryScreenState();
}

class _JuryScreenState extends State<JuryScreen> {
  late Future<List<JudgeDTO>> _judges;

  @override
  void initState() {
    super.initState();
    _judges = fetchJudges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jurymitglieder"),
      ),
      body: Center(
        child: FutureBuilder<List<JudgeDTO>>(
          future: _judges,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: snapshot.requireData
                      .map((e) => Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 120.0,
                                  height: 120.0,
                                  child: CloudflareImage(
                                    cloudflareId: e.cloudflareId,
                                    paddingOuter: EdgeInsets.zero,
                                    paddingInner: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    e.modul,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                            ],
                          ))
                      .toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return const GeneralErrorWidget();
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
