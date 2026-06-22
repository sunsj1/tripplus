import 'package:flutter/material.dart';

/// Horizontally scrolling row whose height follows the tallest child.
///
/// Prefer this over a fixed-height [SizedBox] wrapping a horizontal [ListView]
/// when card content can grow with text scale factor or long labels.
class HorizontalScrollRow extends StatelessWidget {
  const HorizontalScrollRow({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.separator = 10,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double separator;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < itemCount; i++) ...[
            if (i > 0) SizedBox(width: separator),
            itemBuilder(context, i),
          ],
        ],
      ),
    );
  }
}
