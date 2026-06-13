import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/portfolio/data/datasources/portfolio_local_data_source.dart';
import '../../features/portfolio/data/repositories/portfolio_repository_impl.dart';
import '../../features/portfolio/domain/repositories/portfolio_repository.dart';
import '../../features/portfolio/domain/usecases/get_portfolio_data.dart';
import '../../features/portfolio/domain/usecases/submit_contact.dart';
import '../../features/portfolio/presentation/blocs/contact/contact_bloc.dart';
import '../../features/portfolio/presentation/blocs/portfolio/portfolio_bloc.dart';
import '../../features/theme/presentation/bloc/theme_cubit.dart';
import '../services/email_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Services
  sl.registerLazySingleton<EmailService>(() => EmailService());

  // Features - Theme
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(sharedPreferences: sl()),
  );

  // Features - Portfolio - Data Sources
  sl.registerLazySingleton<PortfolioLocalDataSource>(
    () => PortfolioLocalDataSourceImpl(),
  );

  // Features - Portfolio - Repositories
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(
      localDataSource: sl(),
      emailService: sl(),
    ),
  );

  // Features - Portfolio - Usecases
  sl.registerLazySingleton<GetPortfolioData>(
    () => GetPortfolioData(repository: sl()),
  );
  sl.registerLazySingleton<SubmitContact>(
    () => SubmitContact(repository: sl()),
  );

  // Features - Portfolio - Blocs
  sl.registerFactory<PortfolioBloc>(
    () => PortfolioBloc(getPortfolioData: sl()),
  );
  sl.registerFactory<ContactBloc>(
    () => ContactBloc(submitContact: sl()),
  );
}
