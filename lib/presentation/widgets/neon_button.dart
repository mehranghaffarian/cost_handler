import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class NeonButton extends StatefulWidget {
  final Color? givenShadowColor;

  const NeonButton({Key? key, this.givenShadowColor}) : super(key: key);

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color shadowColor =  Colors.redAccent.shade700;
    Color backgroundColor = widget.givenShadowColor?.withOpacity(0.7) ?? Colors.redAccent.shade700;
    // Color shadowColor = Colors.blueAccent.shade700;
    // Color shadowColor = Colors.purpleAccent.shade700;

    return Listener(
      onPointerDown: (_) => setState(() {
        isPressed = true;
      }),
      onPointerUp: (_) => setState(() {
        isPressed = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        decoration: BoxDecoration(
            color: isPressed ? backgroundColor : null,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              for (double i = 1; i < 5; i++)
                BoxShadow(
                    spreadRadius: -1,
                    blurStyle: BlurStyle.outer,
                    color: Colors.white,
                    blurRadius: (isPressed ? 5 : 3) * i),
              for (double i = 1; i < 5; i++)
                BoxShadow(
                    spreadRadius: -1,
                    blurStyle: BlurStyle.outer,
                    color: shadowColor,
                    blurRadius: (isPressed ? 5 : 3) * i)
            ]),
        child: TextButton(
          onHover: (hovered) => setState(() {
            isPressed = hovered;
          }),
          onPressed: () {},
          child: Text(
            "neon button",
            style: TextStyle(
              color: Colors.white,
              shadows: [
                for (double i = 1; i < (isPressed ? 8 : 4); i++)
                  Shadow(color: shadowColor, blurRadius: i * 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
