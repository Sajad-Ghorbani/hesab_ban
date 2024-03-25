import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectFactorWidget extends StatelessWidget {
  const SelectFactorWidget({
    Key? key,
    required this.factorName,
    required this.detailList,
    required this.onFactorTap,
    required this.cardColor,
  }) : super(key: key);
  final String factorName;
  final List<String> detailList;
  final VoidCallback onFactorTap;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: cardColor.withOpacity(0.6),
          child: InkWell(
            onTap: onFactorTap,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/bill.png',
                    width: Get.width * 0.2,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          'فاکتور $factorName',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
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
                              width: Get.width * 0.7 - 65,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
