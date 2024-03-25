import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/features/feature_password/presentation/controller/password_controller.dart';
import 'package:hesab_ban/app/features/feature_password/presentation/widgets/pass_bullet_widget.dart';
import 'package:hesab_ban/app/features/feature_password/presentation/widgets/pass_key_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class PasswordScreen extends GetView<PasswordController> {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 20.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller.failedAnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.failedAnimationController.reverse();
        }
      });
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<PasswordController>(
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'رمز عبور خود را وارد کنید',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // const SizedBox(height: 20),
                AnimatedCrossFade(
                  firstChild: AnimatedBuilder(
                    animation: offsetAnimation,
                    builder: (BuildContext context, Widget? child) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: offsetAnimation.value + 20,
                            right: 20 - offsetAnimation.value),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return PassBulletWidget(
                              color: controller.passCorrected
                                  ? kGreenColor
                                  : controller.passFailed
                                      ? kRedColor
                                      : index + 1 <= controller.password.length
                                          ? Colors.black45
                                          : null,
                            );
                          }),
                        ),
                      );
                    },
                  ),
                  secondChild: Lottie.asset(
                    'assets/success_anim.json',
                    width: 80,
                    height: 80,
                    frameRate: FrameRate.max,
                    controller: controller.animationController,
                  ),
                  crossFadeState: controller.passCorrected
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  layoutBuilder:
                      (topChild, topChildKey, bottomChild, bottomChildKey) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        topChild,
                        bottomChild,
                      ],
                    );
                  },
                  duration: const Duration(milliseconds: 400),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return PassKeyWidget(
                      num: index + 1,
                      onTap: (value) {
                        controller.checkPassword(value!);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return PassKeyWidget(
                      num: index + 4,
                      onTap: (value) {
                        controller.checkPassword(value!);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return PassKeyWidget(
                      num: index + 7,
                      onTap: (value) {
                        controller.checkPassword(value!);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PassKeyWidget(
                      icon: Icon(
                        Iconsax.tag_cross,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 30,
                      ),
                      onTap: (value) {
                        if (controller.password.isNotEmpty) {
                          controller.password.removeLast();
                          controller.update();
                        }
                      },
                    ),
                    PassKeyWidget(
                      num: 0,
                      onTap: (value) {
                        controller.checkPassword(value!);
                      },
                    ),
                    PassKeyWidget(
                      icon: Image.asset(
                        'assets/images/fingerprint.png',
                        height: 40,
                        width: 40,
                        color: Colors.white,
                      ),
                      onTap: (value) async {
                        await controller.localAuth();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
