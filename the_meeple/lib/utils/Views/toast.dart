import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Toast extends StatefulWidget {
  final String title;
  final Color backgroundColor;

  Toast({
    Key key,
    this.title,
    this.backgroundColor = Colors.black,
  });

  @override
  State<StatefulWidget> createState() {
    return _ToastState();
  }

  static final ToastDurationShort = Duration(seconds: 2);
  static final ToastDurationLong = Duration(seconds: 4);
  static final ToastDurationExtraLong = Duration(seconds: 6);
}

class _ToastState extends State<Toast> {
  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets;
    final size = MediaQuery.of(context).size;

    return Positioned(
        top: (size.height - insets.bottom) - 150,
        left: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: size.width - 32,
            decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(6)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.title,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: Image.asset('assets/images/ic_close.png'),
                    onPressed: () {
                      hideToast(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

showToast(BuildContext context, String title,
    {Color backgroundColor: Colors.black}) async {
  final overlay = Overlay.of(context);

  final entry = OverlayEntry(builder: (BuildContext context) {
    return Toast(title: title, backgroundColor: backgroundColor);
    ;
  });

  ToastManager().addToast(entry);

  overlay.insert(entry);

  await new Future.delayed(Toast.ToastDurationShort);

  entry.remove();
}

hideToast(BuildContext context) {
  ToastManager().dismiss();
}

class ToastManager {
  ToastManager._();

  static ToastManager _instance;

  factory ToastManager() {
    _instance ??= ToastManager._();
    return _instance;
  }

  Set<OverlayEntry> toastSet = Set();

  void dismiss() {
    toastSet.toList().forEach((v) {
      toastSet.remove(v);
      v.remove();
    });
  }

  void addToast(OverlayEntry entry) {
    toastSet.add(entry);
  }
}
