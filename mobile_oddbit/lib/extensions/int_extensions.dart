import 'package:flutter/widgets.dart';

extension IntExtensions on int {
  Widget toHeightGap() {
    return SizedBox(height: toDouble());
  }

  Widget toWidthGap() {
    return SizedBox(width: toDouble());
  }
}
