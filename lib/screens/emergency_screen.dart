import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:zkmf2024_app/dto/emergency_message.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  late Future<EmergencyMessageDTO> _message;

  @override
  void initState() {
    super.initState();
    _message = fetchEmergencyMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _message,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.requireData.header);
            } else {
              return const Text("");
            }
          },
        ),
        actions: homeAction(context),
      ),
      body: FutureBuilder<EmergencyMessageDTO>(
        future: _message,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Markdown(data: snapshot.requireData.message);
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
