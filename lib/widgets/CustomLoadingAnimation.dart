import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingAnimation extends StatelessWidget {
  final double size;
  final String? text;
  final bool showText;
  final Color? color;
  final LoadingAnimationType type;

  const CustomLoadingAnimation({
    Key? key,
    this.size = 50.0,
    this.text,
    this.showText = true,
    this.color,
    this.type = LoadingAnimationType.staggeredDotsWave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnimationByType(type, activeColor),
        if (showText) ...[
          SizedBox(height: 16),
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

  Widget _buildAnimationByType(LoadingAnimationType type, Color color) {
    switch (type) {
      case LoadingAnimationType.discreteCircle:
        return LoadingAnimationWidget.discreteCircle(
          color: color,
          secondRingColor: color.withOpacity(0.5),
          thirdRingColor: color.withOpacity(0.2),
          size: size,
        );
      case LoadingAnimationType.staggeredDotsWave:
        return LoadingAnimationWidget.staggeredDotsWave(
          color: color,
          size: size,
        );
      case LoadingAnimationType.threeArchedCircle:
        return LoadingAnimationWidget.threeArchedCircle(
          color: color,
          size: size,
        );
      case LoadingAnimationType.twistingDots:
        return LoadingAnimationWidget.twistingDots(
          leftDotColor: color,
          rightDotColor: color.withOpacity(0.5),
          size: size,
        );
      case LoadingAnimationType.fourRotatingDots:
        return LoadingAnimationWidget.fourRotatingDots(
          color: color,
          size: size,
        );
      case LoadingAnimationType.flickr:
        return LoadingAnimationWidget.flickr(
          leftDotColor: color,
          rightDotColor: color.withOpacity(0.7),
          size: size,
        );
      case LoadingAnimationType.newtonCradle:
        return LoadingAnimationWidget.newtonCradle(
          color: color,
          size: size,
        );
      case LoadingAnimationType.beat:
      default:
        return LoadingAnimationWidget.beat(
          color: color,
          size: size,
        );
    }
  }
}

enum LoadingAnimationType {
  discreteCircle,
  staggeredDotsWave,
  threeArchedCircle,
  twistingDots,
  fourRotatingDots,
  flickr,
  newtonCradle,
  beat,
}

// Helper function to easily show a centered loading animation in a dialog
void showLoadingDialog(BuildContext context,
    {String? text,
    LoadingAnimationType type = LoadingAnimationType.staggeredDotsWave}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomLoadingAnimation(
                size: 50,
                text: text ?? "Loading...",
                type: type,
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Helper function to dismiss the loading dialog
void dismissLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
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
