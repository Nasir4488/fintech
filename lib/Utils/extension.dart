import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fin_tech/Provider/theme_provider.dart';

extension IntToBigInt on int {
  BigInt toBigInt() {
    return BigInt.from(this);
  }
}

extension FormatInt on int {
  String formatNumber() {
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1)}B';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    } else {
      return toString();
    }
  }
}

extension FormatDouble on double {
  String formatNumber({int? prefix}) {
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(prefix??4)}B';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(prefix??4)}M';
    }
    else if (this >= 10000) {
      return '${(this / 1000).toStringAsFixed(prefix??4)}K';
    }

    else {
      return toStringAsFixed(prefix??4);
    }
  }
  String prefixNumber({int? prefix}) {

    return toStringAsFixed(prefix??6);
  }

  BigInt convertToWei() {
    final etherToWeiFactor = BigInt.from(10).pow(18);
    final etherBigInt = BigInt.parse((toStringAsFixed(18)).replaceAll('.', ''));
    return etherBigInt * etherToWeiFactor ~/ BigInt.from(10).pow(18);
  }
}

extension StringToIntExtension on String {
  double? toSimpleInt() {
    if (endsWith('K')) {
      return (double.parse(replaceAll('K', '')) * 1000).toDouble();
    } else if (endsWith('M')) {
      return (double.parse(replaceAll('M', '')) * 1000000).toDouble();
    } else {
      return double.tryParse(this);
    }
  }
}

extension FormatBigInt on BigInt {
  String formatNumber() {
    if (this >= 1000000000.toBigInt()) {
      return '${(this / 1000000000.toBigInt()).toStringAsFixed(1)}B';
    } else if (this >= 1000000.toBigInt()) {
      return '${(this / 1000000.toBigInt()).toStringAsFixed(1)}M';
    } else if (this >= 1000.toBigInt()) {
      return '${(this / 1000.toBigInt()).toStringAsFixed(1)}K';
    } else {
      return toString();
    }
  }

  double toEther() {
    final weiToEtherFactor = BigInt.from(10).pow(18);

    return (this / weiToEtherFactor).toDouble();
  }
}

extension DoubleToBigInt on double {
  BigInt toBigInt() {
    return BigInt.from(this * 1e18);
  }
}

extension WidgetCallBackExtension on Widget {

  Widget onTap(void Function() onTapCallback) {
    return GestureDetector(
      onTap: onTapCallback,
      child: this,
    );



  }

  Widget toGradientMask() {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => RadialGradient(
        center: Alignment.center,
        stops: const [.2, 1],
        colors: [primaryColor1, primaryColor],
      ).createShader(bounds),
      child: this,
    );
  }
}

extension DateTimeAgoExtension on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return DateFormat.yMMMMd().format(this);
    }
  }


  String toFormattedString() {
    return "${year.toString().padLeft(4, '0')}-"
        "${month.toString().padLeft(2, '0')}-"
        "${day.toString().padLeft(2, '0')} "
        "${hour.toString().padLeft(2, '0')}:"
        "${minute.toString().padLeft(2, '0')}:"
        "${second.toString().padLeft(2, '0')}";
  }
}


extension ShimmerEffect on Widget {
  Widget applyShimmer({bool enable = true, Color? baseColor, Color? highlightColor}) {
    if (enable) {
      return Shimmer.fromColors(
        baseColor: baseColor ?? primaryColor,
        highlightColor: highlightColor ?? Colors.grey.withOpacity(.2),
        direction: ShimmerDirection.ltr,
        enabled: enable,
        child: this,
      );
    } else {
      return this;
    }
  }
}
