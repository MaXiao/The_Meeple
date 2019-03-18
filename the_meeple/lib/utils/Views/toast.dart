import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/utils/Views/empty_view.dart';

class Toast extends StatelessWidget {
  final String content;
  final ToastAction action;
  final Color backgroundColor;
  final Duration duration;

  Toast({
    Key key,
    this.content,
    this.action,
    this.duration = ToastDurationShort,
    this.backgroundColor = Colors.black,
  }) : assert(content != null), super(key: key);

  static const ToastDurationShort = Duration(seconds: 2);
  static const ToastDurationLong = Duration(seconds: 4);
  static const ToastDurationExtraLong = Duration(seconds: 6);

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
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      content,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  action != null ? action : EmptyView(),
                ],
              ),
            ),
          ),
        ));
  }
}

class ToastAction extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  const ToastAction({
    Key key,
    this.label,
    this.icon,
    @required this.onPressed}) : assert(label != null || icon != null), assert(onPressed != null), super(key: key);

  @override
  State<StatefulWidget> createState() => _ToastActionState();
}

class _ToastActionState extends State<ToastAction> {
  bool _haveTriggeredAction = false;

  @override
  Widget build(BuildContext context) {
    if (widget.label != null) {
      return FlatButton(onPressed:  _haveTriggeredAction ? null : _handlePressed, child: Text(widget.label),);
    } else {
      return IconButton(onPressed: _haveTriggeredAction ? null : _handlePressed, icon: widget.icon);
    }
  }

  void _handlePressed() {
    if (_haveTriggeredAction) {
      return;
    }
    setState(() {
      _haveTriggeredAction = true;
    });
    widget.onPressed();
    hideToast(context);
  }
}

showToast(BuildContext context, String title,
    {Color backgroundColor: Colors.black, }) async {
  final overlay = Overlay.of(context);

  final entry = OverlayEntry(builder: (BuildContext context) {
    return Toast(content: title, backgroundColor: backgroundColor);
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
