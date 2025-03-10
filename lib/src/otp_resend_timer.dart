import 'package:flutter/material.dart';
import 'package:otp_resend_timer/src/otp_resend_timer_controller.dart';

class OtpResendTimer extends StatefulWidget {
  // Controller and callbacks
  final OtpResendTimerController controller;
  final Function()? onFinish;
  final Function()? onStop;
  final Function()? onStart;
  final Function()? onResendClicked;

  // Messages and their styles
  final String? timerMessage;
  final TextStyle? timerMessageStyle;
  final String? readyMessage;
  final TextStyle? readyMessageStyle;
  final String? holdMessage;
  final TextStyle? holdMessageStyle;

  // Resend button
  final String? resendMessage;
  final TextStyle? resendMessageStyle;
  final TextStyle? resendMessageDisabledStyle;

  // Whether to automatically start the timer on initialization
  final bool autoStart;

  const OtpResendTimer({
    super.key,
    required this.controller,
    this.onFinish,
    this.onStop,
    this.onStart,
    this.timerMessage,
    this.timerMessageStyle,
    this.readyMessage,
    this.readyMessageStyle,
    this.holdMessage,
    this.holdMessageStyle,
    this.resendMessage,
    this.resendMessageStyle,
    this.resendMessageDisabledStyle,
    this.onResendClicked,
    this.autoStart = false,
  });

  @override
  State<OtpResendTimer> createState() => _OtpResendTimerState();
}

class _OtpResendTimerState extends State<OtpResendTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isTimerComplete = false;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.controller.initialTime,
      ),
    );

    _animation = Tween<double>(
      begin: widget.controller.initialTime.toDouble(),
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isTimerComplete = true;
          _isTimerRunning = false;
        });
        widget.onFinish?.call();
      } else if (status == AnimationStatus.forward) {
        setState(() {
          _isTimerRunning = true;
        });
        widget.onStart?.call();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _isTimerRunning = false;
        });
        widget.onStop?.call();
      }
    });

    if (widget.autoStart) {
      _startTimer();
    }
  }

  void _startTimer() {
    widget.controller.start();
    _animationController.forward(from: 0);
    setState(() {
      _isTimerComplete = false;
      _isTimerRunning = true;
    });
  }

  void _resetTimer() {
    _animationController.reset();
    widget.controller.reset();
    setState(() {
      _isTimerComplete = false;
      _isTimerRunning = false;
    });
  }

  void _handleResendClick() {
    if (_isTimerComplete) {
      _resetTimer();
      _startTimer();
      widget.onResendClicked?.call();
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define default styles
    final defaultTimerMessageStyle = TextStyle(
      color: theme.primaryColor,
      fontSize: 12,
    );

    final defaultReadyMessageStyle = TextStyle(
      color: theme.primaryColor,
      fontSize: 12,
    );

    final defaultHoldMessageStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 12,
    );

    final defaultResendActiveStyle = TextStyle(
      color: theme.primaryColor,
      fontSize: 12,
    );

    const defaultResendDisabledStyle = TextStyle(
      color: Colors.grey,
      fontSize: 12,
    );

    return StreamBuilder<int>(
      stream: widget.controller.timeStream,
      initialData: widget.controller.remainingTime,
      builder: (context, snapshot) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main content area with animated transitions
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildTimerContent(defaultHoldMessageStyle,
                  defaultTimerMessageStyle, defaultReadyMessageStyle),
            ),

            const SizedBox(width: 2),

            // Resend button with animation
            AnimatedOpacity(
              opacity: _isTimerComplete ? 1.0 : 0.6,
              duration: const Duration(milliseconds: 300),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: _isTimerComplete ? 8.0 : 0.0,
                  vertical: _isTimerComplete ? 4.0 : 0.0,
                ),
                child: GestureDetector(
                  onTap: _isTimerComplete ? _handleResendClick : null,
                  child: Text(
                    widget.resendMessage ?? "Resend",
                    style: _isTimerComplete
                        ? (widget.resendMessageStyle ??
                            defaultResendActiveStyle)
                        : (widget.resendMessageDisabledStyle ??
                            defaultResendDisabledStyle),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Extracted method to build the timer content based on current state
  Widget _buildTimerContent(
    TextStyle defaultHoldMessageStyle,
    TextStyle defaultTimerMessageStyle,
    TextStyle defaultReadyMessageStyle,
  ) {
    if (!_isTimerRunning && !_isTimerComplete) {
      // Hold state (not started yet)
      return Row(
        key: const ValueKey('hold_state'),
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.holdMessage ?? "Timer on hold. ",
            style: widget.holdMessageStyle ?? defaultHoldMessageStyle,
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _startTimer,
            visualDensity: VisualDensity.compact,
          ),
        ],
      );
    } else if (_isTimerComplete) {
      // Timer completed state
      return Text(
        widget.readyMessage ?? "You can now resend otp",
        key: const ValueKey('complete_state'),
        style: widget.readyMessageStyle ?? defaultReadyMessageStyle,
      );
    } else {
      // Timer running state
      return AnimatedBuilder(
          key: const ValueKey('running_state'),
          animation: _animation,
          builder: (context, child) {
            final displayValue = _animation.value.round();
            return Text(
              '${widget.timerMessage ?? "Resend otp in "} ${_formatTime(displayValue)}',
              style: widget.timerMessageStyle ?? defaultTimerMessageStyle,
            );
          });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
