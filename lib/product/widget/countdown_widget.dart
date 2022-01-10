import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class CountDownTimerWidget extends StatelessWidget {
  final CountdownTimerController? controller;
  final String explictTime = 'Sms password enter time:';

  const CountDownTimerWidget({Key? key, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      controller: controller,
      widgetBuilder: (_, CurrentRemainingTime? time) {
        return Text(
          "$explictTime ${time?.min ?? '0'}: ${time?.sec ?? '0'}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        );
      },
    );
  }
}
