import '../../../../core/services/email_service.dart';
import '../../domain/entities/portfolio_data.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_data_source.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource localDataSource;
  final EmailService emailService;

  const PortfolioRepositoryImpl({
    required this.localDataSource,
    required this.emailService,
  });

  @override
  Future<PortfolioData> getPortfolioData() {
    return localDataSource.getPortfolioData();
  }

  @override
  Future<void> submitContactForm(String name, String email, String message) async {
    await emailService.send(name: name, email: email, message: message);
  }
}
