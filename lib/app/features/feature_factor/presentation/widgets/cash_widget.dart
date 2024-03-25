import 'package:flutter/material.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/params/cash_params.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CashWidget extends StatelessWidget {
  const CashWidget({
    super.key,
    required this.type,
    required this.customerName,
    required this.money,
    required this.onEditMenuTap,
    required this.onDeleteMenuTap,
  });

  final bool type;
  final String customerName;
  final CashParams money;
  final VoidCallback onEditMenuTap;
  final VoidCallback onDeleteMenuTap;

  @override
  Widget build(BuildContext context) {
    return BoxContainerWidget(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.dollar_square,
                  color: type ? kRedColor : kDarkGreenColor,
                ),
                const SizedBox(width: 5),
                Text(customerName),
                PopupMenuButton(
                  splashRadius: 1,
                  offset: const Offset(-10, 40),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: onEditMenuTap,
                        height: 40,
                        child: const Row(
                          children: [
                            Icon(
                              Iconsax.edit,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text('ویرایش'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: onDeleteMenuTap,
                        height: 40,
                        child: const Row(
                          children: [
                            Icon(
                              Iconsax.trash,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text('حذف'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
                const Spacer(),
                Text(
                  money.cashAmount!.abs().toString().seRagham(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: type ? kRedColor : kDarkGreenColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(money.cashDate.toString().toPersianDate()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
