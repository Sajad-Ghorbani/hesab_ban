import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SelectFactorWidget extends StatelessWidget {
  const SelectFactorWidget({
    Key? key,
    required this.factorName,
    required this.detailList,
    required this.onFactorTap,
    required this.cardColor,
    required this.lottieAddress,
  }) : super(key: key);
  final String factorName;
  final List<String> detailList;
  final VoidCallback onFactorTap;
  final Color cardColor;
  final String lottieAddress;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      color: cardColor,
      child: InkWell(
        onTap: onFactorTap,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Container(
          width: Get.width / 2 - 20,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Lottie.asset(
                lottieAddress,
                repeat: false,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'فاکتور $factorName',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 20,
              ),
              for (var item in detailList) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.check,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: Get.width / 2 - 65,
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
