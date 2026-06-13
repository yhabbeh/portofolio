import '../repositories/portfolio_repository.dart';

class SubmitContact {
  final PortfolioRepository repository;

  const SubmitContact({required this.repository});

  Future<void> call({
    required String name,
    required String email,
    required String message,
  }) {
    return repository.submitContactForm(name, email, message);
  }
}
