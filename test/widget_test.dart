import 'package:flutter_test/flutter_test.dart';
import 'package:beauty_tracker/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PapillonNoteApp());
    await tester.pump();
  });
}
