import 'package:flutter/widgets.dart';
import 'package:privateproject/utilities/dialog/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An Error Occured',
    content: text,
    optionsBuilder: () => {
      'OK' : null,
    },
  );
}
