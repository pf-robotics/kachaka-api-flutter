import 'package:flutter/cupertino.dart';
import 'package:kachaka_api/kachaka_api.dart';

class PinModel {
  final Pose pose;

  // pixel: from left, from bottom
  final Offset pinCenterOffset;

  final bool shouldScale;

  final Function? onTap;

  final Widget child;

  PinModel({
    required this.pose,
    required this.pinCenterOffset,
    this.onTap,
    required this.child,
    this.shouldScale = true,
  });
}
