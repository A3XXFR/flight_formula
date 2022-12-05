import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_formula/regulations/regulation.dart';
import 'package:http/http.dart' as http;

class RegulationsPage extends StatelessWidget {
  const RegulationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Regulations')),
      body: BlocProvider(
        create: (_) => RegulationBloc(httpClient: http.Client())..add(RegulationFetched()),
        child: const RegulationsList(),
      ),
    );
  }
}