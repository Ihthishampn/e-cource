import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void showToast({required String msg}) async {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP_RIGHT,
    backgroundColor: AppColors.primaryColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showErrorToast({required String error}) async {
  Fluttertoast.showToast(
    msg: error,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor: const Color(0xFFFF0000),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
