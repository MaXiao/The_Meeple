import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/utils/MeepleColors.dart';

class NavButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  NavButton({Key key, this.onPressed, this.title}): assert(title != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: this.onPressed,
        child: Text(
          title,
          style: TextStyle(
              color: MeepleColors.primaryBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ));
  }
}