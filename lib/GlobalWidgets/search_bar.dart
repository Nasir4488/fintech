import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/GlobalWidgets/input_field.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import 'package:fin_tech/Utils/extension.dart';

class SearchBarExpander extends StatefulWidget {
  final ValueChanged<String>? onSearch;
  final TextEditingController? controller;
  final VoidCallback? onClose;

  const SearchBarExpander({this.onSearch, this.controller, this.onClose, super.key});

  @override
  State<SearchBarExpander> createState() => _SearchBarExpanderState();
}

class _SearchBarExpanderState extends State<SearchBarExpander> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isExpanded ? Get.width : 0,
          constraints: BoxConstraints(maxWidth: Get.width - 20), // Limit the maximum width
          child: isExpanded
              ? AppFormField(
                  controller: widget.controller,
                  onChange: widget.onSearch,
                  hintText: 'Search Address Here',
                  suffix: Icon(
                    Icons.cancel,
                    color: primaryColor,
                  ).onTap(() {
                    setState(() {
                      isExpanded = false;
                      if (widget.onClose != null) {
                        widget.onClose!();
                      }
                    });
                  }),
                )
              : null,
        ),
        if (!isExpanded)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = true;
              });
            },
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: primaryColor,
                ).paddingOnly(right: 20),
                Text(
                  "Search Address Here",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: primaryColor1,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
