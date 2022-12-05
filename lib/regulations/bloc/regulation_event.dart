part of 'regulation_bloc.dart';

abstract class RegulationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegulationFetched extends RegulationEvent {}
