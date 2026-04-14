import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/widgets/category_chip_list.dart';
import '../../../home/presentation/widgets/promo_banner_slider.dart';
import '../bloc/product_bloc.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, homeState) {
            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C5CE7), Color(0xFF00CEC9)],
                        ),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Discover your style',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Colorful shopping experience',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: searchController,
                            onChanged: (value) {
                              context.read<ProductBloc>().add(
                                ProductsLoaded(
                                  query: value,
                                  category: homeState.selectedCategory,
                                ),
                              );
                            },
                            decoration: InputDecoration(
                              hintText: 'Search products',
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PromoBannerSlider(banners: homeState.banners),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CategoryChipList(
                        categories: homeState.categories,
                        selectedCategory: homeState.selectedCategory,
                        onSelected: (category) {
                          context.read<HomeBloc>().add(HomeCategorySelected(category));
                          context.read<ProductBloc>().add(
                            ProductsLoaded(
                              query: searchController.text,
                              category: category,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: productState.loading
                          ? const Center(child: CircularProgressIndicator())
                          : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: productState.products.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: .64,
                        ),
                        itemBuilder: (_, index) {
                          final product = productState.products[index];
                          return ProductCard(
                            product: product,
                            onTap: () => context.push('/product/${product.id}'),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}