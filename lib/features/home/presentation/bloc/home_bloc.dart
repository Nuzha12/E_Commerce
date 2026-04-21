import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_banners_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';

class HomeState extends Equatable {
  final List<BannerEntity> banners;
  final List<CategoryEntity> categories;
  final String selectedCategory;
  final bool loading;

  const HomeState({
    this.banners = const [],
    this.categories = const [],
    this.selectedCategory = 'All',
    this.loading = false,
  });

  HomeState copyWith({
    List<BannerEntity>? banners,
    List<CategoryEntity>? categories,
    String? selectedCategory,
    bool? loading,
  }) {
    return HomeState(
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [banners, categories, selectedCategory, loading];
}

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeEvent {}

class HomeCategorySelected extends HomeEvent {
  final String category;

  const HomeCategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBannersUseCase getBannersUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  HomeBloc({
    required this.getBannersUseCase,
    required this.getCategoriesUseCase,
  }) : super(const HomeState()) {
    on<HomeLoaded>(_onLoaded);
    on<HomeCategorySelected>(_onCategorySelected);
  }

  Future<void> _onLoaded(HomeLoaded event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true));
    final banners = await getBannersUseCase();
    final categories = await getCategoriesUseCase();
    emit(state.copyWith(
      banners: banners,
      categories: [const CategoryEntity(id: 0, name: 'All'), ...categories],
      loading: false,
    ));
  }

  void _onCategorySelected(HomeCategorySelected event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }
}