import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_view_model.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/widgets/ball.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/widgets/bottom_shadow.dart';

class BallContainer extends StatefulWidget {
  const BallContainer({super.key});

  @override
  _BallContainerState createState() => _BallContainerState();
}

class _BallContainerState extends State<BallContainer>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    final ballModel = context.read<BallViewModel>();
    final controller = AnimationController(vsync: this);
    ballModel.createAnimationController(controller);
    ballModel.startShakeDetector();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    context.read<BallViewModel>().animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Ball(),
        BottomShadow(),
        SizedBox(height: 100),
      ],
    );
  }
}
