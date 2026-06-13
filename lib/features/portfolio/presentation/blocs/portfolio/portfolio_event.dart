import 'package:equatable/equatable.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

class LoadPortfolioDataEvent extends PortfolioEvent {
  const LoadPortfolioDataEvent();
}

class FilterProjectsEvent extends PortfolioEvent {
  final String searchQuery;
  final List<String> selectedTags;

  const FilterProjectsEvent({
    this.searchQuery = '',
    this.selectedTags = const [],
  });

  @override
  List<Object?> get props => [searchQuery, selectedTags];
}
