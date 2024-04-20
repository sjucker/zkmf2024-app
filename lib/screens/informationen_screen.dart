import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class InformationenScreen extends StatelessWidget {
  const InformationenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informationen'),
        actions: homeAction(context),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.map_outlined),
            trailing: const Icon(
              Icons.navigate_next_sharp,
            ),
            onTap: () {
              context.push('/karte');
            },
            title: const Text("Karte Festareal"),
          ),
          ListTile(
            leading: const Icon(Icons.house_outlined),
            trailing: const Icon(
              Icons.navigate_next_sharp,
            ),
            onTap: () {
              context.push('/wettspiellokale');
            },
            title: const Text("Wettspiellokale"),
          ),
          ListTile(
            leading: const Icon(Icons.scoreboard_outlined),
            trailing: const Icon(
              Icons.navigate_next_sharp,
            ),
            onTap: () {
              context.push('/jurymitglieder');
            },
            title: const Text("Jurymitglieder"),
          ),
          ListTile(
            leading: const Icon(Icons.copyright_outlined),
            trailing: const Icon(
              Icons.navigate_next_sharp,
            ),
            onTap: () {
              context.push('/impressum');
            },
            title: const Text("Impressum"),
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.facebook,
              color: gruen,
            ),
            onTap: () {
              launchUrl(
                Uri.parse('https://www.facebook.com/zkmf2024'),
                mode: LaunchMode.externalApplication,
              );
            },
            title: const Text("Facebook"),
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.instagram,
              color: gruen,
            ),
            onTap: () {
              launchUrl(
                Uri.parse('https://www.instagram.com/zkmf2024'),
                mode: LaunchMode.externalApplication,
              );
            },
            title: const Text("Instagram"),
          ),
        ],
      ),
    );
  }
}
