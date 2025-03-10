

# 🔥 OTP Resend Timer 🔥

[![Pub Version](https://img.shields.io/pub/v/otp_resend_timer)](https://pub.dev/packages/otp_resend_timer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Preview
![ScreenRecording2025-03-10at2 15 20AM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/72cd08f6-5b64-4fae-9f31-c15cc0a7464a)


## ✨ Super Flexible OTP Resend Timer for Flutter!

Tired of building OTP verification screens from scratch? Say goodbye to that frustration! **OTP Resend Timer** is here to make your life easier! 🚀

![OTP Resend Timer Demo](https://via.placeholder.com/600x200/4CAF50/FFFFFF?text=OTP+Resend+Timer+Demo)

## 🌟 Features

- ⏱️ **Flexible Timer** - Fully customizable countdown timer
- 🎮 **Full Control** - Start and reset functionality with dedicated UI controls
- 🎨 **Beautiful UI** - Customizable styles and animations
- ✨ **Smooth Animations** - Elegant transitions between timer states
- 🧩 **Easy Integration** - Simple to implement in your Flutter apps
- 🧪 **Well Tested** - Comprehensive test coverage for reliability

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  otp_resend_timer: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Usage

Using OTP Resend Timer is super simple! Just import the package and add the widget to your build method:

```dart
import 'package:otp_resend_timer/otp_resend_timer.dart';

// Create a controller
final controller = OtpResendTimerController(initialTime: 30);

// Add the widget to your UI
OtpResendTimer(
  controller: controller,
  autoStart: true,
  timerMessage: "Resend OTP in ",
  readyMessage: "You can now resend the code",
  onFinish: () {},
  onResendClicked: () {},
  onStart: () {}
)
```

## 🎮 Controller Features

The `OtpResendTimerController` gives you full control over the timer:

```dart
// Start the timer
controller.start();

// restart the timer
controller.reset();

// Always dispose when done
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

## 🎨 Customization

Make it your own! The OTP Resend Timer is fully customizable:

```dart
OtpResendTimer(
controller: controller,
// Messages
timerMessage: "Resend in",
readyMessage: "Ready to resend!",
// would never show in case autoplay is true
holdMessage: "Timer paused",
resendMessage: "RESEND",

// Styles
timerMessageStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
readyMessageStyle: TextStyle(color: Colors.green),
holdMessageStyle: TextStyle(color: Colors.orange),
resendMessageStyle: TextStyle(color: Colors.purple, decoration: TextDecoration.underline),
resendMessageDisabledStyle: TextStyle(color: Colors.grey),

// Callbacks
onStart: () => print("Timer started"),
onFinish: () => print("Timer finished"),
onResendClicked: () => print("Resend clicked"),

// Auto-start the timer
autoStart: true,
)
```

## 📱 Examples

Check out the example folder for a complete working example:

## ❤️ Contributing

Contributions are always welcome! Please feel free to submit a PR.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

# 👨🏻‍💻 Author
### [Emad Beltaje](https://github.com/EmadBeltaje)

# 🧡 Support
Don't forget to like the [package](https://pub.dev/packages/otp_resend_timer) 👍🏻
and star the [repo](https://github.com/EmadBeltaje/otp_resend_timer) ⭐️