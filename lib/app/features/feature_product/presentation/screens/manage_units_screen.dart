import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/core/widgets/base_widget.dart';
import 'package:hesab_ban/app/core/widgets/box_container_widget.dart';
import 'package:hesab_ban/app/core/widgets/confirm_button.dart';
import 'package:hesab_ban/app/core/widgets/custom_text_field.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/controller/product_controller.dart';
import 'package:iconsax/iconsax.dart';

class ManageUnitsScreen extends GetView<ProductController> {
  const ManageUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      showLeading: true,
      onLeadingTap: () {
        controller.resetUnitScreen();
      },
      titleText: 'مدیریت واحد کالا',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<ProductController>(
              builder: (_) {
                return BoxContainerWidget(
                  backBlur: false,
                  child: Container(
                    height: 300,
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: controller.units.length,
                      itemBuilder: (context, index) {
                        var unit = controller.units[index];
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Text(unit.name!),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Iconsax.trash,
                                ),
                                color: Colors.red,
                                onPressed: () {
                                  StaticMethods.deleteDialog(
                                    content: 'شما در حال پاک کردن '
                                        '"${unit.name}"'
                                        ' هستید. آیا اطمینان دارید؟\n'
                                        'این عمل برگشت پذیر نیست.',
                                    onConfirm: () {
                                      controller.deleteUnit(unit.id!);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            controller.editUnit(unit);
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const Divider(thickness: 1.2),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GetBuilder<ProductController>(
                      builder: (_) {
                        return Text(
                            controller.editUnitId != -1
                                ? 'ویرایش واحد کالا'
                                : 'افزودن واحد جدید',
                            style: Theme.of(context).textTheme.bodyMedium);
                      },
                    ),
                    Row(
                      children: [
                        const Text('نام'),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.unitNameController,
                            focusNode: controller.unitNode,
                          ),
                        ),
                        ConfirmButton(
                          onTap: () {
                            controller.editUnitId == -1
                                ? controller.saveUnit()
                                : controller.updateUnit();
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      color: kDarkGreyColor,
                      height: 10,
                      thickness: 1.2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
