import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/utils/MeepleColors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback actionCallback;
  final String title;
  double height;

  PrimaryButton({Key key, this.actionCallback, this.title, this.height = 56})
      : assert(title != null),
        assert(actionCallback != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
