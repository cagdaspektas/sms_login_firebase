import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:sms_login/product/widget/countdown_widget.dart';
import 'package:sms_login/product/widget/showAlertDialog_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String _status = '';
  bool isSubmit = false;

  AuthCredential? _phoneAuthCredential;
  String? _verificationId;
  int? _code;
  CountdownTimerController? controler;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

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
                _submitPhoneNumber();
                countDown();
                Navigator.pop(_context);
              },
            );
          },
        );
      },
    );
  }

  void _handleError(e) {
    print(e.message);
    setState(() {
      _status += e.message + '\n';
    });
  }

  Future<void> _logout() async {
    /// Method to Logout the `FirebaseUser` (`_firebaseUser`)
    // signout code
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _submitPhoneNumber() async {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+90" + _phoneNumberController.text.toString().trim();
    print(phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      setState(() {
        _status += 'verificationCompleted\n';
      });
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(FirebaseAuthException error) {
      print('verificationFailed');
      _handleError(error);
    }

    void codeSent(String verificationId, [int? code]) {
      print('codeSent');
      _verificationId = verificationId;
      print(verificationId);
      _code = code;
      print(code.toString());
      setState(() {
        _status += 'Code Sent\n';
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
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

  void _submitOTP() {
    /// get the `smsCode` from the user
    String smsCode = _otpController.text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    _phoneAuthCredential = PhoneAuthProvider.credential(verificationId: _verificationId ?? '', smsCode: smsCode);

    _login();
  }

  void _reset() {
    _phoneNumberController.clear();
    _otpController.clear();
    setState(() {
      _status = "";
    });
  }

  /// phoneAuthentication works this way:
  ///     AuthCredential is the only thing that is used to authenticate the user
  ///     OTP is only used to get AuthCrendential after which we need to authenticate with that AuthCredential
  ///
  /// 1. User gives the phoneNumber
  /// 2. Firebase sends OTP if no errors occur
  /// 3. If the phoneNumber is not in the device running the app
  ///       We have to first ask the OTP and get `AuthCredential`(`_phoneAuthCredential`)
  ///       Next we can use that `AuthCredential` to signIn
  ///    Else if user provided SIM phoneNumber is in the device running the app,
  ///       We can signIn without the OTP.
  ///       because the `verificationCompleted` callback gives the `AuthCredential`(`_phoneAuthCredential`) needed to signIn
  Future<void> _login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)

    await FirebaseAuth.instance.signInWithCredential(_phoneAuthCredential!);

    setState(() {
      _status += 'Signed In\n';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Phone Auth'),
          actions: [
            GestureDetector(
              child: Icon(Icons.refresh),
              onTap: _reset,
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _phoneNumberController,
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
                      _submitPhoneNumber();
                      setState(() {
                        isSubmit = true;
                        countDown();
                      });
                    },
                    child: Text('Submit'),
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 48),
            isSubmit
                ? CountDownTimerWidget(
                    controller: controler,
                  )
                : const SizedBox(),
            isSubmit
                ? Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _otpController,
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
                          onPressed: _submitOTP,
                          child: Text('Submit'),
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            Text('$_status'),
            MaterialButton(
              onPressed: _logout,
              child: Text('Logout'),
              color: Theme.of(context).accentColor,
            ),
          ],
        ));
  }
}
