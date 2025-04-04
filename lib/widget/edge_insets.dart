import 'package:flutter/material.dart';

///padding
class XEdgeInsets extends EdgeInsets{

  const XEdgeInsets({
    double? all,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) : super.only(
      left: left ?? horizontal ?? all ?? 0,
      top: top ?? vertical ?? all ?? 0,
      right: right ?? horizontal ?? all ?? 0,
      bottom: bottom ?? vertical ?? all ?? 0,
  );

  static XEdgeInsets get zero => const XEdgeInsets();
}
