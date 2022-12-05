import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'package:equatable/equatable.dart';

import 'package:flight_formula/regulations/regulation.dart';

part 'regulation_event.dart';
part 'regulation_state.dart';

class RegulationBloc extends Bloc<RegulationEvent, RegulationState> {
  final int _title = 1;
  late DateTime _latestTitleIssueDate;
  RegulationBloc({required this.httpClient}) : super(const RegulationState()) {
    on<RegulationFetched>(_onRegulationFetched);
  }

  Future<void> _onRegulationFetched(
      RegulationFetched event, Emitter<RegulationState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == RegulationStatus.initial) {
        final regulations = await _fetchRegulations();
        return emit(state.copyWith(
          status: RegulationStatus.success,
          regulations: regulations,
          hasReachedMax: false,
        ));
      }
      final regulations = await _fetchRegulations();
      emit(regulations.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: RegulationStatus.success,
              regulations: List.of(state.regulations)..addAll(regulations),
              hasReachedMax: false,
            ));
    } catch (_) {
      emit(state.copyWith(status: RegulationStatus.failure));
    }
  }

  Future<List<Regulation>> _fetchRegulations() async {
    if (await _isRegulationCurrent()) {
      return _getRegulationsLocally();
    } else {
      return _getRegulationsOnline();
    }
  }

  Future<bool> _isRegulationCurrent() async {
    _latestTitleIssueDate = await _getLatestTitleIssueDate();
    final DateTime currentTitleIssueDate = await _getCurrentTitleIssueDate();

    if (_latestTitleIssueDate.isAfter(currentTitleIssueDate)) {
      return false;
    } else {
      return true;
    }
  }

  Future<DateTime> _getLatestTitleIssueDate() async {
    final response = await httpClient.get(
      Uri.parse('https://www.ecfr.gov/api/versioner/v1/titles.json'),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      for (var title in body["titles"]) {
        if (title["number"] as int == _title) {
          return _parseDate(title["latest_issue_date"]);
        }
      }
    }
    throw Exception('error fetching regulations');
  }

  Future<DateTime> _getCurrentTitleIssueDate() async {
    //TODO
    return DateTime(2000);
  }

  Future<List<Regulation>> _getRegulationsLocally() async {
    //TODO
    throw UnimplementedError();
  }

  final http.Client httpClient;
  Future<List<Regulation>> _getRegulationsOnline() async {
    late http.Response jsonResponse;
    late http.Response xmlResponse;

    await Future.wait<http.Response>([
      httpClient
          .get(Uri.parse(
              'https://www.ecfr.gov/api/versioner/v1/structure/${_latestTitleIssueDate.toString().split(' ').first}/title-$_title.json'))
          .then((value) => jsonResponse = value),
      httpClient
          .get(Uri.parse(
              'https://www.ecfr.gov/api/versioner/v1/full/${_latestTitleIssueDate.toString().split(' ').first}/title-$_title.xml'))
          .then((value) => xmlResponse = value),
    ]);

    if (jsonResponse.statusCode == 200 && xmlResponse.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(jsonResponse.body);
      final List<XmlElement> xmlBody =
          XmlDocument.parse(xmlResponse.body).findAllElements("DIV8").toList();
      List<Regulation> fullRegs = _createRegulationObject(jsonBody, xmlBody);
      return fullRegs;
    }
    throw Exception('error fetching regulations online');
  }

  List<Regulation> _createRegulationObject(
      Map<String, dynamic> regList, List<XmlElement> fullText) {
    if (regList["type"] != "part") {
      List<SectionRegulation> sections = [];
      for (var child in regList["children"]) {
        XmlElement xmlElement = fullText.firstWhere((XmlElement element) =>
            element.getAttribute("N") == child["identifier"]);
        sections.add(SectionRegulation.fromJson(child, xmlElement));
      }
      return PartRegulation.fromJson(json, children)
    }
  }


  /*Regulation _createRegulationObject(
      Map<String, dynamic> regList, List<XmlElement> fullText) {
    if (regList["children"] != null) {
      List<Regulation> children = [];
      for (Map<String, dynamic> child in regList["children"]) {
        Regulation childObj = _createRegulationObject(child, fullText);
        children.add(childObj);
      }
      return PartRegulation.fromJson(regList, children);
    } else {
      XmlElement xmlElement = fullText.firstWhere((XmlElement element) =>
          element.getAttribute("N") == regList["identifier"]);
      Regulation child = SectionRegulation.fromJson(regList, xmlElement);
      return child;
    }
  }*/

  DateTime _parseDate(String raw) {
    int year = int.parse(raw.split("-")[0]);
    int month = int.parse(raw.split("-")[1]);
    int day = int.parse(raw.split("-")[2]);
    return DateTime(year, month, day);
  }
}
