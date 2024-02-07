import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videohub/core/providers/theme_provider.dart';
import 'package:videohub/core/providers/user_provider.dart';
import 'package:videohub/core/routes.dart';
import 'package:videohub/core/utils/themes.dart';

import 'core/providers/auth_provider.dart';
import 'core/providers/state_provider.dart';

class G4All extends StatelessWidget {
  const G4All({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider(isSignedIn: false, user: null),),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider(false),),
        ChangeNotifierProvider<StateProvider>(create: (_) => StateProvider(visitId: null, searchedName: null),),
      ],
      child: AppContainer(
        app: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: g4allTheme(context, !themeProvider.isDark),
          routerConfig: router,
        ),
      ),
    );
  }
}

class AppContainer extends StatelessWidget {
  final Widget app;
  const AppContainer({Key? key, required this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return app;
  }
}