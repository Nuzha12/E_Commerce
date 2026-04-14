import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';

class CategoryChipList extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const CategoryChipList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final category = categories[index];
          final selected = category.name == selectedCategory;
          return ChoiceChip(
            selected: selected,
            label: Text(category.name),
            onSelected: (_) => onSelected(category.name),
            selectedColor: const Color(0xFF6C5CE7),
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          );
        },
      ),
    );
  }
}