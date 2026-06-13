import '../entities/portfolio_data.dart';

abstract class PortfolioRepository {
  Future<PortfolioData> getPortfolioData();
  Future<void> submitContactForm(String name, String email, String message);
}
