import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingAnimation extends StatelessWidget {
  final double size;
  final String? text;
  final bool showText;

  const CustomLoadingAnimation({
    Key? key,
    this.size = 50.0,
    this.text,
    this.showText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.discreteCircle(
          color: AppColors.primary,
          secondRingColor: AppColors.primary.withOpacity(0.5),
          thirdRingColor: AppColors.primary.withOpacity(0.2),
          size: size,
        ),
        if (showText) ...[
          SizedBox(height: 20),
          Text(
            text ?? "Loading...",
            style: GoogleFonts.poppins(
              color: AppColors.hintText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// Alternative loading animations that can be used
class CustomLoadingAnimations {
  // Wave Dots Animation
  static Widget waveDots({double size = 50.0, Color? color}) {
    return LoadingAnimationWidget.waveDots(
      color: color ?? AppColors.primary,
      size: size,
    );
  }

  // Staggered Dots Wave Animation
  static Widget staggeredDotsWave({double size = 50.0, Color? color}) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: color ?? AppColors.primary,
      size: size,
    );
  }

  // Twisting Dots Animation
  static Widget twistingDots({double size = 50.0}) {
    return LoadingAnimationWidget.twistingDots(
      leftDotColor: AppColors.primary,
      rightDotColor: AppColors.primary.withOpacity(0.5),
      size: size,
    );
  }

  // Horizontal Rotating Dots Animation
  static Widget horizontalRotatingDots({double size = 50.0, Color? color}) {
    return LoadingAnimationWidget.horizontalRotatingDots(
      color: color ?? AppColors.primary,
      size: size,
    );
  }

  // Beating Hearts Animation
  static Widget beat({double size = 50.0, Color? color}) {
    return LoadingAnimationWidget.beat(
      color: color ?? AppColors.primary,
      size: size,
    );
  }
}
