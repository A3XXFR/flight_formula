import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_formula/regulations/regulation.dart';

class RegulationsList extends StatefulWidget {
  const RegulationsList({super.key});

  @override
  State<RegulationsList> createState() => _RegulationsListState();
}

class _RegulationsListState extends State<RegulationsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegulationBloc, RegulationState>(
      builder: (context, state) {
        switch (state.status) {
          case RegulationStatus.failure:
            return const Center(child: Text('Failed to fetch regulations'));
          case RegulationStatus.success:
            if (state.regulations.isEmpty) {
              return const Center(child: Text('No regulations found'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return RegulationListItem(regulation: state.regulations[index]);
              },
              itemCount: state.regulations.length,
              controller: _scrollController,
            );
          case RegulationStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

}