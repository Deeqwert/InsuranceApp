import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurance/resources/app_colors.dart';

class UserTextValidator {
  bool validateText(TextEditingController userNameEditText) {
    return validateLength(userNameEditText, userNameEditText.text.toString(), 1,
        "Name is required", "Not a valid name");
  }

  bool validateUserName(TextEditingController userNameEditText) {
    return validateLength(userNameEditText, userNameEditText.text.toString(), 2,
        "Name is required", "Not a valid name");
  }

  bool validatePassword(TextEditingController passwordEditText) {
    return validateLength(passwordEditText, passwordEditText.text.toString(), 6,
        "Password is required", "Not a valid password");
  }

  bool validatePhoneNumber(TextEditingController cardPhoneEditText) {
    String phoneNumber =
        cardPhoneEditText.text.toString().replaceAll("[^\\d]", "");
    return validateLength(cardPhoneEditText, phoneNumber, 9,
        "Phone number is required", "Phone a valid card number");
  }

  bool validateRepiatPassword(TextEditingController passwordEditText,
      TextEditingController repeatPasswordEditText) {
    bool state;
    if (passwordEditText.text.toString() ==
        repeatPasswordEditText.text.toString()) {
      state = true;
    } else {
      state = false;
      showToast("The verification password does not match");
    }
    return state;
  }

  bool validateLength(TextEditingController editText, String? checkedText,
      int minLength, String emptyTextError, String shortLengthTextError) {
    bool state = true;
    bool empty = (checkedText != null && checkedText.isEmpty);
    bool shortLength =
        (checkedText != null && checkedText.length > (minLength - 1));
    if (empty) {
      showToast(emptyTextError);
      state = false;
    } else if (!shortLength) {
      showToast(shortLengthTextError);
      state = false;
    }
    return state;
  }

  bool validateEmail(TextEditingController? emailEditText) {
    bool state = true;
    if (emailEditText != null) {
      bool empty = (emailEditText.text.toString().isEmpty);
      bool matcher = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailEditText.text.toString());
      if (empty) {
        showToast("Email is required");
        state = false;
      } else if (!matcher) {
        showToast("Not a valid email address");
        state = false;
      }
    } else {
      state = false;
    }

    return state;
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.font_black_color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
