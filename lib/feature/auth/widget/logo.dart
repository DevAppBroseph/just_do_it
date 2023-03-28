import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/constants.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      SvgImg.justDoIt,
    );
  }
}
