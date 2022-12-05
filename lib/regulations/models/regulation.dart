import 'package:equatable/equatable.dart';
import 'package:xml/xml.dart';

enum regType {
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
    required this.identifier,
    required this.label,
    required this.labelLevel,
    required this.labelDescription,
    required this.type,
    required this.reserved,
  });

  @override
  List<Object?> get props => [
        label,
        labelLevel,
        labelDescription,
        type,
        reserved,
      ];
}

class PartRegulation extends Regulation {
  final List<Regulation> children;
  const PartRegulation({
    required this.children,
    required super.identifier,
    required super.label,
    required super.labelLevel,
    required super.labelDescription,
    required super.type,
    required super.reserved,
  });

  factory PartRegulation.fromJson(Map<String, dynamic> json,
      /*XmlElement xml,*/ List<Regulation> children) {
    return PartRegulation(
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

  factory SectionRegulation.fromJson(json, XmlElement xml) {
    return SectionRegulation(
      body: xml.innerText,
      identifier: json["identifier"],
      label: json["label"] as String,
      labelLevel: json["label_level"] as String,
      labelDescription: json["label_description"] as String,
      type: json["type"] as String,
      reserved: json["reserved"] as bool,
    );
  }
}
