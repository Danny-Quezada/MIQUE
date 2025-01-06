import 'package:flutter/material.dart';
import 'package:mi_que/ui/utils/setting_color.dart';

class LogoWidget extends StatelessWidget {
  double width;
  double height;

  LogoWidget({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
          color: SettingColor.principalColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: const Center(
          child: Text("MQ",
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ))),
    );
  }
}
