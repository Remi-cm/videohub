import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:videohub/views/home.dart';
import 'package:videohub/views/sign_in.dart';
import 'package:videohub/views/splash_screen.dart';

import '../views/sign_up.dart';

final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(path: '/', builder: (BuildContext context, GoRouterState state) => const SplashScreen(),),
      GoRoute(path: '/splash', builder: (BuildContext context, GoRouterState state) => const SplashScreen(),),
      GoRoute(path: '/sign-in', builder: (BuildContext context, GoRouterState state) => const SignInPage(),),
      GoRoute(path: '/sign-up', builder: (BuildContext context, GoRouterState state) => const SignUpPage(),),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const MyHomePage();
        },
      ),
    ],
  );