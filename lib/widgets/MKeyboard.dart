import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class MKeyboard extends StatefulWidget {
  final String content;
  final ValueChanged<String>? onChanged;

  MKeyboard({this.content = '', this.onChanged});

  @override
  __MKeyboardState createState() => __MKeyboardState();
}

class __MKeyboardState extends State<MKeyboard> {
  late TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller = TextEditingController(text: widget.content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.grey,
        child: VirtualKeyboard(
          height: 400,
          // width: 1000,
          textColor: Colors.white,
          fontSize: 20,
          defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
          type: VirtualKeyboardType.Alphanumeric,
          onKeyPress: () {},
          textController: _controller,
        ),
      ),
    );
  }
}
