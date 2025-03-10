import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otp_resend_timer/otp_resend_timer.dart';

void main() {
  group('OtpResendTimerController Tests', () {
    late OtpResendTimerController controller;

    setUp(() {
      controller = OtpResendTimerController(initialTime: 10);
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state is correct', () {
      expect(controller.remainingTime, 10);
    });

    test('start() decreases remaining time', () async {
      controller.start();
      
      // Wait for timer to decrease
      await Future.delayed(const Duration(seconds: 2));
      
      // Time should decrease
      expect(controller.remainingTime, lessThan(10));
    });

    test('reset() sets time back to initial value', () async {
      controller.start();
      
      // Wait for timer to decrease
      await Future.delayed(const Duration(seconds: 2));
      
      // Time should decrease
      expect(controller.remainingTime, lessThan(10));
      
      // Reset timer
      controller.reset();
      
      // Time should be back to initial
      expect(controller.remainingTime, 10);
    });

    test('timeStream emits updates', () async {
      // Listen to stream and collect values
      final emittedValues = <int>[];
      final subscription = controller.timeStream.listen((value) {
        emittedValues.add(value);
      });
      
      // Start timer and wait for some ticks
      controller.start();
      await Future.delayed(const Duration(seconds: 2));
      
      // Clean up
      subscription.cancel();
      
      // Verify we received at least one update
      expect(emittedValues.length, greaterThan(0));
      // Last value should be less than the initial value
      expect(emittedValues.last, lessThan(10));
    });

    test('formattedTime returns correct format', () {
      expect(controller.formattedTime, '00:10');
    });
  });

  group('OtpResendTimer Widget Tests', () {
    testWidgets('shows timer on initialization',
        (WidgetTester tester) async {
      final controller = OtpResendTimerController(initialTime: 60);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpResendTimer(
              controller: controller,
            ),
          ),
        ),
      );
      
      // Should show hold message on initialization (not auto started)
      expect(find.text('Timer on hold. '), findsOneWidget);
      
      controller.dispose();
    });
    
    testWidgets('updates UI when timer completes',
        (WidgetTester tester) async {
      final controller = OtpResendTimerController(initialTime: 1);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpResendTimer(
              controller: controller,
              autoStart: true,
            ),
          ),
        ),
      );
      
      // Wait for timer to complete
      await tester.pump(const Duration(seconds: 2));
      
      // Should show ready message
      expect(find.text('You can now resend code'), findsOneWidget);
      
      controller.dispose();
    });
    
    testWidgets('shows ready message and enables resend when timer completes',
        (WidgetTester tester) async {
      final controller = OtpResendTimerController(initialTime: 1);
      bool resendClicked = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpResendTimer(
              controller: controller,
              autoStart: true,
              readyMessage: 'You can now resend the code',
              resendMessage: 'Resend Code',
              onResendClicked: () {
                resendClicked = true;
              },
            ),
          ),
        ),
      );
      
      // Wait for timer to complete
      await tester.pump(const Duration(seconds: 2));
      
      // Now check the ready message is displayed
      expect(find.text('You can now resend the code'), findsOneWidget);
      
      // Find and tap the resend button
      await tester.tap(find.text('Resend Code'));
      await tester.pump();
      
      // Verify onResendClicked callback was called
      expect(resendClicked, true);
      
      controller.dispose();
    });

    testWidgets('callbacks are triggered correctly',
        (WidgetTester tester) async {
      final controller = OtpResendTimerController(initialTime: 1);
      bool startCalled = false;
      bool finishCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpResendTimer(
              controller: controller,
              autoStart: true,
              onStart: () {
                startCalled = true;
              },
              onFinish: () {
                finishCalled = true;
              },
            ),
          ),
        ),
      );
      
      // Since autoStart is true, onStart should be called right away
      expect(startCalled, true);
      
      // Wait for timer to complete
      await tester.pump(const Duration(seconds: 2));
      
      // Check onFinish was called
      expect(finishCalled, true);
      
      controller.dispose();
    });

    testWidgets('autostart works correctly', (WidgetTester tester) async {
      final controller = OtpResendTimerController(initialTime: 5);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpResendTimer(
              controller: controller,
              autoStart: true,
            ),
          ),
        ),
      );
      
      // Should show timer message when autostart is true
      expect(find.textContaining('Resend code in'), findsOneWidget);
      
      controller.dispose();
    });
    
    testWidgets('can customize messages', (WidgetTester tester) async {
      final controller = OtpResendTimerController(initialTime: 5);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpResendTimer(
              controller: controller,
              timerMessage: 'Custom timer message',
              readyMessage: 'Custom ready message',
              holdMessage: 'Custom hold message',
              resendMessage: 'Custom resend',
            ),
          ),
        ),
      );
      
      // Should show custom hold message
      expect(find.text('Custom hold message'), findsOneWidget);
      
      // Start the timer
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();
      
      // Should show custom timer message
      expect(find.textContaining('Custom timer message'), findsOneWidget);
      
      controller.dispose();
    });
  });
}
