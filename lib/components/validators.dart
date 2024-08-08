import 'package:finance_tracker/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/components/localisations.dart';

class Validators {
  static String? validateName(String value, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).translate("noEmptyNameError");
    }
    return null;
  }

  static String? validateNameDouble(String value, BuildContext context, FileController fileController, {String? name}) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).translate("noEmptyNameError");
    } else if(fileController.listTag.any((tag) => tag.tagName == value && name != value)) {
      return AppLocalizations.of(context).translate("duplicateTagError");
    } else {
      return null;
    }
  }


  static String? validateAmount(String value, BuildContext context) {
    final double? amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return AppLocalizations.of(context).translate("noEmptyAmountError");
    } else if (value.contains(RegExp(r'^\d{11,}$'))) {
      return "Max 10 digits before the decimal.";
    } else if (value.contains(RegExp(r'\.\d{3,}$'))) {
      return "Max 2 digits after the decimal.";
    }
    return null;
  }
}
