import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';

class ActionButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.backgroundNavbar,
          borderRadius: BorderRadius.circular(20),
        ),
        child: icon,
      ),
    );
  }
}
