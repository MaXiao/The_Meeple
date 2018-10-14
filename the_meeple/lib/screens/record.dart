
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class RecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.only(
              left: 0.0, top: 60.0, right: 0.0, bottom: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Record',
                style: TextStyle(
                  fontSize: 28.0,
                  color: Color.fromARGB(255, 10, 10, 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}