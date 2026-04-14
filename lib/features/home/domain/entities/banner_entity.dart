import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final int id;
  final String title;
  final String subtitle;
  final String image;
  final String color;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.color,
  });

  @override
  List<Object?> get props => [id, title, subtitle, image, color];
}