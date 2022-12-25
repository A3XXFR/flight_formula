part of 'regulation_bloc.dart';

enum RegulationStatus { initial, success, failure }

class RegulationState extends Equatable {
  const RegulationState({
    this.selectedPart,
    this.selectedSection,
    this.status = RegulationStatus.initial,
    this.regulations = const <Regulation>[],
  });

  final RegulationStatus status;

  final HeaderRegulation? selectedPart;
  final SectionRegulation? selectedSection;
  final List<Regulation> regulations;

  RegulationState copyWith({
    RegulationStatus? status,
    List<Regulation>? regulations,
    ValueGetter<HeaderRegulation?>? selectedPart,
    ValueGetter<SectionRegulation?>? selectedSection,
  }) {
    return RegulationState(
      status: status ?? this.status,
      regulations: regulations ?? this.regulations,
      selectedPart: selectedPart != null ? selectedPart() : this.selectedPart,
      selectedSection:
          selectedSection != null ? selectedSection() : this.selectedSection,
    );
  }

  @override
  String toString() {
    return '''RegulationState { status: $status, Regulations: $regulations, Selected Part: $selectedPart, Selected Section: $selectedSection }''';
  }

  @override
  List<Object?> get props =>
      [status, regulations, selectedPart, selectedSection];
}
