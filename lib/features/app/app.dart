import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/core/styles/theme.dart';
import 'package:surf_practice_magic_ball/features/app/domain/repository/theme_repository.dart';
import 'package:surf_practice_magic_ball/features/main/presentation/screens/load_screen.dart';
import 'package:surf_practice_magic_ball/features/main/presentation/screens/main_screen.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_view_model.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/settings_sheet_view_model.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => BallViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsSheetViewModel(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final themeNotifier = context.watch<ThemeNotifier>();
          final isDarkTheme = themeNotifier.dark;
          if (isDarkTheme != null) {
            return MaterialApp(
              theme: theme(dark: isDarkTheme),
              home: const MainScreen(),
            );
          } else {
           return const LoadScreen();
          }
        },
      ),
    );
  }
}
