import 'package:flutter/material.dart';

class MGReportCard extends StatelessWidget {
  final List<Widget> reportInfoChildren;

  const MGReportCard({required this.reportInfoChildren, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.blue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: Colors.blueGrey, width: 2),
      ),
      elevation: 20,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.bottomLeft,
              begin: Alignment.topRight,
              colors: [
                colorScheme.primary.withOpacity(1),
                colorScheme.primary.withOpacity(0.5),
                colorScheme.onPrimary.withOpacity(0.8),
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 20,
                spreadRadius: 10,
              ),
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: reportInfoChildren,
        ),
      ),
    );
  }
}
