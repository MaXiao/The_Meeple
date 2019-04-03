import 'package:flutter/cupertino.dart';
import 'package:the_meeple/utils/emojis.dart';

class EmojiPickerView extends StatelessWidget {

  EmojiPickerView({this.onSelectEmoji});

  final void Function(int) onSelectEmoji;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 5,
      children: List.generate(Emojis.list.length, (index) {
        return GestureDetector(
          onTap: () {
            onSelectEmoji(index);
            Navigator.pop(context);
          },
          child: Center(
            child: Text(Emojis.list[index], style: TextStyle(fontSize: 40),),
          ),
        );
      }),
    );
  }

}