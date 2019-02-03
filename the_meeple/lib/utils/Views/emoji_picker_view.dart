import 'package:flutter/cupertino.dart';
import 'package:the_meeple/utils/emojis.dart';

class EmojiPickerView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 5,
      children: List.generate(Emojis.list.length, (index) {
        return Center(
          child: Text(Emojis.list[index], style: TextStyle(fontSize: 40),),
        );
      }),
    );
  }

}