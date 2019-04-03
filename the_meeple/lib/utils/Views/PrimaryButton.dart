import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/utils/MeepleColors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback actionCallback;
  final String title;

  PrimaryButton({Key key, this.actionCallback, this.title})
      : assert(title != null),
        assert(actionCallback != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 56.0),
      child: FlatButton(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: MeepleColors.primaryBlue,
          textColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: actionCallback),
    );
  }
}
