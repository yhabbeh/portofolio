import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/project.dart';
import '../../../domain/usecases/get_portfolio_data.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final GetPortfolioData getPortfolioData;

  PortfolioBloc({required this.getPortfolioData}) : super(const PortfolioInitial()) {
    on<LoadPortfolioDataEvent>(_onLoadPortfolioData);
    on<FilterProjectsEvent>(_onFilterProjects);
  }

  Future<void> _onLoadPortfolioData(
    LoadPortfolioDataEvent event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(const PortfolioLoading());
    try {
      final data = await getPortfolioData();
      emit(PortfolioLoaded(
        data: data,
        filteredProjectCategories: data.projectCategories,
      ));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }

  void _onFilterProjects(
    FilterProjectsEvent event,
    Emitter<PortfolioState> emit,
  ) {
    final currentState = state;
    if (currentState is PortfolioLoaded) {
      final query = event.searchQuery.toLowerCase();
      final tag = event.selectedTag;

      final List<ProjectCategory> filteredCategories = [];

      for (final category in currentState.data.projectCategories) {
        final List<Project> filteredProjects = [];
        for (final project in category.projects) {
          final matchesTag = tag == null ||
              project.technologies.any((t) => t.toLowerCase() == tag.toLowerCase());
          final matchesQuery = query.isEmpty ||
              project.name.toLowerCase().contains(query) ||
              project.description.toLowerCase().contains(query);

          if (matchesTag && matchesQuery) {
            filteredProjects.add(project);
          }
        }

        // Include category even if empty so headings are visible, or omit if desired
        // Standard UX is to omit categories that have zero matching projects
        if (filteredProjects.isNotEmpty) {
          filteredCategories.add(ProjectCategory(
            title: category.title,
            projects: filteredProjects,
          ));
        }
      }

      emit(PortfolioLoaded(
        data: currentState.data,
        searchQuery: event.searchQuery,
        selectedTag: event.selectedTag,
        filteredProjectCategories: filteredCategories,
      ));
    }
  }
}
