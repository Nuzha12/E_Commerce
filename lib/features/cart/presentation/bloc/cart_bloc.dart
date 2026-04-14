import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../../product/domain/entities/product_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;
  final bool loaded;

  const CartState({
    this.items = const [],
    this.loaded = false,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItemEntity>? items,
    bool? loaded,
  }) {
    return CartState(
      items: items ?? this.items,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object?> get props => [items, loaded];
}

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {}

class CartItemAdded extends CartEvent {
  final ProductEntity product;

  CartItemAdded(this.product);

  @override
  List<Object?> get props => [product];
}

class CartItemRemoved extends CartEvent {
  final int productId;

  CartItemRemoved(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartQuantityIncreased extends CartEvent {
  final int productId;

  CartQuantityIncreased(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartQuantityDecreased extends CartEvent {
  final int productId;

  CartQuantityDecreased(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartCleared extends CartEvent {}

class CartBloc extends Bloc<CartEvent, CartState> {
  static const _key = 'cart_items';

  CartBloc() : super(const CartState()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onAdded);
    on<CartItemRemoved>(_onRemoved);
    on<CartQuantityIncreased>(_onIncrease);
    on<CartQuantityDecreased>(_onDecrease);
    on<CartCleared>(_onCleared);
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) {
      emit(state.copyWith(loaded: true));
      return;
    }

    final list = jsonDecode(raw) as List;
    final items = list.map((e) {
      final product = ProductEntity(
        id: e['product']['id'],
        name: e['product']['name'],
        category: e['product']['category'],
        image: e['product']['image'],
        price: (e['product']['price'] as num).toDouble(),
        rating: (e['product']['rating'] as num).toDouble(),
        description: e['product']['description'],
      );
      return CartItemEntity(product: product, quantity: e['quantity']);
    }).toList();

    emit(state.copyWith(items: items, loaded: true));
  }

  Future<void> _save(List<CartItemEntity> items) async {
    final prefs = await SharedPreferences.getInstance();
    final data = items.map((e) {
      return {
        'quantity': e.quantity,
        'product': {
          'id': e.product.id,
          'name': e.product.name,
          'category': e.product.category,
          'image': e.product.image,
          'price': e.product.price,
          'rating': e.product.rating,
          'description': e.product.description,
        }
      };
    }).toList();
    await prefs.setString(_key, jsonEncode(data));
  }

  Future<void> _onAdded(CartItemAdded event, Emitter<CartState> emit) async {
    final items = List<CartItemEntity>.from(state.items);
    final index = items.indexWhere((e) => e.product.id == event.product.id);

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      items.add(CartItemEntity(product: event.product, quantity: 1));
    }

    await _save(items);
    emit(state.copyWith(items: items));
  }

  Future<void> _onRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    final items = state.items.where((e) => e.product.id != event.productId).toList();
    await _save(items);
    emit(state.copyWith(items: items));
  }

  Future<void> _onIncrease(CartQuantityIncreased event, Emitter<CartState> emit) async {
    final items = state.items.map((e) {
      if (e.product.id == event.productId) {
        return e.copyWith(quantity: e.quantity + 1);
      }
      return e;
    }).toList();
    await _save(items);
    emit(state.copyWith(items: items));
  }

  Future<void> _onDecrease(CartQuantityDecreased event, Emitter<CartState> emit) async {
    final items = <CartItemEntity>[];
    for (final item in state.items) {
      if (item.product.id == event.productId) {
        if (item.quantity > 1) {
          items.add(item.copyWith(quantity: item.quantity - 1));
        }
      } else {
        items.add(item);
      }
    }
    await _save(items);
    emit(state.copyWith(items: items));
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    emit(const CartState(items: [], loaded: true));
  }
}