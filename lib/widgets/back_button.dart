import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NeumorphicBack extends StatelessWidget {
  const NeumorphicBack({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: const NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        shape: NeumorphicShape.flat,
      ),
      child: Icon(
        Icons.arrow_back,
        color: NeumorphicTheme.isUsingDark(context)
            ? Colors.white70
            : Colors.black87,
        size: 36,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
