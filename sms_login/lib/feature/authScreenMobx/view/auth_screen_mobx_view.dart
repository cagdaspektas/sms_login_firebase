import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sms_login/core/model/base_view.dart';
import 'package:sms_login/feature/authScreenMobx/viewModel/auth_screen_view_model.dart';
import 'package:sms_login/product/widget/countdown_widget.dart';

class AuthScreenViewMobx extends StatelessWidget {
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
            appBar: AppBar(
              title: Text('Phone Auth'),
              actions: [
                GestureDetector(
                  child: Icon(Icons.refresh),
                  onTap: model.reset,
                ),
              ],
            ),
            body: Observer(
              builder: (_) {
                return ListView(
                  padding: EdgeInsets.all(16),
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: model.phoneNumberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                            flex: 1,
                            child: MaterialButton(
                              onPressed: () {
                                model.submitPhoneNumber();
                                model.isSubmit = true;
                                model.countDown();
                              },
                              child: Text('Submit'),
                              color: Theme.of(context).accentColor,
                            )),
                      ],
                    ),
                    SizedBox(height: 48),
                    model.isSubmit
                        ? CountDownTimerWidget(
                            controller: model.controler,
                          )
                        : const SizedBox(),
                    model.isSubmit
                        ? Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: model.otpController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'OTP',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 1,
                                child: MaterialButton(
                                  onPressed: () {
                                    model.submitOTP();
                                  },
                                  child: Text('Submit'),
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    Text('${model.status}'),
                    MaterialButton(
                      onPressed: () {
                        model.logout();
                      },
                      child: Text('Logout'),
                      color: Theme.of(context).accentColor,
                    ),
                  ],
                );
              },
            ));
      },
    );
  }
}
