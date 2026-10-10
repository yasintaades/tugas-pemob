import 'package:flutter_test/flutter_test.dart';
import 'package:pemob_app/main.dart';

void main() {
  testWidgets('MyApp loads and displays Biodata Mahasiswa',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Biodata Mahasiswa'), findsOneWidget);
  });
}
