import 'package:flutter/material.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.textEditingController,
    required this.onChanged,
  });
  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(
                  color: isDark ? kGreyColor : kSurfaceLightColor,
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).cardColor.withOpacity(0.4),
                    Theme.of(context).colorScheme.surface.withOpacity(0.4),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      onTap: () {
                        if (textEditingController.selection ==
                            TextSelection.fromPosition(TextPosition(
                                offset:
                                textEditingController.text.length - 1))) {
                          textEditingController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: textEditingController.text.length));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
