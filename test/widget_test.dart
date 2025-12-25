import 'package:flutter_test/flutter_test.dart';
import 'package:duplicate_file_finder/main.dart';

void main() {
  testWidgets('App launches and displays title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is displayed.
    expect(find.text('Duplicate File Finder'), findsOneWidget);
  });
}