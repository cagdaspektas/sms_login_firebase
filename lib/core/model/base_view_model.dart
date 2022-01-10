import 'package:flutter/material.dart';

abstract class BaseViewModel {
  late BuildContext context;

  void setContext(BuildContext context);
  void init();

  void addPostFrameCallBack(VoidCallback onComplete) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      onComplete();
    });
  }
}
