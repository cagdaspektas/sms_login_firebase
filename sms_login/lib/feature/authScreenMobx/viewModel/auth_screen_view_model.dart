import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:mobx/mobx.dart';
import 'package:sms_login/core/model/base_view_model.dart';
import 'package:sms_login/product/widget/showAlertDialog_widget.dart';
part 'auth_screen_view_model.g.dart';

class AuthScreenViewModel = _AuthScreenViewModelBase with _$AuthScreenViewModel;

abstract class _AuthScreenViewModelBase with Store, BaseViewModel {
  @override
  void init() {
    Firebase.initializeApp();
  }

  @override
  void setContext(BuildContext context) => this.context = context;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  @observable
  String status = '';
  @observable
  bool isSubmit = false;
  AuthCredential? phoneAuth;
  String? verificationId;
  int? code;
  CountdownTimerController? controler;

  @action
  void countDown() {
    controler = CountdownTimerController(
      endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 120,
      onEnd: () {
        showDialog(
          context: context,
          builder: (BuildContext _context) {
            return ShowAlertDialog(
              alertOkText: "ok",
              alertCancelText: "cancel",
              cancelButton: () {
                Navigator.pop(context);
              },
              alertText: "Expire time ended for enter sms password.Do you want to send it again?",
              okButton: () {
                controler?.disposeTimer();
                submitPhoneNumber();
                countDown();
                Navigator.pop(_context);
              },
            );
          },
        );
      },
    );
  }

  @action
  void handleError(e) {
    print(e.message);

    status += e.message + '\n';
  }

  @action
  Future<void> logout() async {
    //Logout method for signout firebase
    await FirebaseAuth.instance.signOut();
  }

  @action
  Future<void> submitPhoneNumber() async {
    ///we are using +90 because of turkey code.
    String phoneNumber = "+90" + phoneNumberController.text;
    print(phoneNumber);

    ///Automatic handling of the SMS code on  devices
    @action
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');

      status += 'verificationCompleted\n';

      phoneAuth = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    ///Handle failure events such as invalid phone numbers or whether the SMS quota has been exceeded.
    @action
    void verificationFailed(FirebaseAuthException error) {
      print('verificationFailed');
      handleError(error);
    }

//Handle when a code has been sent to the device from Firebase, used to prompt users to enter the code.
    @action
    void codeSent(String verificationIdnew, [int? code]) {
      print('codeSent');
      verificationId = verificationIdnew;
      print(verificationId);
      code = code;
      print(code.toString());
      status += 'Code Sent';
    }
    // Handle a timeout of when automatic SMS code handling fails.

    void codeAutoRetrievalTimeout(String verificationIdnew) {
      print('codeAutoRetrievalTimeout');

      status += 'codeAutoRetrievalTimeout\n';

      print(verificationIdnew);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      //this part is about your phoneNumber which will be sent to sms.
      phoneNumber: phoneNumber,
//the part of respond sms time.If you try after 120 sec u need to send the code again
      timeout: const Duration(seconds: 120),

      verificationCompleted: verificationCompleted,

      verificationFailed: verificationFailed,

      codeSent: codeSent,

      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @action
  Future<void> submitOTP() async {
    /// we are getting code from user here
    String smsCode = otpController.text.toString().trim();
    print(smsCode);

    /// when we use other number from the current phone number we need to use this method.
    /// we need phoneAuthcredential to signin/login
    phoneAuth = PhoneAuthProvider.credential(verificationId: verificationId ?? '', smsCode: smsCode);
    Future.delayed(const Duration(seconds: 5));
    await login();
  }

  @action
  void reset() {
    phoneNumberController.clear();
    otpController.clear();
    status = "";
  }

  @action
  Future<void> login() async {
    /// this method for the login the user
    /// phoneAuthCredential is needed for signIn Method

    print(phoneAuth);
    if (phoneAuth != null) {
      await FirebaseAuth.instance.signInWithCredential(phoneAuth!);
    } else {
      print("authcredential false");
    }

    status += 'Signed In\n';
  }
}
