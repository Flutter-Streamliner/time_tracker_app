import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_app/app/widgets/custom_raised_button.dart';

void main() {
  testWidgets('', (WidgetTester tester) async {
    final app = MaterialApp(home: CustomRaisedButton(
      child: Text('Tap me'),
    ));
    await tester.pumpWidget(app);
    final button = find.byType(RaisedButton);
    expect(button, findsOneWidget);
    expect(find.byType(FlatButton), findsNothing);
    expect(find.text('Tap me'), findsOneWidget);
  });

}