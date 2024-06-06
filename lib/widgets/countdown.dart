import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:zkmf2024_app/constants.dart';

class Countdown extends StatefulWidget {
  final DateTime start;

  const Countdown({super.key, required this.start});

  @override
  State<StatefulWidget> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? timer;
  bool finished = false;
  int days = 0;
  int hours = 0;
  int minutes = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      tick(timer);
      setState(() {});
    });
    tick(timer);
  }

  void tick(Timer? timer) {
    var now = DateTime.now();
    if (now.isAfter(widget.start)) {
      finished = true;
      days = 0;
      hours = 0;
      minutes = 0;
      timer?.cancel();
    } else {
      var secondsLeft = (widget.start.millisecondsSinceEpoch - now.millisecondsSinceEpoch) / 1000;
      finished = false;
      days = (secondsLeft / 86400).toInt();
      hours = ((secondsLeft - (86400 * days)) / 3600).toInt();
      minutes = ((secondsLeft - (86400 * days) - (3600 * hours)) / 60).toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Container();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
            child: Column(
              children: [
                numberBlocks(days),
                const Text(
                  "Tage",
                  style: TextStyle(fontSize: 11),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
            child: Column(
              children: [numberBlocks(hours), const Text("Std", style: TextStyle(fontSize: 11))],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
            child: Column(
              children: [numberBlocks(minutes), const Text("Min", style: TextStyle(fontSize: 11))],
            ),
          ),
        ],
      );
    }
  }

  Widget numberBlocks(int number) {
    int first = number < 10 ? 0 : number ~/ 10;
    int second = number % 10;
    return Row(
      children: [
        numberBlock(first),
        numberBlock(second),
      ],
    );
  }

  Widget numberBlock(int number) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Container(
        alignment: Alignment.center,
        width: 20,
        decoration: const BoxDecoration(color: rot),
        child: Text(
          number.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}
