import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:portfolio_web/core/di/service_locator.dart';
import 'package:portfolio_web/features/portfolio/presentation/blocs/contact/contact_bloc.dart';
import 'package:portfolio_web/features/portfolio/presentation/blocs/contact/contact_event.dart';
import 'package:portfolio_web/features/portfolio/presentation/blocs/contact/contact_state.dart';
import 'package:portfolio_web/features/theme/presentation/bloc/theme_cubit.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
    await initServiceLocator();
  });

  tearDown(() async {
    await sl.reset();
  });

  group('ThemeCubit Tests', () {
    test('Initial state should be ThemeMode.system', () {
      final themeCubit = sl<ThemeCubit>();
      expect(themeCubit.state.themeMode, ThemeMode.system);
    });

    test('toggleTheme should emit new theme mode and save to preferences', () async {
      final themeCubit = sl<ThemeCubit>();
      
      await themeCubit.toggleTheme(true); // Dark mode
      expect(themeCubit.state.themeMode, ThemeMode.dark);

      await themeCubit.toggleTheme(false); // Light mode
      expect(themeCubit.state.themeMode, ThemeMode.light);
    });
  });

  group('ContactBloc Tests', () {
    test('Initial state is ContactInitial', () {
      final contactBloc = sl<ContactBloc>();
      expect(contactBloc.state, const ContactInitial());
    });

    test('SubmitContactFormEvent emits ContactSubmitting then ContactSuccess', () async {
      final contactBloc = sl<ContactBloc>();
      
      final states = <ContactState>[];
      final subscription = contactBloc.stream.listen(states.add);

      contactBloc.add(const SubmitContactFormEvent(
        name: 'John Doe',
        email: 'john@example.com',
        message: 'Hello!',
      ));

      await Future.delayed(const Duration(milliseconds: 500));

      expect(states, [
        const ContactSubmitting(),
        const ContactSuccess(),
      ]);

      await subscription.cancel();
    });
  });
}
