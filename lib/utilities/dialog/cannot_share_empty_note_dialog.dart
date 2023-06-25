import 'package:flutter/widgets.dart';
import 'package:privateproject/utilities/dialog/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(
  BuildContext context,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'Cannot share empty note!',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
