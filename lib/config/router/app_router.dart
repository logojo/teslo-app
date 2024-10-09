import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_app/features/products/presentation/screens/screens.dart';

import 'app_router_notifier.dart';
import 'package:teslo_app/features/auth/auth.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    //* con esto detecto cuando el status de authCambie y saber si esta autenticado o no
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),

      GoRoute(
        path: '/product/:id',
        builder: (context, state) =>
            ProductScreen(productId: state.pathParameters['id'] ?? 'no-id'),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;
      final acount = goRouterNotifier.acount;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      } else if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;
        if (acount == Acount.exist) return '/login';
        return '/register';
      } else if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      //*condiciones para proteción de rutas por perfiles
      //if(user.isAdmin)

      return null;
    },
  );
});
