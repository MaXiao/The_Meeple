import 'package:flutter/cupertino.dart';

class EmptyView extends IgnorePointer {
  EmptyView()
      : super(
            ignoring: true,
            child: new Opacity(
              opacity: 0.0,
            ));
}
