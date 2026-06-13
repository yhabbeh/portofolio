import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/app.dart';

void main() {
  testWidgets('Portfolio app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Yousef Habbeh'), findsAtLeastNWidgets(1));
    expect(find.text('Mobile Software Engineer | Flutter Developer | AI Engineer'),
        findsOneWidget);
  });
}
