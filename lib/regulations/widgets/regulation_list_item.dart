import 'package:flutter/material.dart';
import 'package:flight_formula/regulations/regulation.dart';

class RegulationListItem extends StatelessWidget {
  const RegulationListItem({super.key, required this.regulation});

  final Regulation regulation;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text(regulation.label, style: textTheme.caption),
        title: Text(regulation.labelDescription),
        isThreeLine: true,
        subtitle: Text(regulation.type),
        dense: true,
      ),
    );
  }
}