import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class MTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool directionCol;

  final ValueChanged<String>? onChanged;

  MTextField(
      {this.label = '',
      this.hint = '',
      this.onChanged,
      this.directionCol = true});

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<MTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.hint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.directionCol
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: NeumorphicTheme.defaultTextColor(context),
                    fontSize: 20,
                  ),
                ),
              ),
              Neumorphic(
                margin: const EdgeInsets.only(
                    left: 12, right: 12, top: 2, bottom: 4),
                style: NeumorphicStyle(
                  depth: NeumorphicTheme.embossDepth(context),
                  boxShape: const NeumorphicBoxShape.stadium(),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                child: TextField(
                  onChanged: widget.onChanged,
                  controller: _controller,
                  decoration: InputDecoration.collapsed(hintText: widget.hint),
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          )
        : Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: NeumorphicTheme.defaultTextColor(context),
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Neumorphic(
                  margin: const EdgeInsets.only(
                      left: 12, right: 12, top: 2, bottom: 4),
                  style: NeumorphicStyle(
                    depth: NeumorphicTheme.embossDepth(context),
                    boxShape: const NeumorphicBoxShape.stadium(),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  child: TextField(
                    onChanged: widget.onChanged,
                    controller: _controller,
                    decoration:
                        InputDecoration.collapsed(hintText: widget.hint),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          );
  }
}
