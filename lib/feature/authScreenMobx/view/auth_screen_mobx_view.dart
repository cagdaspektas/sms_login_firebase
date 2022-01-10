import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/constants/text_enum.dart';
import '../../../core/constants/text_values.dart';
import '../../../core/model/base_view.dart';
import '../../../product/widget/countdown_widget.dart';
import '../viewModel/auth_screen_view_model.dart';

class AuthScreenViewMobx extends StatelessWidget {
  static const double _ltbPadding = 16;
  static const double _sizedHeight = 12;
  static const int _flex = 2;

  const AuthScreenViewMobx({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthScreenViewModel>(
      model: AuthScreenViewModel(),
      onModelReady: (model) {
        model.setContext(context);
        model.init();
      },
      builder: (BuildContext context, AuthScreenViewModel model) {
        return Scaffold(
            appBar: _appBar(model),
            body: Observer(
              builder: (_) {
                return ListView(
                  padding: const EdgeInsets.all(_ltbPadding),
                  children: <Widget>[
                    const SizedBox(height: _sizedHeight),
                    Row(
                      children: <Widget>[
                        _phoneTextForm(model),
                        const Spacer(),
                        _submitPhone(model, context),
                      ],
                    ),
                    const SizedBox(height: _sizedHeight),
                    model.isSubmit
                        ? CountDownTimerWidget(
                            controller: model.controler,
                          )
                        : const SizedBox(),
                    model.isSubmit
                        ? Row(
                            children: <Widget>[
                              _smsTextForm(model),
                              const Spacer(),
                              _submitOtp(model, context),
                            ],
                          )
                        : const SizedBox(),
                    Text(model.status),
                    _logOut(model, context),
                  ],
                );
              },
            ));
      },
    );
  }

  Expanded _phoneTextForm(AuthScreenViewModel model) {
    return Expanded(
      flex: _flex,
      child: TextField(
        controller: model.phoneNumberController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: TextEnum.phoneNumber.rawValue(),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Expanded _submitPhone(AuthScreenViewModel model, BuildContext context) {
    return Expanded(
        flex: 1,
        child: MaterialButton(
          onPressed: () {
            model.submitPhoneNumber();
            model.isSubmit = true;
            model.countDown();
          },
          child: Text(TextEnum.approve.rawValue()),
          color: Theme.of(context).primaryColor,
        ));
  }

  Expanded _smsTextForm(AuthScreenViewModel model) {
    return Expanded(
      flex: 2,
      child: TextField(
        controller: model.otpController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: TextEnum.smsCode.rawValue(),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Expanded _submitOtp(AuthScreenViewModel model, BuildContext context) {
    return Expanded(
      flex: 1,
      child: MaterialButton(
        onPressed: () {
          model.submitOTP();
        },
        child: Text(TextEnum.approve.rawValue()),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  MaterialButton _logOut(AuthScreenViewModel model, BuildContext context) {
    return MaterialButton(
      onPressed: () {
        model.logout();
      },
      child: Text(TextEnum.logOut.rawValue()),
      color: Theme.of(context).primaryColor,
    );
  }

  AppBar _appBar(AuthScreenViewModel model) {
    return AppBar(
      title: Text(TextEnum.phoneAuth.rawValue()),
      actions: [
        GestureDetector(
          child: const Icon(Icons.refresh),
          onTap: model.reset,
        ),
      ],
    );
  }
}
