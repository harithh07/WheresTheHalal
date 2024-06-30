import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wheres_the_halal/main.dart' as app;
import 'package:wheres_the_halal/pages/home_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end to end test', () {

    testWidgets('failed login with wrong user and password', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final emailFinder = find.byKey(Key('email_controller'));
      final pwFinder = find.byKey(Key('pw_controller'));
      expect(emailFinder, findsOneWidget);
      expect(pwFinder, findsOneWidget);
      await tester.enterText(emailFinder, 'test@gmail.com');

      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(pwFinder, '321tset');

      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.byKey(Key('signin_button')));
      await tester.pumpAndSettle();

      final dialogFinder = find.byType(AlertDialog);
      expect(dialogFinder, findsOneWidget);
      print('Failed to login');
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(dialogFinder);
      // await Future.delayed(const Duration(seconds: 1));
      // await tester.pumpAndSettle();
    });



    testWidgets('verify login screen with correct username and password', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // await tester.tap(find.byKey(Key('signout_button')));
      // await tester.pumpAndSettle();

      expect(find.byKey(Key('email_controller')), findsOneWidget);
      expect(find.byKey(Key('pw_controller')), findsOneWidget);
      await tester.enterText(find.byKey(Key('email_controller')), 'test@gmail.com');

      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(find.byKey(Key('pw_controller')), 'test123');

      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.byKey(Key('signin_button')));
      await tester.pumpAndSettle();

      print('Successfully logged in');
      await Future.delayed(const Duration(seconds: 2));

      final mapFinder = find.byType(GoogleMap);
      expect(mapFinder, findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);

      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.byKey(Key('signout_button')));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      print('Successfully logged out');


    });
    

    
  });
}

