import 'package:flutter/material.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/Views/empty_view.dart';

class MeepleAlert extends StatelessWidget {
  const MeepleAlert({
    Key key,
    @required this.title,
    this.content,
    @required this.positiveAction,
    this.positiveLabel,
    this.negativeAction,
    this.negativeLabel,
    this.bottomComponent
  }): assert(title != null), assert(positiveAction != null), super(key: key);
  
  final VoidCallback positiveAction;
  final String positiveLabel;
  final VoidCallback negativeAction;
  final String negativeLabel;
  final String title;
  final String content;
  final Widget bottomComponent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      contentPadding: EdgeInsets.fromLTRB(14, 20, 14, 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          content != null ?
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(
              content,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ) : EmptyView(),
          Container(
            height: 36,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (negativeAction != null)
                        negativeAction();
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                          color: MeepleColors.borderGray,
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Center(
                          child: Text(
                            negativeLabel != null ? negativeLabel : "Cancel",
                            style: TextStyle(
                                fontSize: 16,
                                color: MeepleColors.primaryBlue,
                                fontWeight: FontWeight.bold),
                          )),
                    )),
                flex: 4,
              ),
              Container(
                width: 12,
              ),
              Flexible(
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      positiveAction();
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                          color: MeepleColors.primaryBlue,
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Center(
                          child: Text(
                            positiveLabel != null ? positiveLabel : "Ok",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    )),
                flex: 5,
              ),
            ],
          ),
          bottomComponent != null ? bottomComponent : EmptyView(),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
    );
  }
}