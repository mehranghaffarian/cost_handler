import 'package:flutter/material.dart';

class MGChoosableChip extends StatefulWidget {
  final String label;
  final Function(bool) onTap;
  bool isChosen = false;

  MGChoosableChip({required this.label, required this.onTap, this.isChosen = false, Key? key})
      : super(key: key);

  @override
  State<MGChoosableChip> createState() => _MGChoosableChipState();
}

class _MGChoosableChipState extends State<MGChoosableChip> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      // width: 75,
      child: InkWell(
        onTap: () => setState(() {
          widget.isChosen = !widget.isChosen;
          widget.onTap(widget.isChosen);
        }),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(180, 180, 180, 0.3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Text(widget.label, maxLines: 1,)),
              const SizedBox(
                width: 5,
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
        ),
      ),
    );
  }
}
