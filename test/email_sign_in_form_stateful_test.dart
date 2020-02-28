import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_form_stateful.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;
  setUp((){
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: EmailSignInFormStateful(),
          )
        ),
      )
    );
  }
  group('sign in', (){
    testWidgets('WHEN user doesn\'t enter the email and password'
      'AND user taps on the sign-in button'
      'THEN signInWithEmailAndPassword is not called', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);
      
      verifyNever(mockAuth.signInWithEmailAndPassword(email: anyNamed('email'), password: anyNamed('password')));
    });
    testWidgets('WHEN user enters the email and password'
      'AND user taps on the sign in button'
      'THEN signInWithEmailAndPassword is called', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      const email = 'email@test.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      final passwordField = find.byKey(Key('password'));
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.pump();
      
      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email: email, password: password)).called(1);
    });
  });
  
}