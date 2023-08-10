import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/features/common/widgets/custom_animated_switched.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/settings_sheet_view_model.dart';
import 'package:surf_practice_magic_ball/features/navigation/settings_sheet_navigation.dart';

class SettingsSheet extends StatefulWidget {
  static GlobalKey<NavigatorState> navKey = GlobalKey();

  const SettingsSheet({Key? key}) : super(key: key);

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late final DraggableScrollableController _controller;

  @override
  void initState() {
    _controller = context.read<SettingsSheetViewModel>().controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: sheetMinChildSize,
      minChildSize: sheetMinChildSize,
      maxChildSize: sheetMaxChildSize,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: const _SettingsSheetContent(),
        );
      },
    );
  }
}

class _SettingsSheetContent extends StatelessWidget {
  const _SettingsSheetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * sheetMaxChildSize,
      child: const Column(
        children: [
          _Header(),
          _Body(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<SettingsSheetViewModel>();
    final (isMainPage, iconData, text) =
        context.select((SettingsSheetViewModel model) => (
              model.state.isMainPage,
              model.state.sheetState.headerButtonIconData,
              model.state.headerTitle,
            ));
    final leading = isMainPage
        ? const SizedBox.shrink()
        : Align(
            alignment: Alignment.centerLeft,
            child: BackButton(
              onPressed: model.goToMainPage,
            ),
          );
    return CustomAnimatedSwitched(
      duration: const Duration(milliseconds: 1000),
      child: Row(
        key: ValueKey('$iconData$text'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: leading),
          Text(text, style: Theme.of(context).textTheme.titleMedium),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: model.snapSheet,
                icon: Icon(
                  iconData,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Navigator(
        key: SettingsSheet.navKey,
        initialRoute: SettingsNavigationPageNames.main,
        onGenerateRoute: (settings) {
          return PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (context, animation, secondaryAnimation) {
              return SettingsNavigation.pages[settings.name] ??
                  const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
