import 'package:blockchain_wallet/ui/authentication/authentication_page.dart';
import 'package:blockchain_wallet/ui/home/home_page.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: AppRoutes.authentication,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: AppRoutes.authentication,
      builder: (context, state) => AuthenticationPage(),
    ),
  ],
);
