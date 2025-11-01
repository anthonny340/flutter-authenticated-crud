import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/products.dart';

//Se puede establecer un control para los tipos de usuarios: admin, user, etc...
//Se esta forma se construiria las rutas disponibles y accesibles segun el tipo de usuario
final goRouterProvider = Provider(
  (ref) {
    final goRouterNotifier = ref.read(goROuterNotifierProvider);
    return GoRouter(
      initialLocation: '/cheking-auth',
      refreshListenable: goRouterNotifier,
      routes: [
        //Primera pantalla
        GoRoute(
          path: '/cheking-auth',
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
      ],
      redirect: (context, state) {
        //Ver a que ruta esta apuntando el estado
        // print(state.subloc);

        final isGointTo = state.subloc;

        final authStatus = goRouterNotifier.authStatus;

        if (isGointTo == 'cheking-auth' && authStatus == AuthStatus.checking) {
          return null;
        }

        if (authStatus == AuthStatus.notAutenticated) {
          if (isGointTo == '/login' || isGointTo == '/register') return null;

          return '/login';
        }

        if (authStatus == AuthStatus.autenticated) {
          if (isGointTo == '/login' ||
              isGointTo == '/register' ||
              isGointTo == '/cheking-auth') {
            return '/';
          }
        }

        /*if ( user.isAdmin){
          //Posibles redireccion de rutas segun el tipo de usuario
        }*/

        // return '/login';
        return null;
      },
    );
  },
);
