import 'package:flutter/cupertino.dart';

class MeepleBottomSheet extends StatelessWidget {
  MeepleBottomSheet({
    Key key,
    @required this.content,
    this.contentHeight
  }) : super(key: key);

  final Widget content;
  double contentHeight = 400;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: contentHeight,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 54,
                decoration: BoxDecoration(
                    border: BorderDirectional(
                        bottom: BorderSide(
                            width: 1, color: Color.fromARGB(40, 0, 0, 0)))),
                child: Center(
                    child: Text(
                  "Manage scores",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
              ),
              Container(
                height: 10,
              ),
              Expanded(child: content)
            ]));
  }
}
