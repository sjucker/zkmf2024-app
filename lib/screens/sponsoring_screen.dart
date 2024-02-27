import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

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
      body: Center(
          child: ResponsiveGridRow(children: [
        ResponsiveGridCol(xs: 6, sm: 3, md: 6, lg: 3, child: Container(child: const Text("1"))),
        ResponsiveGridCol(xs: 6, sm: 3, md: 6, lg: 3, child: Container(child: const Text("2"))),
        ResponsiveGridCol(xs: 6, sm: 3, md: 6, lg: 3, child: Container(child: const Text("3"))),
      ])),
    );
  }
}
