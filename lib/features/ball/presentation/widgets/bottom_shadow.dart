import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/core/utils/adaptability_manager.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_view_model.dart';
import 'package:surf_practice_magic_ball/features/common/widgets/custom_animated_switched.dart';
import 'package:surf_practice_magic_ball/core/styles/theme.dart';

class BottomShadow extends StatelessWidget {
  const BottomShadow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.center,
      children: [
        _FloatingEllipse(),
        _StaticEllipse(),
      ],
    );
  }
}

class _FloatingEllipse extends StatelessWidget {
  const _FloatingEllipse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (offsetAnimation, bottomShadowImageFileName) = context.select(
      (BallViewModel model) => (
        model.offsetAnimation,
        model.state.ballState.bottomShadowImageFileName
      ),
    );
    final path =
        'assets/images/${Theme.of(context).themeMode}/$bottomShadowImageFileName';
    final child = CustomAnimatedSwitched(
      child: Image.asset(
        path,
        key: ValueKey<String>(bottomShadowImageFileName),
        width: AdaptabilityManager.bottomShadowWidth,
      ),
    );

    return offsetAnimation != null
        ? SlideTransition(
            position: offsetAnimation,
            child: child,
          )
        : child;
  }
}

//виджет элипса внизу шара
class _StaticEllipse extends StatelessWidget {
  const _StaticEllipse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomEllipseImageFileName = context.select(
      (BallViewModel model) => model.state.ballState.bottomEllipseImageFileName,
    );
    final path =
        'assets/images/${Theme.of(context).themeMode}/$bottomEllipseImageFileName';

    return Positioned(
      bottom: 10,
      child: SizedBox(
        width: AdaptabilityManager.bottomEllipseWidth,
        child: CustomAnimatedSwitched(
          child: Image.asset(
            path,
            key: ValueKey<String>(bottomEllipseImageFileName),
          ),
        ),
      ),
    );
  }
}
