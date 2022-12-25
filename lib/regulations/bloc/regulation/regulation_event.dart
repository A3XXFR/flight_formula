part of 'regulation_bloc.dart';

abstract class RegulationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegulationFetched extends RegulationEvent {}

class PartSelected extends RegulationEvent {
  final HeaderRegulation part;

  PartSelected({required this.part});

  @override
  List<Object> get props => [part];
}

class PartDeselected extends RegulationEvent {}

class SectionSelected extends RegulationEvent {
  final SectionRegulation section;

  SectionSelected({required this.section});

  @override
  List<Object> get props => [section];
}

class SectionDeselected extends RegulationEvent {}
