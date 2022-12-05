import 'package:regulations_api/regulations_api.dart';

/// {@template regulations_api}
/// The interface and models for an API providing access to regulations.
/// {@endtemplate}
abstract class RegulationsApi {
  /// {@macro regulations_api}
  const RegulationsApi();

  Stream<List<Regulation>> getRegulations();
}
