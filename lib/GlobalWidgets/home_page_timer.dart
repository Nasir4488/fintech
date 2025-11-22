import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import 'package:fin_tech/Services/api_services.dart';
import 'package:fin_tech/Services/api_url.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  DateTime targetDate = DateTime.parse("2024-09-13 17:11:00.000000");

  @override
  void initState() {
    ApiServices.getMethod(APiUrls.AIR_DROP).then((response) {
      if (response == null) return;
      final jd = json.decode(response);
      targetDate = DateTime.parse(jd['data'] ?? "2024-09-13 17:11:00.000000");
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      DateTime now = DateTime.now();
      Duration remainingTime = targetDate.isAfter(now) ? targetDate.difference(now) : Duration.zero;

      if (remainingTime.inSeconds <= 0) {
        timer.cancel();
        if (kDebugMode) print("Timer expired! The target date has been reached.");
      } else {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Duration remainingTime = targetDate.difference(now);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "VRC Supply Reduction( 20% )",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: textColor, fontWeight: FontWeight.w700),
        ).paddingOnly(bottom: 5, left: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).cardColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (remainingTime.inDays > 0) buildDigitContainer("Days", remainingTime.inDays),
              if (remainingTime.inHours > 0)
                buildDigitContainer("Hours", remainingTime.inHours.remainder(24)),
              if (remainingTime.inMinutes > 0)
                buildDigitContainer("Minutes", remainingTime.inMinutes.remainder(60)),
              if (remainingTime.inSeconds > 0)
                buildDigitContainer("Seconds", remainingTime.inSeconds.remainder(60)),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDigitContainer(String label, int value) {
    String formattedValue = value < 10 ? '0$value' : '$value';
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontSize: MediaQuery.of(context).size.width * .05),
        ),
        const SizedBox(width: 5.0),
        Text(
          formattedValue,
          style: context.textTheme.titleSmall
              ?.copyWith(color: textColor, fontSize: MediaQuery.of(context).size.width * .05),
        ),
      ],
    ).paddingAll(5);
  }
}
