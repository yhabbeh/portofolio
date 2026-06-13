import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/project_card.dart';
import '../../../../widgets/section_title.dart';
import '../blocs/portfolio/portfolio_bloc.dart';
import '../blocs/portfolio/portfolio_event.dart';
import '../blocs/portfolio/portfolio_state.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        if (state is! PortfolioLoaded) {
          return const SizedBox.shrink();
        }

        final data = state.data;
        final activeTag = state.selectedTag;
        final currentQuery = state.searchQuery;

        // Synchronize search text field if updated elsewhere
        if (_searchController.text != currentQuery) {
          _searchController.text = currentQuery;
        }

        // Dynamically extract all unique technologies from raw portfolio data
        final allTags = data.projectCategories
            .expand((cat) => cat.projects)
            .expand((proj) => proj.technologies)
            .map((t) => t.trim())
            .toSet()
            .toList();
        allTags.sort();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Projects',
              subtitle: 'Open-source projects spanning mobile, AI, and web development. Feel free to search or filter by technology tag.',
              gradient: true,
            ),
            const SizedBox(height: 24),

            // Search Bar & Filter Section
            Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        context.read<PortfolioBloc>().add(
                              FilterProjectsEvent(
                                searchQuery: val,
                                selectedTag: activeTag,
                              ),
                            );
                      },
                      decoration: InputDecoration(
                        hintText: 'Search projects...',
                        prefixIcon: Icon(Icons.search, color: colors.primary),
                        suffixIcon: currentQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<PortfolioBloc>().add(
                                        FilterProjectsEvent(
                                          searchQuery: '',
                                          selectedTag: activeTag,
                                        ),
                                      );
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Technology Filter Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // "All" filter chip
                ChoiceChip(
                  label: const Text('All Projects'),
                  selected: activeTag == null,
                  onSelected: (_) {
                    context.read<PortfolioBloc>().add(
                          FilterProjectsEvent(
                            searchQuery: currentQuery,
                            selectedTag: null,
                          ),
                        );
                  },
                ),
                ...allTags.map((tag) {
                  final isSelected = activeTag == tag;
                  return ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) {
                      context.read<PortfolioBloc>().add(
                            FilterProjectsEvent(
                              searchQuery: currentQuery,
                              selectedTag: isSelected ? null : tag,
                            ),
                          );
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 32),

            // Filtered Projects Display
            if (state.filteredProjectCategories.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 48, color: colors.secondary),
                      const SizedBox(height: 12),
                      Text(
                        'No matching projects found',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.onSurface.withAlpha(180),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try adjusting your search query or technology tag filters.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...state.filteredProjectCategories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: category.projects.length,
                          itemBuilder: (context, idx) {
                            final p = category.projects[idx];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ProjectCard(project: p),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
