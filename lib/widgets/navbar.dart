import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' show ImageFilter;

import '../../features/theme/presentation/bloc/theme_cubit.dart';
import '../../features/theme/presentation/bloc/theme_state.dart';

class NavigationItem {
  final String title;
  final VoidCallback onTap;

  const NavigationItem({required this.title, required this.onTap});
}

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  final List<NavigationItem> items;
  final bool isMobile;
  final VoidCallback? onMenuTap;
  final ScrollController scrollController;
  final String activeSection;

  const Navbar({
    super.key,
    required this.items,
    required this.isMobile,
    required this.scrollController,
    required this.activeSection,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = widget.scrollController.offset;
    if (offset != _scrollOffset) {
      setState(() => _scrollOffset = offset);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isScrolled = _scrollOffset > 20;

    return AppBar(
      elevation: 0,
      backgroundColor: isScrolled
          ? theme.scaffoldBackgroundColor.withAlpha((0.75 * 255).round())
          : theme.scaffoldBackgroundColor,
      flexibleSpace: isScrolled
          ? ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.primary.withAlpha(20),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
      title: Text(
        'Yousef Habbeh',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: widget.isMobile
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: widget.onMenuTap,
            )
          : null,
      actions: [
        if (!widget.isMobile)
          ...widget.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: NavbarButton(
                  title: item.title,
                  isActive: item.title.toLowerCase() == widget.activeSection.toLowerCase(),
                  onTap: item.onTap,
                ),
              ),
            ),
          ),
        const SizedBox(width: 8),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDark = state.themeMode == ThemeMode.dark ||
                (state.themeMode == ThemeMode.system &&
                    MediaQuery.platformBrightnessOf(context) == Brightness.dark);
            return IconButton(
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: theme.colorScheme.primary,
              ),
              tooltip: isDark ? 'Toggle Light Mode' : 'Toggle Dark Mode',
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme(!isDark);
              },
            );
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class NavbarButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const NavbarButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<NavbarButton> createState() => _NavbarButtonState();
}

class _NavbarButtonState extends State<NavbarButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final isHighlighted = _hovered || widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: isHighlighted ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isHighlighted ? colors.primary : colors.onSurface.withAlpha((0.75 * 255).round()),
                    fontSize: 15,
                    fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                    fontFamily: textStyle?.fontFamily,
                  ),
                  child: Text(widget.title),
                ),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: isHighlighted ? 32.0 : 0.0,
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
