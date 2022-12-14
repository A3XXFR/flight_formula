import 'package:equatable/equatable.dart';

enum RegType {
  title,
  chapter,
  subchapter,
  part,
  subpart,
  subjectGroup,
  section
}

abstract class Regulation extends Equatable {
  final String identifier;
  final String label;
  final String labelLevel;
  final String labelDescription;
  final String type;
  final bool reserved;

  const Regulation({
    this.identifier = "",
    this.label = "",
    this.labelLevel = "",
    this.labelDescription = "",
    this.type = "",
    this.reserved = false,
  });

  @override
  List<Object?> get props => [
        label,
        labelLevel,
        labelDescription,
        type,
        reserved,
      ];

  static List<SectionRegulation> getSectionRegulations(Regulation regulation) {
    List<SectionRegulation> sectionRegulations = [];

    if (regulation is HeaderRegulation) {
      for (var child in regulation.children) {
        sectionRegulations.addAll(getSectionRegulations(child));
      }
    } else if (regulation is SectionRegulation) {
      sectionRegulations.add(regulation);
    }
    return sectionRegulations;
  }

  static List<Regulation> getRegulationsByType(
      Regulation regulation, String type) {
    List<Regulation> regulations = [];

    if (regulation is HeaderRegulation) {
      // Recursively search the children of the header regulation
      for (var child in regulation.children) {
        if (child.type == type) {
          regulations.add(child);
        } else {
          regulations.addAll(getRegulationsByType(child, type));
        }
      }
    }
    return regulations;
  }
}

class HeaderRegulation extends Regulation {
  final List<Regulation> children;
  const HeaderRegulation({
    required this.children,
    required super.identifier,
    required super.label,
    required super.labelLevel,
    required super.labelDescription,
    required super.type,
    required super.reserved,
  });

  factory HeaderRegulation.fromJson(
      Map<String, dynamic> json, List<Regulation> children) {
    return HeaderRegulation(
      children: children,
      identifier: json["identifier"],
      label: json["label"],
      labelLevel: json["label_level"],
      labelDescription: json["label_description"],
      type: json["type"],
      reserved: json["reserved"],
    );
  }
}

class SectionRegulation extends Regulation {
  final String body;
  const SectionRegulation({
    required this.body,
    required super.identifier,
    required super.label,
    required super.labelLevel,
    required super.labelDescription,
    required super.type,
    required super.reserved,
  });

  factory SectionRegulation.fromJson(json, String html) {
    return SectionRegulation(
      body: html,
      identifier: json["identifier"],
      label: json["label"] as String,
      labelLevel: json["label_level"] as String,
      labelDescription: json["label_description"] as String,
      type: json["type"] as String,
      reserved: json["reserved"] as bool,
    );
  }

/*  bool _checkIfSectionRegulation(json) {
    switch (json["type"]) {
      case 'section':
      case 'appendix':
    }
  }*/
}
