import 'package:flutter/material.dart';

class Dice extends StatelessWidget {
  final void Function()? onTap;
  final int imageIndex;

  const Dice({Key? key, required this.imageIndex, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Image.asset(
          'assets/img/dice$imageIndex.png',
          fit: BoxFit.scaleDown,
          height: 200,
        ),
        onTap: onTap,
      ),
    );
  }
}
