import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/utils/MeepleColors.dart';

class NavButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool isLeading;

  NavButton({Key key, this.onPressed, this.title, this.isLeading = true}): assert(title != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: const EdgeInsets.all(0),
        onPressed: this.onPressed,
        child: SizedBox(
          width: 100,
          child: Text(
            title,
            textAlign: isLeading ? TextAlign.start : TextAlign.end,
            style: TextStyle(
                color: MeepleColors.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ));
  }
}