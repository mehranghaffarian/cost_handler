import 'package:flutter/material.dart';

class MGChoosableChip extends StatefulWidget {
  final String label;
  final Function(bool) onTap;
  bool isChosen = false;

   MGChoosableChip({required this.label, required this.onTap, Key? key})
      : super(key: key);

  @override
  State<MGChoosableChip> createState() => _MGChoosableChipState();
}

class _MGChoosableChipState extends State<MGChoosableChip> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        debugPrint("${widget.isChosen}");
        widget.isChosen = !widget.isChosen;
        widget.onTap(widget.isChosen);
      }),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            label: Text(widget.label),
          ),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isChosen ? Colors.green : Colors.white,
                border: Border.all(color: Colors.black, width: 1)),
          ),
        ],
      ),
    );
  }
}
