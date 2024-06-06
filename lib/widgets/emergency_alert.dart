import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/service/backend_service.dart';

class EmergencyAlert extends StatefulWidget {
  const EmergencyAlert({super.key});

  @override
  State<StatefulWidget> createState() => _EmergencyAlertState();
}

class _EmergencyAlertState extends State<EmergencyAlert> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }

  Future<bool> _hasEmergencyMessage() async {
    return hasEmergencyMessage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _hasEmergencyMessage(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.requireData) {
          return Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  context.push('/emergency');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(rot),
                ),
                child: const Text(
                  "WICHTIGE NACHRICHT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ));
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}
