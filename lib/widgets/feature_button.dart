import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeatureButton extends StatelessWidget {
  final String title;
  final String svgIconPath;
  final VoidCallback onTap;

  const FeatureButton({
    Key? key,
    required this.title,
    required this.svgIconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(7.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SvgPicture.asset(
              svgIconPath,
              width: 35,
              height: 35,
            ),
          ],
        ),
      ),
    );
  }
}
