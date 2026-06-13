import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:portfolio_web/app.dart';
import 'package:portfolio_web/core/di/service_locator.dart';
import 'package:portfolio_web/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:portfolio_web/features/portfolio/data/models/portfolio_data_model.dart';
import 'package:portfolio_web/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:portfolio_web/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:portfolio_web/features/portfolio/domain/usecases/get_portfolio_data.dart';
import 'package:portfolio_web/features/portfolio/domain/usecases/submit_contact.dart';
import 'package:portfolio_web/features/portfolio/presentation/blocs/contact/contact_bloc.dart';
import 'package:portfolio_web/features/portfolio/presentation/blocs/portfolio/portfolio_bloc.dart';
import 'package:portfolio_web/features/theme/presentation/bloc/theme_cubit.dart';

class MockPortfolioLocalDataSource implements PortfolioLocalDataSource {
  @override
  Future<PortfolioDataModel> getPortfolioData() async {
    return const PortfolioDataModel(
      name: 'Yousef Habbeh',
      location: 'Amman, Jordan',
      email: 'yousef.habbeh@hotmail.com',
      phone: '+962781543080',
      linkedinUrl: 'https://linkedin.com/in/yhabbeh/',
      githubUrl: 'https://github.com/yhabbeh',
      cvAsset: 'assets/pdf/Yousef_Habbeh_CV.pdf',
      profileImage: 'assets/images/profile_placeholder.png',
      heroHeadline: 'Mobile Software Engineer | Flutter Developer | AI Engineer',
      heroSubtitle: 'Building high-performance mobile applications with Flutter.',
      aboutDescription: 'Mobile Software Engineer and AI Specialist with professional experience.',
      aboutHighlights: ['Flutter Development', 'AI / Machine Learning'],
      experiences: [],
      skillCategories: [],
      projectCategories: [],
      certificationTitle: 'Tech for Jobs Professional Development for Tech Roles',
      awardTitle: '🏆 3rd Place — HAAC',
    );
  }
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();

    // Register mocks/stubs for Widget testing
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

    sl.registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(sharedPreferences: sl()),
    );

    sl.registerLazySingleton<PortfolioLocalDataSource>(
      () => MockPortfolioLocalDataSource(),
    );

    sl.registerLazySingleton<PortfolioRepository>(
      () => PortfolioRepositoryImpl(localDataSource: sl()),
    );

    sl.registerLazySingleton<GetPortfolioData>(
      () => GetPortfolioData(repository: sl()),
    );
    sl.registerLazySingleton<SubmitContact>(
      () => SubmitContact(repository: sl()),
    );

    sl.registerFactory<PortfolioBloc>(
      () => PortfolioBloc(getPortfolioData: sl()),
    );
    sl.registerFactory<ContactBloc>(
      () => ContactBloc(submitContact: sl()),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('Portfolio app loads and displays home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();
    // Wait for the mock delay/animation frames
    await tester.pumpAndSettle(const Duration(milliseconds: 800));

    // Verify name, location and headline text is found
    expect(find.text('Yousef Habbeh'), findsAtLeastNWidgets(1));
    expect(find.text('Mobile Software Engineer | Flutter Developer | AI Engineer'), findsOneWidget);
  });
}
