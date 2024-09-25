import 'package:flutter/material.dart';

class SliverDelegateWidget extends SliverPersistentHeaderDelegate {
  Widget child;
  double? height;
  SliverDelegateWidget({required this.child, this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height!;

  @override
  double get minExtent => height!;

  @override
  bool shouldRebuild(SliverDelegateWidget oldDelegate) {
    return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
  }
}