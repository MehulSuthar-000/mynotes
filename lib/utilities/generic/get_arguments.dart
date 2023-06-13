import 'package:flutter/material.dart' show BuildContext, ModalRoute;
import 'package:flutter/services.dart';

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    if (ModalRoute != null) {
      final args = modalRoute?.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
