import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  final double? gridWidth;
  final double? gridHeight;
  final double? gridBlockWidth;
  final double? gridBlockHeight;
  final List<Widget> elements;

  final bool? shrinkWrap;
  final bool? isScrollable;

  const ResponsiveGrid(
      {required this.gridWidth,
      this.gridHeight,
      required this.gridBlockWidth,
      this.gridBlockHeight,
      required this.elements,
      this.shrinkWrap = false,
      this.isScrollable});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.count(
      physics:
          NeverScrollableScrollPhysics(), // to disable GridView's scrolling
      shrinkWrap: shrinkWrap!,
      //Calculate CrossAxisCount
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: (gridWidth! ~/ (gridBlockWidth!)).toInt(),
      // Generate 100 widgets that display their index in the List.
      children: List.generate(elements.length, (index) {
        return Container(
            width: gridBlockWidth,
            height: gridBlockHeight,
            child: elements[index]);
      }),
    ));
  }
}
