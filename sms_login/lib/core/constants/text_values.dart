import 'package:sms_login/core/constants/text_enum.dart';

extension TextExtension on TextEnum {
  String rawValue() {
    switch (this) {
      case TextEnum.approve:
        return 'Approve';

      case TextEnum.logOut:
        return 'Logout';
      case TextEnum.smsCode:
        return 'Enter sms code';
      case TextEnum.phoneNumber:
        return 'Phone Number';
      case TextEnum.phoneAuth:
        return 'How To Phone Authentication';
    }
  }
}
