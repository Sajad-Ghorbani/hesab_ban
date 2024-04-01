import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/features/feature_splash/presentation/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: kSurfaceColor,
      body: GetBuilder<SplashController>(
        builder: (SplashController controller) {
          return Stack(
            children: [
              Column(
                children: [
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: height / controller.fontSize),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 1000),
                    opacity: controller.textOpacity,
                    child: Text(
                      'حساب بان',
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: controller.animation.value,
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  opacity: controller.containerOpacity,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: width / controller.containerSize,
                    width: width / controller.containerSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset(
                      'assets/images/hesab_ban.png',
                      width: 200,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
