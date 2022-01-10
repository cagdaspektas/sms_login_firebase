import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShowAlertDialog extends StatelessWidget {
  final String? alertText;
  final String? alertCancelText;
  final String? alertOkText;
  final void Function()? cancelButton;
  final void Function()? okButton;

  const ShowAlertDialog(
      {Key? key, this.alertText, this.alertCancelText, this.alertOkText, this.cancelButton, this.okButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        alertText ?? '',
        style: const TextStyle(fontSize: 24),
      ),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                child: Text(
                  alertCancelText ?? '',
                  style: const TextStyle(fontSize: 24),
                ),
                onPressed: cancelButton),
            TextButton(
              child: Text(
                alertOkText ?? '',
                style: const TextStyle(fontSize: 24),
              ),
              onPressed: okButton,
            ),
          ],
        ),
      ],
    );
  }
}
