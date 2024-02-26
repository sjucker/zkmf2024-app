import 'package:flutter/material.dart';

class SponsoringScreen extends StatefulWidget {
  const SponsoringScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SponsoringScreenState();
}

class _SponsoringScreenState extends State<SponsoringScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sponsoring"),
      ),
      body: const Center(child: Text("Sponsoring")),
    );
  }
}
