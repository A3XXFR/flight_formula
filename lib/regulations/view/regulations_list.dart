import 'package:carbon_icons/carbon_icons.dart';
import 'package:flight_formula/regulations/regulation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegulationsListPage extends StatelessWidget {
  final List<Regulation> regulations;
  const RegulationsListPage({Key? key, required this.regulations})
      : super(key: key);

  static Page page({required List<Regulation> regulations}) {
    return MaterialPage<void>(
      child: RegulationsListPage(regulations: regulations),
    );
  }

  List<Widget> _createList() {
    List<Widget> widgets = [];
    for (final regulation in regulations) {
      switch (regulation.type) {
        case 'subchapter':
        case 'subpart':
          HeaderRegulation reg = regulation as HeaderRegulation;
          widgets.add(
            RegulationListItem(regulation: regulation),
          );
          for (final regulationChild in reg.children) {
            widgets.add(
              RegulationListItem(regulation: regulationChild),
            );
          }
          break;
        default:
          widgets.add(
            RegulationListItem(regulation: regulation),
          );
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<RegulationBloc>().add(PartDeselected());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FlightFormula'),
          //leading: const Icon(CarbonIcons.menu),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(CarbonIcons.search),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(CarbonIcons.filter),
            ),
            /*Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(CarbonIcons.switcher),
            ),*/
          ],
        ),
        body: ListView(
          children: _createList(),
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
