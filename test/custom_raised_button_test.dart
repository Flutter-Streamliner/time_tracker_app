import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_app/app/widgets/custom_raised_button.dart';

void main() {
  testWidgets('onPressed callback', (WidgetTester tester) async {
    var pressed = false;
    final app = MaterialApp(home: CustomRaisedButton(
      child: Text('Tap me'),
      onPressed: () => pressed = true,
    ));
    await tester.pumpWidget(app);
    final button = find.byType(RaisedButton);
    expect(button, findsOneWidget);
    expect(find.byType(FlatButton), findsNothing);
    expect(find.text('Tap me'), findsOneWidget);
    await tester.tap(button);
    expect(pressed, true);
  });

}