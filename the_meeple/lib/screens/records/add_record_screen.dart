import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/screens/records/add_record_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/Views/empty_view.dart';
import 'package:the_meeple/utils/Views/nav_button.dart';

class AddRecordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddRecordScreenState();
  }
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final bloc = AddRecordBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MeepleColors.paleGray,
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          leading: NavButton(
            onPressed: () {
              Navigator.pop(context);
            },
            title: "Cancel",
          ),
          middle: Text("Add Record"),
          trailing: NavButton(
            onPressed: () {
              Navigator.pop(context);
            },
            title: "Done",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: <Widget>[
              _ItemField(
                isFilled: false,
                text: "Name of game",
                icon: Container(
                  color: MeepleColors.paleGray,
                ),
              ),
              _ItemField(
                isFilled: true,
                text: bloc.dateString(DateTime.now()),
                icon: Image.asset("assets/images/ic_record_date.png"),
              ),
              _ItemField(
                isFilled: false,
                text: "Players (optional)",
                icon: Image.asset("assets/images/ic_record_player.png"),
              ),
              _ItemField(
                isFilled: false,
                text: "Winner (optional)",
                icon: Image.asset("assets/images/ic_record_winner.png"),
              ),
              _NoteField(
                isFilled: false,
                text: "",
              )
            ],
          ),
        ));
  }
}

class _ItemField extends StatelessWidget {
  final bool isFilled;
  final String text;
  final Widget icon;

  const _ItemField({
    Key key,
    this.isFilled,
    this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 11, left: 8, right: 10, bottom: 11),
                child: Container(
                    width: 32,
                    height: 32,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(6)),
                    child: Center(child: icon)),
              ),
              Expanded(
                  child: Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isFilled ? Colors.black : MeepleColors.coolGrey),
              )),
              Icon(
                Icons.chevron_right,
                color: MeepleColors.primaryBlue,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  final bool isFilled;
  final String text;

  const _NoteField({
    Key key,
    this.isFilled,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 150),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration.collapsed(
                        hintText: "Notes (optional)",
                        hintStyle: TextStyle(color: MeepleColors.coolGrey),
                      ),
                    )),
                    Icon(
                      Icons.chevron_right,
                      color: MeepleColors.primaryBlue,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: FlatButton(
                        onPressed: null,
                          padding: EdgeInsets.all(0),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          child: Image.asset("assets/images/ic_record_quickphoto.png"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
