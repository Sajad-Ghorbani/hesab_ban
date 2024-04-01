import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
    this.child = const SizedBox.shrink(),
    this.showLoading = false,
    this.backgroundColor,
  });
  final Widget child;
  final bool showLoading;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        showLoading
            ? Container(
                color: backgroundColor ?? Colors.black87.withOpacity(0.7),
                child: Center(
                  child: Lottie.asset(
                    'assets/loading.json',
                    width: 150,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
