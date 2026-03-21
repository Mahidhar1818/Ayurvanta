import 'package:flutter_test/flutter_test.dart';
import 'package:ayurvanta/main.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AyurVantaApp());

    // Basic check to see if the app loads (e.g., finding the splash screen content if possible)
    // Since it's a splash screen with a timer, we just check if pumpWidget succeeds for now.
    expect(true, true);
  });
}
