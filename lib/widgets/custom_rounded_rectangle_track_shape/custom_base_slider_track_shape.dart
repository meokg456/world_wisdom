import 'package:flutter/material.dart';
import 'dart:math' as math;

abstract class CustomBaseSliderTrackShape {
  /// Returns a rect that represents the track bounds that fits within the
  /// [Slider].
  ///
  /// The width is the width of the [Slider] or [RangeSlider], but padded by
  /// the max  of the overlay and thumb radius. The height is defined by the
  /// [SliderThemeData.trackHeight].
  ///
  /// The [Rect] is centered both horizontally and vertically within the slider
  /// bounds.
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    assert(isEnabled != null);
    assert(isDiscrete != null);
    assert(parentBox != null);
    assert(sliderTheme != null);

    final double overlayWidth =
        sliderTheme.overlayShape.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop = offset.dy + parentBox.size.height - trackHeight;
    final double trackRight = trackLeft + parentBox.size.width - overlayWidth;
    final double trackBottom = parentBox.size.height;
    // If the parentBox'size less than slider's size the trackRight will be less than trackLeft, so switch them.
    return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop,
        math.max(trackLeft, trackRight), trackBottom);
  }
}
