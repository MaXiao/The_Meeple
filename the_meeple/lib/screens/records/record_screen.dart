
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/Views/PrimaryButton.dart';

class RecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MeepleColors.paleGray,
      appBar: _Topbar(),
      body: _EmptyView()
    );
  }
}

class _Topbar extends StatefulWidget implements ObstructingPreferredSizeWidget {
  @override
  bool get fullObstruction => true;
  
  @override
  Size get preferredSize => Size.fromHeight(140);

  @override
  State<StatefulWidget> createState() {
    return _TobbarState();
  }
}

class _TobbarState extends State<_Topbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 24, top: 24),
            child: Text("Your history", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: MeepleColors.textBlack),),
          ),
          PrimaryButton(title: "Add record", actionCallback: () {},)
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 45, bottom: 20),
                child: Image.asset("assets/images/img_record_home.png"),
              ),
              Container(
                width: 260,
                child: Text("So let’s start. We’ll keep your memories intact.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MeepleColors.textLightGray),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 58, left: 16, right: 16),
                child: PrimaryButton(title: '\u{FF0B} Add record', actionCallback: () {},),
              )
            ],
          ),
        ),
      ],
    );
  }
}

