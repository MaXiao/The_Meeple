import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Color color;
  final String text;

  const ActionButton({
    Key key,
    @required this.color,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(const Radius.circular(6.0))),
        child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}