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

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  @observable
  String status = '';
  @observable
  bool isSubmit = false;

  AuthCredential? phoneAuthCredential;
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
    /// Method to Logout the `FirebaseUser` (`_firebaseUser`)
    // signout code
    await FirebaseAuth.instance.signOut();
  }

  @action
  Future<void> submitPhoneNumber() async {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+90" + phoneNumberController.text.toString().trim();
    print(phoneNumber);

    @action

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');

      status += 'verificationCompleted\n';

      this.phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    @action
    void verificationFailed(FirebaseAuthException error) {
      print('verificationFailed');
      handleError(error);
    }

    @action
    void codeSent(String verificationId, [int? code]) {
      print('codeSent');
      verificationId = verificationId;
      print(verificationId);
      code = code;
      print(code.toString());
      status += 'Code Sent\n';
    }

    @action
    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');

      status += 'codeAutoRetrievalTimeout\n';

      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: const Duration(seconds: 120),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  @action
  void submitOTP() {
    /// get the `smsCode` from the user
    String smsCode = otpController.text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId ?? '', smsCode: smsCode);

    login();
  }

  @action
  void reset() {
    phoneNumberController.clear();
    otpController.clear();
    status = "";
  }

  /// phoneAuthentication works this way:
  ///     AuthCredential is the only thing that is used to authenticate the user
  ///     OTP is only used to get AuthCrendential after which we need to authenticate with that AuthCredential
  ///
  /// 1. User gives the phoneNumber
  /// 2. Firebase sends OTP if no errors occur
  /// 3. If the phoneNumber is not in the device running the app
  ///       We have to first ask the OTP and get `AuthCredential`(`phoneAuthCredential`)
  ///       Next we can use that `AuthCredential` to signIn
  ///    Else if user provided SIM phoneNumber is in the device running the app,
  ///       We can signIn without the OTP.
  ///       because the `verificationCompleted` callback gives the `AuthCredential`(`phoneAuthCredential`) needed to signIn

  @action
  Future<void> login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)

    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential!);

    status += 'Signed In\n';
  }
}