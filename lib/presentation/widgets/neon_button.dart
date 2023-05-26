import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class NeonButton extends StatefulWidget {
  final Color? givenShadowColor;
  final Color? textColor;
  final Function() onPressed;
  final String buttonText;

  const NeonButton({Key? key, this.givenShadowColor, required this.onPressed, required this.buttonText, this.textColor}) : super(key: key);

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            color: isPressed ? colorScheme.background : null,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              for (double i = 1; i < 5; i++)
                BoxShadow(
                    spreadRadius: -1,
                    blurStyle: BlurStyle.outer,
                    color: colorScheme.shadow,
                    blurRadius: (isPressed ? 5 : 3) * i),
              for (double i = 1; i < 5; i++)
                BoxShadow(
                    spreadRadius: -1,
                    blurStyle: BlurStyle.outer,
                    color: widget.givenShadowColor ?? colorScheme.shadow,
                    blurRadius: (isPressed ? 5 : 3) * i)
            ]),
        child: TextButton(
          onHover: (hovered) => setState(() {
            isPressed = hovered;
          }),
          onPressed: widget.onPressed,
          child: Text(
            widget.buttonText,
            style: TextStyle(
              color: widget.textColor ?? colorScheme.background,
              shadows: [
                for (double i = 1; i < (isPressed ? 8 : 4); i++)
                  Shadow(color: widget.givenShadowColor ?? colorScheme.shadow, blurRadius: i * 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
