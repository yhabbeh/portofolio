import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/portfolio/presentation/blocs/contact/contact_bloc.dart';
import 'features/portfolio/presentation/blocs/portfolio/portfolio_bloc.dart';
import 'features/portfolio/presentation/pages/home_page.dart';
import 'features/theme/presentation/bloc/theme_cubit.dart';
import 'features/theme/presentation/bloc/theme_state.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => sl<ThemeCubit>(),
        ),
        BlocProvider<PortfolioBloc>(
          create: (_) => sl<PortfolioBloc>(),
        ),
        BlocProvider<ContactBloc>(
          create: (_) => sl<ContactBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final isDark = state.themeMode == ThemeMode.dark ||
              (state.themeMode == ThemeMode.system &&
                  MediaQuery.platformBrightnessOf(context) == Brightness.dark);
          final activeTheme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

          return MaterialApp(
            title: 'Yousef Habbeh Portfolio',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            builder: (context, child) {
              return AnimatedTheme(
                data: activeTheme,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: child!,
              );
            },
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
