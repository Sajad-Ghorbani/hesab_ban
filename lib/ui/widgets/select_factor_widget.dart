import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

class SelectFactorWidget extends StatelessWidget {
  const SelectFactorWidget({
    Key? key,
    required this.factorName,
    required this.detailList,
    required this.showHelp,
    required this.onFactorTap,
    required this.showChanged,
    required this.cardColor,
  }) : super(key: key);
  final String factorName;
  final List<String> detailList;
  final bool showHelp;
  final VoidCallback onFactorTap;
  final VoidCallback showChanged;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      color: showHelp ? Colors.transparent : cardColor,
      child: InkWell(
        onTap: showHelp ? null : onFactorTap,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: FlipCard(
          fill: Fill.fillFront,
          direction: FlipDirection.HORIZONTAL,
          flipOnTouch: showHelp,
          front: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: showHelp ? cardColor : Colors.transparent,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                'فاکتور $factorName',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          back: Container(
            width: Get.width / 2 - 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: kBlueColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
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
                          width: Get.width / 2 - 55,
                          child: Text(
                            item,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                  InkWell(
                    onTap: showChanged,
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 0.7,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: !showHelp,
                              onChanged: (value){
                                showChanged();
                              },
                              fillColor:
                                  MaterialStateProperty.all(kDarkGreyColor),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: Get.width / 2 - 55,
                          child: Text(
                            'متوجه شدم، دیگه نمایش نده.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: onFactorTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 15),
                      decoration: const BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        'فاکتور $factorName',
                      ),
                    ),
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
