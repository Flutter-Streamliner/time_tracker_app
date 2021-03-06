import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_page.dart';

import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  MockNavigatorObserver mockNavigator;

  setUp((){
    mockAuth = MockAuth();
    mockNavigator = MockNavigatorObserver();
  });

  Future<void> pumpSignInPage(WidgetTester tester) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Builder(
          builder: (context) => SignInPage.create(context) ,
        ),
        navigatorObservers: [mockNavigator],
      ),
    ));
    verify(mockNavigator.didPush(any, any)).called(1);
  }

  testWidgets('email & password navigation', (WidgetTester tester) async {
    await pumpSignInPage(tester);
    
    final emailSignInButton = find.byKey(SignInPage.emailPasswordKey);
    expect(emailSignInButton, findsOneWidget);
    await tester.tap(emailSignInButton);
    await tester.pumpAndSettle();

    verify(mockNavigator.didPush(any, any)).called(1);
  });
}