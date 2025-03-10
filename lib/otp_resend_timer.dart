/// A flexible and customizable OTP resend timer for Flutter applications.
///
/// This package provides a widget and controller for implementing OTP resend functionality
/// with customizable UI, animations, and callback support.
///
/// Example:
/// ```dart
/// OtpResendTimer(
///   controller: OtpResendTimerController(initialTime: 60),
///   timerMessage: 'Resend code in',
///   readyMessage: 'You can now resend the OTP',
///   onResendClicked: () {
///     // Handle resend action
///   },
///   autoStart: true,
/// )
/// ```
library otp_resend_timer;

export 'src/otp_resend_timer.dart';
export 'src/otp_resend_timer_controller.dart';
