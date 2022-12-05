import 'package:flight_formula/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_formula/app.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';


void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const App());
}
