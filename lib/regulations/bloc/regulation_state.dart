part of 'regulation_bloc.dart';

enum RegulationStatus { initial, success, failure }

class RegulationState extends Equatable {
  const RegulationState({
    this.status = RegulationStatus.initial,
    this.regulations = const <Regulation>[],
    this.hasReachedMax = false,
  });

  final RegulationStatus status;
  final List<Regulation> regulations;
  final bool hasReachedMax;

  RegulationState copyWith({
    RegulationStatus? status,
    List<Regulation>? regulations,
    bool? hasReachedMax,
  }) {
    return RegulationState(
      status: status ?? this.status,
      regulations: regulations ?? this.regulations,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''RegulationState { status: $status, hasReachedMax: $hasReachedMax, Regulations: ${regulations.length} }''';
  }

  @override
  List<Object> get props => [status, regulations, hasReachedMax];
}