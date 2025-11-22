import 'dart:async';

import 'package:flutter/material.dart';

class TimeDifferenceWidget extends StatefulWidget {
  final DateTime dateTime;

  const TimeDifferenceWidget(this.dateTime, {super.key});

  @override
  State createState() => _TimeDifferenceWidgetState();
}

class _TimeDifferenceWidgetState extends State<TimeDifferenceWidget> {
  late Timer timer;
  String timeDifference = '';

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), _updateTimeDifference);
  }

  void _updateTimeDifference(Timer timer) {
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(widget.dateTime);

    if (difference.inDays > 0) {
      int days = difference.inDays;
      int hours = difference.inHours % 24;
      timeDifference = '$days D, $hours:${currentTime.minute}:${currentTime.second}';
    } else if (difference.inHours > 0) {
      int hours = difference.inHours;
      timeDifference = '$hours:${currentTime.minute}:${currentTime.second}';
    } else {
      timeDifference = '00:00:00';
    }

    setState(() {});
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        timeDifference,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}
