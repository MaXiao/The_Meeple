import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/screens/add_player_screen.dart';
import 'package:the_meeple/screens/records/add_record_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/Views/empty_view.dart';
import 'package:the_meeple/utils/Views/nav_button.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      builder: (context) => bloc,
      child: Scaffold(
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
              isLeading: false,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ItemField(
                  isFilled: false,
                  text: "Name of game",
                  icon: Container(
                    color: MeepleColors.paleGray,
                  ),
                ),
                StreamBuilder<Object>(
                    stream: bloc.selectedDate,
                    builder: (context, snapshot) {
                      final selected = snapshot.hasData;
                      return _ItemField(
                        isFilled: true,
                        text: bloc.dateString(
                            selected ? snapshot.data : DateTime.now()),
                        icon: Image.asset("assets/images/ic_record_date.png"),
                        action: () {
                          Future<DateTime> selectedDate = showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2100));
                          selectedDate.then((date) {
                            bloc.selectDate.add(date);
                          });
                        },
                      );
                    }),
                _ItemField(
                    isFilled: false,
                    text: "Players (optional)",
                    icon: Image.asset("assets/images/ic_record_player.png"),
                    action: () async {
                      final result = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => AddPlayerScreen(List())));

                      if (result is List<Player>) {
                        bloc.add(result);
                      }
                    },
                    child: Consumer<AddRecordBloc>(
                        builder: (context, bloc, child) {
                      if (bloc.players.isNotEmpty) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return _PlayerCard(
                              player: bloc.players[index],
                              score: 10,
                              note: "nurse",
                            );
                          },
                          shrinkWrap: true,
                          itemCount: bloc.players.length,
                          padding: EdgeInsets.zero,
                        );
                      } else {
                        return EmptyView();
                      }
                    })),
                _ItemField(
                  isFilled: false,
                  text: "Winner (optional)",
                  icon: Image.asset("assets/images/ic_record_winner.png"),
                ),
                _NoteField(
                  isFilled: false,
                  text: "",
                ),
                FlatButton.icon(
                    onPressed: null,
                    icon: Image.asset("assets/images/ic_record_preview.png"),
                    label: Text(
                      "Preview",
                      style: TextStyle(
                          fontSize: 14, color: MeepleColors.primaryBlue),
                    ))
              ],
            ),
          )),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final Player player;
  final int score;
  final String note;

  const _PlayerCard({Key, key, this.player, this.score, this.note});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(
      Container(
        height: 42,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              player.name,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                "Edit",
                style: TextStyle(fontSize: 16, color: MeepleColors.primaryBlue),
              ),
            )
          ],
        ),
      ),
    );

    if (score != null || note != null) {
      children.add(Container(
        height: 42,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            score != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 46),
                    child: Text(
                      "Score: ${this.score}",
                      style: TextStyle(fontSize: 14),
                    ))
                : EmptyView(),
            note != null
                ? Flexible(
                    child: Text(
                    "Note: ${this.note}",
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))
                : EmptyView()
          ],
        ),
      ));
    }
    ;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: MeepleColors.paleBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}

class _ItemField extends StatelessWidget {
  final bool isFilled;
  final String text;
  final Widget icon;
  final Widget child;
  final VoidCallback action;

  const _ItemField(
      {Key key, this.isFilled, this.text, this.icon, this.child, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    children.add(Container(
      height: 56,
      child: GestureDetector(
        onTap: action,
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
    ));

    if (child != null) children.add(child);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: children,
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
                        child: Image.asset(
                            "assets/images/ic_record_quickphoto.png"),
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
