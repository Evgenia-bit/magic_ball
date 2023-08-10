import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/core/styles/theme.dart';
import 'package:surf_practice_magic_ball/core/utils/adaptability_manager.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_view_model.dart';
import 'package:surf_practice_magic_ball/features/common/widgets/custom_animated_switched.dart';

class Ball extends StatelessWidget {
  const Ball({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offsetAnimation = context.select(
      (BallViewModel model) => model.offsetAnimation,
    );
    final loadAnswer = context.read<BallViewModel>().loadAnswer;
    const child = Stack(
      alignment: Alignment.center,
      children: [
        _Surface(),
        _Text(),
      ],
    );

    return SizedBox(
      width: AdaptabilityManager.magicBallSize,
      child: GestureDetector(
        onTap: loadAnswer,
        child: offsetAnimation != null
            ? SlideTransition(
                position: offsetAnimation,
                child: child,
              )
            : child,
      ),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const starImagesDir = 'assets/images/stars';
    const pathToSmallStarImage = '$starImagesDir/small_star.png';
    const pathToStarImage = '$starImagesDir/star.png';

    return Stack(
      alignment: Alignment.center,
      children: [
        const _BallBackground(),
        _Stars(
          imagePath: pathToSmallStarImage,
          animationDurationInSeconds: 15,
          width: AdaptabilityManager.magicBallSize * 0.7,
        ),
        if (Theme.of(context).brightness != Brightness.light)
          _Stars(
            imagePath: pathToStarImage,
            animationDurationInSeconds: 7,
            width: AdaptabilityManager.magicBallSize * 0.5,
          ),
      ],
    );
  }
}

class _BallBackground extends StatelessWidget {
  const _BallBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ballImageFileName = context.select(
      (BallViewModel model) => model.state.ballState.ballImageFileName,
    );
    final pathToBallImage =
        'assets/images/${Theme.of(context).themeMode}/$ballImageFileName';

    return CustomAnimatedSwitched(
      child: Image.asset(
        pathToBallImage,
        key: ValueKey<String>(pathToBallImage),
        fit: BoxFit.cover,
      ),
    );
  }
}

class _Stars extends StatefulWidget {
  final String imagePath;
  final int animationDurationInSeconds;
  final double width;

  const _Stars({
    Key? key,
    required this.imagePath,
    required this.animationDurationInSeconds,
    required this.width,
  }) : super(key: key);

  @override
  State<_Stars> createState() => _StarsState();
}

class _StarsState extends State<_Stars> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.animationDurationInSeconds),
    )..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ballState =
        context.select((BallViewModel model) => model.state.ballState);
    final Widget child;

    if (ballState == BallState.start) {
      child = SizedBox(
        key: const ValueKey('stars'),
        width: widget.width,
        child: RotationTransition(
          turns: _controller,
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      child = const SizedBox.shrink(
        key: ValueKey('not_stars'),
      );
    }
    return CustomAnimatedSwitched(child: child);
  }
}

class _Text extends StatelessWidget {
  const _Text({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (answer, transition) = context.select((BallViewModel model) =>
        (model.state.answer, model.state.textTransition));

    return SizedBox(
      width: AdaptabilityManager.magicBallSize * 0.7,
      child: CustomAnimatedSwitched(
        transition: transition,
        child: Text(
          answer,
          key: ValueKey<String>(answer),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
