import 'package:flight_formula/regulations/regulation.dart';
import 'package:flight_formula/regulations/view/regulation_detail.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class RegulationsPage extends StatelessWidget {
  const RegulationsPage({super.key});

  List<Page> onGeneratePages(RegulationState state, List<Page> pages) {
    final selectedPart = state.selectedPart;
    final selectedSection = state.selectedSection;

    return [
      RegulationsListPage.page(
        regulations: state.regulations,
      ),
      if (selectedPart != null)
        RegulationsListPage.page(
          regulations: selectedPart.children,
        ),
      if (selectedSection != null)
        RegulationDetailPage.page(section: selectedSection),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<RegulationBloc>().add(PartDeselected());
        return true;
      },
      child: BlocProvider(
        create: (_) =>
            RegulationBloc(httpClient: http.Client())..add(RegulationFetched()),
        child: BlocBuilder<RegulationBloc, RegulationState>(
          builder: (context, state) {
            switch (state.status) {
              case RegulationStatus.failure:
                return const Center(child: Text('Failed to fetch regulations'));
              case RegulationStatus.success:
                if (state.regulations.isEmpty) {
                  return const Center(child: Text('No regulations found'));
                }
                return FlowBuilder(
                  state: context.watch<RegulationBloc>().state,
                  onGeneratePages: onGeneratePages,
                );
              case RegulationStatus.initial:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
