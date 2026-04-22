import 'package:flutter/widgets.dart';

extension DoubleExtensions on double {
  Widget toHeightGap() {
    return SizedBox(
      height: toDouble(),
    );
  }

  Widget toWidthGap() {
    return SizedBox(
      width: toDouble(),
    );
  }

  String toPriceFormat() {
    String numberString = toInt().toString();
    String formattedNumber = numberString.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m.group(1)},',
    );
    return formattedNumber;
  }
}
