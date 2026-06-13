import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final String title;
  final String company;
  final String period;
  final String location;
  final List<String> responsibilities;

  const Experience({
    required this.title,
    required this.company,
    required this.period,
    required this.location,
    required this.responsibilities,
  });

  @override
  List<Object?> get props => [title, company, period, location, responsibilities];
}
