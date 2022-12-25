import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/regulation/regulation_bloc.dart';
import '../models/regulation.dart';

class RegulationDetailPage extends StatelessWidget {
  RegulationDetailPage({super.key, required this.section});

  static Page page({required SectionRegulation section}) {
    return MaterialPage<void>(
      child: RegulationDetailPage(section: section),
    );
  }

  final SectionRegulation section;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<RegulationBloc>().add(SectionDeselected());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            section.label,
            style: GoogleFonts.ibmPlexSans(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Html(
              data: section.body,
              customRender: customRender,
              style: style,
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic Function(RenderContext, Widget)> customRender = {};
  Map<String, Style> style = {
    ".indent-1": Style(
      padding: const EdgeInsets.only(left: 15.0),
      //padding: ,
    ),
    ".indent-2": Style(
      padding: const EdgeInsets.only(left: 30.0),
    ),
    ".indent-3": Style(
      padding: const EdgeInsets.only(left: 45.0),
    ),
    ".paragraph-hierarchy": Style(
      backgroundColor: Colors.grey[700],
      border: Border.all(
        color: const Color(0x00000000),
        width: 5.0,
        style: BorderStyle.solid,
        strokeAlign: StrokeAlign.outside,
      ),
    ),
    ".paragraph-heading": Style(
      fontWeight: FontWeight.bold,
    ),
    ".citation": Style(
      fontSize: FontSize.small,
      fontStyle: FontStyle.italic,
    ),
  };
}
