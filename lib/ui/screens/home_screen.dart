import 'package:accounting_app/controllers/home_controller.dart';
import 'package:accounting_app/models/check_model.dart';
import 'package:accounting_app/ui/screens/all_check_screen.dart';
import 'package:accounting_app/ui/theme/app_colors.dart';
import 'package:accounting_app/ui/widgets/base_widget.dart';
import 'package:accounting_app/ui/widgets/box_container_widget.dart';
import 'package:accounting_app/ui/widgets/check_container_widget.dart';
import 'package:accounting_app/ui/widgets/customers_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../routes/app_pages.dart';
import '../widgets/grid_menu_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'حساب بان',
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GridMenuWidget(
                        title: 'ایجاد حساب جدید',
                        onTap: () {
                          Get.toNamed(Routes.createCustomerScreen);
                        },
                      ),
                      GridMenuWidget(
                        title: 'ورود چک',
                        onTap: () {
                          Get.toNamed(Routes.createCheckScreen);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.moneyCheck,
                        color: kDarkGreenColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('لیست چک های دریافتی'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          BoxContainerWidget(
            child: CheckContainerWidget(
              typeOfCheck: TypeOfCheck.received,
              onRowTapped: (bool? selected) {},
              onSeeAll: () {
                pushNewScreen(
                  context,
                  screen: const AllCheckScreen(TypeOfCheck.received),
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.moneyCheck,
                        color: kRedColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('لیست چک های پرداختی'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          BoxContainerWidget(
            child: CheckContainerWidget(
              typeOfCheck: TypeOfCheck.send,
              onRowTapped: (bool? selected) {},
              onSeeAll: () {
                pushNewScreen(
                  context,
                  screen: const AllCheckScreen(TypeOfCheck.send),
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.addressCard,
                        color: kOrangeColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('لیست مشتریان'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const BoxContainerWidget(
            child: CustomersContainerWidget(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 75,
            ),
          ),
        ],
      ),
    );
  }
}
