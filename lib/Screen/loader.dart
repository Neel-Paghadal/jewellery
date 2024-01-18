import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum LoaderDirection {
  ltr,
  rtl,
  ttb,
  btt,
}

ShimmerDirection getDirection(LoaderDirection ldDirection) {
  ShimmerDirection direction;
  switch (ldDirection) {
    case LoaderDirection.ltr:
      direction = ShimmerDirection.ltr;
      break;
    case LoaderDirection.rtl:
      direction = ShimmerDirection.rtl;
      break;
    case LoaderDirection.ttb:
      direction = ShimmerDirection.ttb;
      break;
    case LoaderDirection.btt:
      direction = ShimmerDirection.btt;
      break;
    default:
      direction = ShimmerDirection.ltr;
  }
  return direction;
}

class Loaders extends StatelessWidget {
  final Color? baseColor, highLightColor;
  final int? items;
  final Widget? builder;
  final Duration? period;
  final LoaderDirection? direction;
  const Loaders(
      {Key? key,
        this.baseColor = const Color(0xFFE0E0E0),
        this.highLightColor = const Color(0xFFF5F5F5),
        this.period = const Duration(seconds: 2),
        this.direction,
        this.items,
        this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShimmerDirection shimmerDirection = getDirection(direction!);
    return Shimmer.fromColors(
      baseColor: baseColor!,
      highlightColor: highLightColor!,
      direction: shimmerDirection,
      period: period!,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items,
        itemBuilder: (_, __) => Container(
          child: builder,
        ),
      ),
    );
  }
}