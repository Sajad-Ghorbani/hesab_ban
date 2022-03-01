import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/ui/screens/search_check_screen.dart';
import 'package:hesab_ban/ui/widgets/base_widget.dart';
import 'package:hesab_ban/ui/widgets/box_container_widget.dart';
import 'package:hesab_ban/ui/widgets/check_container_widget.dart';
import 'package:hesab_ban/ui/widgets/scroll_to_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search_controller.dart';
import '../../routes/app_pages.dart';
import '../widgets/grid_menu_widget.dart';
import '../widgets/search_box_widget.dart';

class AllCheckScreen extends GetView<HomeController> {
  const AllCheckScreen(this.typeOfCheck, {Key? key}) : super(key: key);
  final TypeOfCheck typeOfCheck;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: typeOfCheck == TypeOfCheck.send
          ? 'لیست چکهای پرداختی'
          : 'لیست چکهای دریافتی',
      appBarLeading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        splashRadius: 30,
      ),
      child: ScrollToUp(
        showFab: controller.showCheckFab,
        scrollController: controller.checkScreenScrollController,
        child: CustomScrollView(
          controller: controller.checkScreenScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: GridMenuWidget(
                  title: 'ورود چک',
                  onTap: () {
                    Get.toNamed(Routes.createCheckScreen);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SearchBoxWidget(
                searchText: 'جست و جو',
                openBuilderWidget: SearchCheckScreen(typeOfCheck: typeOfCheck,),
                onClosed: (value) {
                  Get.find<SearchController>().clearScreen();
                },
              ),
            ),
            GetBuilder<HomeController>(
              builder: (controller) {
                return BoxContainerWidget(
                  child: CheckContainerWidget(
                    typeOfCheck: typeOfCheck,
                    onRowTapped: (selected) {},
                    miniDataTable: false,
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 75,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
