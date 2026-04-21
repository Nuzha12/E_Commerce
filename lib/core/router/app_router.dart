import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/product/presentation/pages/product_details_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';

class AppRouter {
  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

        if (authState.status == AuthStatus.unknown || authState.status == AuthStatus.loading) {
          return null;
        }

        if (authState.status == AuthStatus.unauthenticated && !isAuthRoute) {
          return '/login';
        }

        if (authState.status == AuthStatus.authenticated && isAuthRoute) {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (_, __) => const RegisterPage(),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) => const MainPage(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (_, state) => ProductDetailsPage(
            productId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (_, __) => const EditProfilePage(),
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}