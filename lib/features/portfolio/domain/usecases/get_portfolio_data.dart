import '../entities/portfolio_data.dart';
import '../repositories/portfolio_repository.dart';

class GetPortfolioData {
  final PortfolioRepository repository;

  const GetPortfolioData({required this.repository});

  Future<PortfolioData> call() {
    return repository.getPortfolioData();
  }
}
