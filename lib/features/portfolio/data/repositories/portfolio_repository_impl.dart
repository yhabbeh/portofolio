import '../../domain/entities/portfolio_data.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_data_source.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource localDataSource;

  const PortfolioRepositoryImpl({required this.localDataSource});

  @override
  Future<PortfolioData> getPortfolioData() {
    return localDataSource.getPortfolioData();
  }

  @override
  Future<void> submitContactForm(String name, String email, String message) async {
    // Simulate a network post request with loading time
    await Future.delayed(const Duration(seconds: 1));

    // Support simulated errors for testing validation flows
    if (name.toLowerCase().contains('error') || email.toLowerCase().contains('error')) {
      throw Exception('Simulated API gateway error. Please try again.');
    }
  }
}
