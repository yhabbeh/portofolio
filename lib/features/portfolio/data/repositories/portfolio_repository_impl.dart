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
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
