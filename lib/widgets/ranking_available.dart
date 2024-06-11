import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/service/backend_service.dart';

class RankingAvailable extends StatefulWidget {
  const RankingAvailable({super.key});

  @override
  State<StatefulWidget> createState() => _RankingAvailableState();
}

class _RankingAvailableState extends State<RankingAvailable> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: hasRankings(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.requireData) {
          return Padding(
              padding: const EdgeInsets.all(4),
              child: TextButton(
                onPressed: () {
                  context.push('/ranglisten');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(gruen),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Text(
                    "zu den Ranglisten",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ));
        } else {
          return Container();
        }
      },
    );
  }
}
