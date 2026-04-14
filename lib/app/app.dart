import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/cart/presentation/bloc/cart_bloc.dart';
import '../features/home/data/datasources/home_local_datasource.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/usecases/get_banners_usecase.dart';
import '../features/home/domain/usecases/get_categories_usecase.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/product/data/datasources/product_local_datasource.dart';
import '../features/product/data/repositories/product_repository_impl.dart';
import '../features/product/domain/usecases/get_product_by_id_usecase.dart';
import '../features/product/domain/usecases/get_products_by_category_usecase.dart';
import '../features/product/domain/usecases/get_products_usecase.dart';
import '../features/product/domain/usecases/search_products_usecase.dart';
import '../features/product/presentation/bloc/product_bloc.dart';
import '../features/wishlist/presentation/bloc/wishlist_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl(AuthLocalDataSource());
    final productRepository = ProductRepositoryImpl(ProductLocalDataSource());
    final homeRepository = HomeRepositoryImpl(HomeLocalDataSource());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(authRepository),
            registerUseCase: RegisterUseCase(authRepository),
            getCurrentUserUseCase: GetCurrentUserUseCase(authRepository),
            logoutUseCase: LogoutUseCase(authRepository),
          )..add(AuthAppStarted()),
        ),
        BlocProvider(
          create: (_) => ProductBloc(
            getProductsUseCase: GetProductsUseCase(productRepository),
            getProductByIdUseCase: GetProductByIdUseCase(productRepository),
            searchProductsUseCase: SearchProductsUseCase(productRepository),
            getProductsByCategoryUseCase: GetProductsByCategoryUseCase(productRepository),
          )..add(const ProductsLoaded()),
        ),
        BlocProvider(
          create: (_) => HomeBloc(
            getBannersUseCase: GetBannersUseCase(homeRepository),
            getCategoriesUseCase: GetCategoriesUseCase(homeRepository),
          )..add(HomeLoaded()),
        ),
        BlocProvider(create: (_) => CartBloc()..add(CartStarted())),
        BlocProvider(create: (_) => WishlistBloc()..add(WishlistStarted())),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}