import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../product/domain/entities/product_entity.dart';

class WishlistState extends Equatable {
  final List<ProductEntity> items;
  final bool loaded;

  const WishlistState({
    this.items = const [],
    this.loaded = false,
  });

  WishlistState copyWith({
    List<ProductEntity>? items,
    bool? loaded,
  }) {
    return WishlistState(
      items: items ?? this.items,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object?> get props => [items, loaded];
}

abstract class WishlistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class WishlistStarted extends WishlistEvent {}

class WishlistToggled extends WishlistEvent {
  final ProductEntity product;

  WishlistToggled(this.product);

  @override
  List<Object?> get props => [product];
}

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  static const _key = 'wishlist_items';

  WishlistBloc() : super(const WishlistState()) {
    on<WishlistStarted>(_onStarted);
    on<WishlistToggled>(_onToggled);
  }

  Future<void> _onStarted(WishlistStarted event, Emitter<WishlistState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) {
      emit(state.copyWith(loaded: true));
      return;
    }

    final list = jsonDecode(raw) as List;
    final items = list.map((e) {
      return ProductEntity(
        id: e['id'],
        name: e['name'],
        category: e['category'],
        image: e['image'],
        price: (e['price'] as num).toDouble(),
        rating: (e['rating'] as num).toDouble(),
        description: e['description'],
      );
    }).toList();

    emit(state.copyWith(items: items, loaded: true));
  }

  Future<void> _save(List<ProductEntity> items) async {
    final prefs = await SharedPreferences.getInstance();
    final data = items.map((e) {
      return {
        'id': e.id,
        'name': e.name,
        'category': e.category,
        'image': e.image,
        'price': e.price,
        'rating': e.rating,
        'description': e.description,
      };
    }).toList();
    await prefs.setString(_key, jsonEncode(data));
  }

  Future<void> _onToggled(WishlistToggled event, Emitter<WishlistState> emit) async {
    final exists = state.items.any((e) => e.id == event.product.id);
    final items = exists
        ? state.items.where((e) => e.id != event.product.id).toList()
        : [...state.items, event.product];
    await _save(items);
    emit(state.copyWith(items: items));
  }
}