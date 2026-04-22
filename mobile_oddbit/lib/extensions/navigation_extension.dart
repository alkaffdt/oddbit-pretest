import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension NavigatorExt on BuildContext {
  bool canPop() => Navigator.canPop(this);

  void pop<T>({result}) => Navigator.pop(this, result);

  Future<T?> pushNamed<T extends Object?>(
    String screenName, {
    Object? arguments,
  }) async =>
      await Navigator.of(this).pushNamed<T>(screenName, arguments: arguments);

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String screenName, {
    Object? arguments,
  }) async => await Navigator.of(
    this,
  ).pushReplacementNamed<T, TO>(screenName, arguments: arguments);

  Future<dynamic> push(
    Widget screen, {
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) async => await Navigator.of(this).push(
    MaterialPageRoute(
      builder: (_) => screen,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    ),
  );

  Future<dynamic> pushReplacement(
    Widget screen, {
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) async => await Navigator.of(this).pushReplacement(
    Platform.isAndroid
        ? MaterialPageRoute(
            builder: (_) => screen,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
          )
        : CupertinoPageRoute(
            builder: (_) => screen,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
          ),
  );

  /// perform push and remove route
  Future<dynamic> pushAndRemoveUntil(
    Widget screen, {
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool routes = false,
  }) async => await Navigator.of(this).pushAndRemoveUntil(
    Platform.isAndroid
        ? MaterialPageRoute(
            builder: (_) => screen,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
          )
        : CupertinoPageRoute(
            builder: (_) => screen,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
          ),
    (Route<dynamic> route) => routes,
  );

  void popUntilFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }
}
