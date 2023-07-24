import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

part 'color_pallete.dart';
part 'font_theme.dart';

const baseUrl = 'https://bigexpress.co.id/API/big/API/';

const String googleAPIKey = "AIzaSyAnCRQ395mqfS6TkNYdO9R8ad7O4ed2sU4";

String returnItem() {
  return 'returnItem';
}

String moneyChanger(double value, {String? customLabel}) {
  return NumberFormat.currency(
          name: customLabel ?? 'Rp', decimalDigits: 0, locale: 'id')
      .format(value.round());
}

showSnackbar(BuildContext context,
    {required String title, Color? customColor}) {
  final snack = SnackBar(
    content: Text(
      title,
      style: FontTheme.regularBaseFont
          .copyWith(fontSize: 12.0.sp, color: Colors.white),
    ),
    backgroundColor: customColor ?? ColorPallette.baseBlue,
  );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}

String dateToReadable(String date) {
  String finalString = '';

  List<String> breakDate = date.split('-');

  switch (breakDate[1]) {
    case '01':
      finalString = finalString + 'Jan';
      break;
    case '02':
      finalString = finalString + 'Feb';
      break;
    case '03':
      finalString = finalString + 'Mar';
      break;
    case '04':
      finalString = finalString + 'Apr';
      break;
    case '05':
      finalString = finalString + 'Mei';
      break;
    case '06':
      finalString = finalString + 'Jun';
      break;
    case '07':
      finalString = finalString + 'Jul';
      break;
    case '08':
      finalString = finalString + 'Aug';
      break;
    case '09':
      finalString = finalString + 'Sep';
      break;
    case '10':
      finalString = finalString + 'Okt';
      break;
    case '11':
      finalString = finalString + 'Nov';
      break;
    case '12':
      finalString = finalString + 'Des';
      break;
    default:
  }

  finalString = breakDate[2] + ' $finalString ' + breakDate[0];

  return finalString;
}
