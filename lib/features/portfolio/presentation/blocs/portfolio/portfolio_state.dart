import 'package:equatable/equatable.dart';

import '../../../domain/entities/portfolio_data.dart';
import '../../../domain/entities/project.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

class PortfolioLoaded extends PortfolioState {
  final PortfolioData data;
  final String searchQuery;
  final List<String> selectedTags;
  final List<ProjectCategory> filteredProjectCategories;

  const PortfolioLoaded({
    required this.data,
    this.searchQuery = '',
    this.selectedTags = const [],
    required this.filteredProjectCategories,
  });

  @override
  List<Object?> get props => [data, searchQuery, selectedTags, filteredProjectCategories];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
