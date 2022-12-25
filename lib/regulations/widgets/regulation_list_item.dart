import 'package:flight_formula/regulations/regulation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegulationListItem extends StatelessWidget {
  const RegulationListItem({super.key, required this.regulation});

  final Regulation regulation;

  @override
  Widget build(BuildContext context) {
    if (regulation.reserved) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          regulation.labelDescription,
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
      );
    } else if (regulation.type == 'subchapter' ||
        regulation.type == 'subpart') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                regulation.labelLevel,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
            Text(
              regulation.labelDescription.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10.0, color: Colors.grey),
            ),
            const Divider(),
          ],
        ),
      );
    } else {
      return ListTile(
        title: Text(regulation.labelLevel),
        subtitle: Text(
          regulation.labelDescription,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        dense: true,
        //isThreeLine: false,
        enabled: !regulation.reserved,
        onTap: () {
          if ((regulation.type == "section" || regulation.type == "appendix")) {
            context
                .read<RegulationBloc>()
                .add(SectionSelected(section: regulation as SectionRegulation));
          } else {
            context
                .read<RegulationBloc>()
                .add(PartSelected(part: regulation as HeaderRegulation));
          }
        },
      );
    }
  }
}
