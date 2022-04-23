import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/data/models/check_model.dart';
import 'package:hesab_ban/ui/screens/all_check_screen.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/sliver_box_container_widget.dart';
import 'package:hesab_ban/ui/widgets/check_container_widget.dart';
import 'package:hesab_ban/ui/widgets/customers_container_widget.dart';
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
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        GridMenuWidget(
                          title: 'ایجاد حساب جدید',
                          onTap: () {
                            Get.toNamed(Routes.createCustomerScreen);
                          },
                          width: MediaQuery.of(context).size.width / 2 - 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GridMenuWidget(
                          title: 'ورود چک',
                          onTap: () {
                            Get.toNamed(Routes.createCheckScreen);
                          },
                          width: MediaQuery.of(context).size.width / 2 - 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GridMenuWidget(
                          title: 'ورود وجه نقد',
                          onTap: () {
                            controller.inputCash();
                          },
                          width: MediaQuery.of(context).size.width / 2 - 25,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
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
                  ),
                ],
              ),
            ),
          SliverBoxContainerWidget(
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
          SliverBoxContainerWidget(
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
          const SliverBoxContainerWidget(
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
