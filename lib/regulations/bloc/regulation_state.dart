part of 'regulation_bloc.dart';

enum RegulationStatus { initial, success, failure }

class RegulationState extends Equatable {
  RegulationState({
    this.status = RegulationStatus.initial,
    this.regulations = const <Regulation> [],
  });

  final RegulationStatus status;
  List<Regulation> regulations;

  RegulationState copyWith({
    RegulationStatus? status,
    List<Regulation>? regulations,
  }) {
    return RegulationState(
      status: status ?? this.status,
      regulations: regulations ?? this.regulations,
    );
  }

  @override
  String toString() {
    return '''RegulationState { status: $status, Regulations: $regulations }''';
  }

  @override
  List<Object> get props => [status, regulations];
}