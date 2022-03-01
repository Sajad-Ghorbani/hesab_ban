import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/constants_app_styles.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    Key? key,
    required this.textEditingController,
    required this.onChanged,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(
                  color: kGreyColor,
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  colors: [
                    kGreyColor.withOpacity(0.4),
                    kSurfaceColor.withOpacity(0.4),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: kOrangeColor,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      decoration: kCustomInputDecoration,
                      autofocus: true,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ],
        ),
      ),
    );
  }
}
