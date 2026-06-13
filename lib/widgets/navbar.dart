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

  const Navbar({
    super.key,
    required this.items,
    required this.isMobile,
    required this.scrollController,
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
          ? theme.scaffoldBackgroundColor.withAlpha((0.85 * 255).round())
          : theme.scaffoldBackgroundColor,
      flexibleSpace: isScrolled
          ? ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(color: Colors.transparent),
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

  const NavbarButton({
    super.key,
    required this.title,
    required this.onTap,
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: _hovered ? colors.primary : colors.onSurface.withAlpha((0.75 * 255).round()),
                    fontSize: 15,
                    fontWeight: _hovered ? FontWeight.w700 : FontWeight.w500,
                    fontFamily: textStyle?.fontFamily,
                  ),
                  child: Text(widget.title),
                ),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  width: _hovered ? 32.0 : 0.0,
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
