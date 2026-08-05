import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/src/enums/enums.dart';

abstract class AlignmentUtil {
  static CrossAxisAlignment crossAxisAlignmentFromName(
    AxisAlignment? crossAxisAlignmentName,
  ) {
    switch (crossAxisAlignmentName) {
      case AxisAlignment.start:
        return CrossAxisAlignment.start;
      case AxisAlignment.end:
        return CrossAxisAlignment.end;
      case AxisAlignment.center:
        return CrossAxisAlignment.center;
      case AxisAlignment.stretch:
        return CrossAxisAlignment.stretch;
      case AxisAlignment.baseline:
        return CrossAxisAlignment.baseline;
      case null:
        return CrossAxisAlignment.center;
      case AxisAlignment.spaceBetween:
        return CrossAxisAlignment.center;
      case AxisAlignment.spaceAround:
        return CrossAxisAlignment.center;
      case AxisAlignment.spaceEvenly:
        return CrossAxisAlignment.center;
    }
  }

  static MainAxisAlignment mainAxisAlignmentFromName(
    AxisAlignment? mainAxisAlignmentName,
  ) {
    switch (mainAxisAlignmentName) {
      case AxisAlignment.start:
        return MainAxisAlignment.start;
      case AxisAlignment.end:
        return MainAxisAlignment.end;
      case AxisAlignment.center:
        return MainAxisAlignment.center;
      case AxisAlignment.spaceEvenly:
        return MainAxisAlignment.spaceEvenly;
      case AxisAlignment.spaceBetween:
        return MainAxisAlignment.spaceBetween;
      case AxisAlignment.spaceAround:
        return MainAxisAlignment.spaceAround;
      case null:
        return MainAxisAlignment.start;
      case AxisAlignment.baseline:
        return MainAxisAlignment.start;
      case AxisAlignment.stretch:
        return MainAxisAlignment.start;
    }
  }

  static AlignmentDirectional alignmentDirectionFromName(
    WidgetAlignment? widgetAlignmentName,
  ) {
    switch (widgetAlignmentName) {
      case WidgetAlignment.center:
        return AlignmentDirectional.center;
      case WidgetAlignment.centerStart:
        return AlignmentDirectional.centerStart;
      case WidgetAlignment.centerEnd:
        return AlignmentDirectional.centerEnd;
      case WidgetAlignment.topStart:
        return AlignmentDirectional.topStart;
      case WidgetAlignment.topCenter:
        return AlignmentDirectional.topCenter;
      case WidgetAlignment.topEnd:
        return AlignmentDirectional.topEnd;
      case WidgetAlignment.bottomCenter:
        return AlignmentDirectional.bottomCenter;
      case WidgetAlignment.bottomStart:
        return AlignmentDirectional.bottomStart;
      case WidgetAlignment.bottomEnd:
        return AlignmentDirectional.bottomEnd;
      case null:
        return AlignmentDirectional.center;
    }
  }

  static TextAlign? textAlign(TextWidgetAlign? textWidgetAlign) {
    switch (textWidgetAlign) {
      case TextWidgetAlign.center:
        return TextAlign.center;
      case TextWidgetAlign.start:
        return TextAlign.start;
      case TextWidgetAlign.end:
        return TextAlign.end;
      case TextWidgetAlign.left:
        return TextAlign.left;
      case TextWidgetAlign.right:
        return TextAlign.right;
      case TextWidgetAlign.justify:
        return TextAlign.justify;

      case null:
        return null;
      default:
        return null;
    }
  }
}

abstract class AxisUtil {
  static MainAxisSize mainAxisSizeFromName(AxisSize? mainAxisSiz) {
    switch (mainAxisSiz) {
      case AxisSize.min:
        return MainAxisSize.min;
      case AxisSize.max:
        return MainAxisSize.max;
      case null:
        return MainAxisSize.max;
    }
  }
}
