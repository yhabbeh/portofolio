import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:portfolio_web/core/di/service_locator.dart';
import 'package:portfolio_web/core/services/email_service.dart';
import 'package:portfolio_web/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:portfolio_web/features/portfolio/data/models/portfolio_data_model.dart';
import 'package:portfolio_web/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:portfolio_web/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:portfolio_web/features/portfolio/domain/usecases/submit_contact.dart';
import 'package:portfolio_web/features/portfolio/presentation/blocs/contact/contact_bloc.dart';
import 'package:portfolio_web/features/portfolio/presentation/blocs/contact/contact_event.dart';
import 'package:portfolio_web/features/portfolio/presentation/blocs/contact/contact_state.dart';
import 'package:portfolio_web/features/theme/presentation/bloc/theme_cubit.dart';

class MockEmailServiceSuccess implements EmailService {
  @override
  Future<void> send({required String name, required String email, required String message}) async {}

  @override
  void dispose() {}
}

class MockEmailServiceFailure implements EmailService {
  @override
  Future<void> send({required String name, required String email, required String message}) async {
    throw Exception('Simulated API gateway error. Please try again.');
  }

  @override
  void dispose() {}
}

class MockPortfolioLocalDataSource implements PortfolioLocalDataSource {
  @override
  Future<PortfolioDataModel> getPortfolioData() {
    throw UnimplementedError();
  }
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
  });

  tearDown(() async {
    await sl.reset();
  });

  group('ThemeCubit Tests', () {
    test('Initial state should be ThemeMode.system', () async {
      final sharedPreferences = await SharedPreferences.getInstance();
      sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
      sl.registerLazySingleton<ThemeCubit>(
        () => ThemeCubit(sharedPreferences: sl()),
      );

      final themeCubit = sl<ThemeCubit>();
      expect(themeCubit.state.themeMode, ThemeMode.system);
    });

    test('toggleTheme should emit new theme mode and save to preferences', () async {
      final sharedPreferences = await SharedPreferences.getInstance();
      sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
      sl.registerLazySingleton<ThemeCubit>(
        () => ThemeCubit(sharedPreferences: sl()),
      );

      final themeCubit = sl<ThemeCubit>();

      await themeCubit.toggleTheme(true);
      expect(themeCubit.state.themeMode, ThemeMode.dark);

      await themeCubit.toggleTheme(false);
      expect(themeCubit.state.themeMode, ThemeMode.light);
    });
  });

  group('ContactBloc Tests', () {
    setUp(() async {
      sl.registerLazySingleton<EmailService>(() => MockEmailServiceSuccess());
      sl.registerLazySingleton<PortfolioLocalDataSource>(
        () => MockPortfolioLocalDataSource(),
      );
      sl.registerLazySingleton<PortfolioRepository>(
        () => PortfolioRepositoryImpl(
          localDataSource: sl(),
          emailService: sl(),
        ),
      );
      sl.registerLazySingleton<SubmitContact>(
        () => SubmitContact(repository: sl()),
      );
      sl.registerFactory<ContactBloc>(
        () => ContactBloc(submitContact: sl()),
      );
    });

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

      await Future.delayed(const Duration(milliseconds: 100));

      expect(states, [
        const ContactSubmitting(),
        const ContactSuccess(),
      ]);

      await subscription.cancel();
    });

    test('SubmitContactFormEvent emits ContactFailure on simulated error name', () async {
      await sl.reset();
      sl.registerLazySingleton<EmailService>(() => MockEmailServiceFailure());
      sl.registerLazySingleton<PortfolioLocalDataSource>(
        () => MockPortfolioLocalDataSource(),
      );
      sl.registerLazySingleton<PortfolioRepository>(
        () => PortfolioRepositoryImpl(
          localDataSource: sl(),
          emailService: sl(),
        ),
      );
      sl.registerLazySingleton<SubmitContact>(
        () => SubmitContact(repository: sl()),
      );
      sl.registerFactory<ContactBloc>(
        () => ContactBloc(submitContact: sl()),
      );

      final contactBloc = sl<ContactBloc>();

      final states = <ContactState>[];
      final subscription = contactBloc.stream.listen(states.add);

      contactBloc.add(const SubmitContactFormEvent(
        name: 'error',
        email: 'john@example.com',
        message: 'Hello!',
      ));

      await Future.delayed(const Duration(milliseconds: 100));

      expect(states, [
        const ContactSubmitting(),
        const ContactFailure('Simulated API gateway error. Please try again.'),
      ]);

      await subscription.cancel();
    });
  });
}
