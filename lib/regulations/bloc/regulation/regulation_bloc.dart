import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_formula/regulations/regulation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

part 'regulation_event.dart';
part 'regulation_state.dart';

class RegulationBloc extends Bloc<RegulationEvent, RegulationState> {
  final int _title = 1;
  final String _chapterLimit = '';
  late DateTime _latestTitleIssueDate;

  RegulationBloc({required this.httpClient}) : super(const RegulationState()) {
    on<RegulationFetched>(_onRegulationFetched);
    on<PartSelected>((event, emit) {
      emit(state.copyWith(selectedPart: () => event.part));
    });
    on<PartDeselected>((event, emit) {
      emit(state.copyWith(selectedPart: () => null));
    });
    on<SectionSelected>((event, emit) {
      emit(state.copyWith(selectedSection: () => event.section));
    });
    on<SectionDeselected>((event, emit) {
      emit(state.copyWith(selectedSection: () => null));
    });
  }

  Future<void> _onRegulationFetched(
      RegulationFetched event, Emitter<RegulationState> emit) async {
    try {
      if (state.status == RegulationStatus.initial) {
        final regulations = await _fetchRegulations();
        return emit(state.copyWith(
          status: RegulationStatus.success,
          regulations: regulations,
        ));
      }
      await _fetchRegulations();
      emit(state.copyWith(
        status: RegulationStatus.success,
        regulations: state.regulations,
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
    final DateTime currentTitleIssueDate = await _getLocalTitleIssueDate();

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

  Future<DateTime> _getLocalTitleIssueDate() async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File dateFile = File('$path/date.txt');

    if (await dateFile.exists()) {
      return DateTime.parse(await dateFile.readAsString());
    } else {
      return DateTime(2000);
    }
  }

  void _saveFiles({var json, var html}) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File('$path/title.json').writeAsString(json);
    File('$path/title.html').writeAsString(html);
    File('$path/date.txt')
        .writeAsString(_latestTitleIssueDate.toIso8601String());
  }

  //TODO Improve to reduce repeated code from _getRegulationsOnline
  Future<List<Regulation>> _getRegulationsLocally() async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    String localJson = await File('$path/title.json').readAsString();
    String localHtml = await File('$path/title.html').readAsString();

    final Map<String, dynamic> jsonBody = json.decode(localJson);
    final List<dom.Element> htmlBody = [];

    htmlBody
        .addAll(html_parser.parse(localHtml).getElementsByClassName("section"));
    htmlBody.addAll(
        html_parser.parse(localHtml).getElementsByClassName("appendix"));

    HeaderRegulation fullRegs =
        _createRegulationObject(jsonBody, htmlBody) as HeaderRegulation;
    List<Regulation> partRegulations =
        Regulation.getRegulationsByType(fullRegs, "subchapter");

    return partRegulations;
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
              'https://www.ecfr.gov/api/renderer/v1/content/enhanced/${_latestTitleIssueDate.toString().split(' ').first}/title-$_title'))
          .then((value) => xmlResponse = value),
    ]);

    if (jsonResponse.statusCode == 200 && xmlResponse.statusCode == 200) {
      _saveFiles(
        json: const Utf8Decoder().convert(jsonResponse.bodyBytes),
        html: const Utf8Decoder().convert(xmlResponse.bodyBytes),
      );

      final Map<String, dynamic> jsonBody =
          json.decode(const Utf8Decoder().convert(jsonResponse.bodyBytes));
      final List<dom.Element> htmlBody = [];

      htmlBody.addAll(html_parser
          .parse(const Utf8Decoder().convert(xmlResponse.bodyBytes))
          .getElementsByClassName("section"));
      htmlBody.addAll(html_parser
          .parse(const Utf8Decoder().convert(xmlResponse.bodyBytes))
          .getElementsByClassName("appendix"));

      HeaderRegulation fullRegs =
          _createRegulationObject(jsonBody, htmlBody) as HeaderRegulation;
      List<Regulation> partRegulations =
          Regulation.getRegulationsByType(fullRegs, "subchapter");

      return partRegulations;
    }
    throw Exception('error fetching regulations online');
  }

  Regulation _createRegulationObject(
      Map<String, dynamic> regList, List<dom.Element> fullText) {
    if (regList["children"] != null) {
      List<Regulation> children = [];
      for (Map<String, dynamic> child in regList["children"]) {
        Regulation childObj = _createRegulationObject(child, fullText);
        children.add(childObj);
      }
      return HeaderRegulation.fromJson(regList, children);
    } else {
      String htmlElement =
          "<p> There was an error getting data on this regulation. Please report this issue. [Unable to match regulation with body text]</p>";
      for (var text in fullText) {
        if (text.id == regList["identifier"].replaceAll(" ", "-")) {
          htmlElement = text.innerHtml;
        }
      }

      return SectionRegulation.fromJson(regList, htmlElement);
    }
  }

  DateTime _parseDate(String raw) {
    int year = int.parse(raw.split("-")[0]);
    int month = int.parse(raw.split("-")[1]);
    int day = int.parse(raw.split("-")[2]);
    return DateTime(year, month, day);
  }
}
