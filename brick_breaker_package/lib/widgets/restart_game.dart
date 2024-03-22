import 'package:flutter/material.dart';

class RestartGame extends StatelessWidget{
  const RestartGame({super.key, required this.reStart});
  final Function() reStart;
  @override
  Widget build(context) {
    return InkWell(
      onTap: reStart,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
        child: Text(
          'Restart',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
          ),
        ),
      ),
    );
  }

}