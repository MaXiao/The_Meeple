import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_meeple/models/player.dart';
import 'package:the_meeple/screens/players/player_edit_bloc.dart';
import 'package:the_meeple/utils/MeepleColors.dart';
import 'package:the_meeple/utils/Views/emoji_picker_view.dart';
import 'package:the_meeple/utils/Views/empty_view.dart';
import 'package:the_meeple/utils/Views/meeple_alert_view.dart';
import 'package:the_meeple/utils/Views/meeple_bottom_sheet.dart';
import 'package:the_meeple/utils/Views/toast.dart';
import 'package:the_meeple/utils/emojis.dart';
import 'package:image_picker/image_picker.dart';

class PlayerEditScreen extends StatefulWidget {
  PlayerEditScreen({Key key, this.isCreating, this.player}) : super(key: key);

  final Player player;
  final bool isCreating;

  @override
  State<StatefulWidget> createState() {
    return PlayerEditState();
  }
}

class PlayerEditState extends State<PlayerEditScreen> {
  FocusNode _focus;
  TextEditingController _controller;
  String avatar = "";

  @override
  void initState() {
    super.initState();

    _focus = FocusNode();
    _controller = TextEditingController(text: widget.isCreating ? "" : "${widget.player.name}");
    if (widget.isCreating) {
      avatar = Emojis.random;
    } else {
      avatar = widget.player.avatar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(widget.isCreating ? "Add Player" : "Edit Player"),
        trailing: FlatButton(
          onPressed: _controller.text.length == 0
              ? null
              : (widget.isCreating ? _createUser : _editUser),
          child: Text(
            "Done",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          textColor: MeepleColors.primaryBlue,
          disabledTextColor: MeepleColors.textGray,
        ),
      ),
      body: _buildBody(),
    );
  }

  _createUser() {
    final username = _controller.text;
    Player.checkAndCreateUser(name: username, avatar: avatar).then((player) {
      if (player != null) {
        Navigator.pop(context, true);
        showToast(context, "Player added");
      } else {
        showToast(
            context, "There is another recorded player named ${username}.");
      }
    });
  }

  _editUser() {
    widget.player.name = _controller.text;
    widget.player.avatar = avatar;
    widget.player.checkAndUpdate().then((success) {
      if (success) {
        Navigator.pop(context, widget.player);
        showToast(context, "Player updated");
      } else {
        showToast(
            context, "There is another recorded player named ${_controller.text}.");
      }
    });
  }

  Column _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return MeepleBottomSheet(
                      title: "Choose your avatar",
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: EmojiPickerView(onSelectEmoji: (emojiIndex) {
                              setState(() {
                                avatar = Emojis.list[emojiIndex];
                              });
                            },),
                          ),
                          FlatButton(onPressed: () async {
                            final image = await ImagePicker.pickImage(source: ImageSource.camera);
                          }, child: Container(
                            height: 40,
                            decoration: BoxDecoration(color: MeepleColors.primaryBlue),
                            child: Center(child: Text("Choose photo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          ))
                        ],
                      ),
                    );
                  });
            },
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: MeepleColors.primaryBlue, // border color
                shape: BoxShape.circle,
              ),
              width: 64,
              height: 64,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Container(
                    child: Text(avatar, style: TextStyle(fontSize: 50))),
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                  color: MeepleColors.paleGray,
                  borderRadius: BorderRadius.circular(6)),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  height: 56,
                  child: CupertinoTextField(
                    autofocus: true,
                    placeholder: "Username",
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    controller: _controller,
                    focusNode: _focus,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    onChanged: (newValue) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            )),
        _delete()
      ],
    );
  }

  Widget _delete() {
    return widget.isCreating
        ? EmptyView()
        : Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: FlatButton.icon(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _DeleteAlert(
                            player: widget.player,
                          );
                        });
                  },
                  icon: Image.asset("assets/images/ic_delete_bin.png"),
                  label: Text(
                    "Delete player",
                    style: TextStyle(color: MeepleColors.primaryBlue),
                  ),
                ),
              ),
            ],
          );
  }
}

class _DeleteAlert extends StatelessWidget {
  const _DeleteAlert({
    Key key,
    @required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return MeepleAlert(
      title: "Are you sure?",
      content: "Delete a player will remove all his/her records.",
      positiveAction: () {
        player.delete().then((success) {
          if (success) {
            Navigator.pop(context);
            Navigator.pop(context, true);
          }
        });
      },
      positiveLabel: "Yes",
    );
  }
}
