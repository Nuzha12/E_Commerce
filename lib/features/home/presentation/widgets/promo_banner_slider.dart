import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/banner_entity.dart';

class PromoBannerSlider extends StatefulWidget {
  final List<BannerEntity> banners;

  const PromoBannerSlider({
    super.key,
    required this.banners,
  });

  @override
  State<PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _PromoBannerSliderState extends State<PromoBannerSlider> {
  final controller = PageController(viewportFraction: .92);
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (widget.banners.isNotEmpty) {
      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!controller.hasClients) return;
        currentIndex = (currentIndex + 1) % widget.banners.length;
        controller.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  Color parseColor(String hex) {
    final value = hex.replaceAll('#', '');
    return Color(int.parse('0xFF$value'));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: controller,
            onPageChanged: (value) => setState(() => currentIndex = value),
            itemCount: widget.banners.length,
            itemBuilder: (_, index) {
              final banner = widget.banners[index];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    colors: [
                      parseColor(banner.color),
                      parseColor(banner.color).withOpacity(.72),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              banner.subtitle,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(26),
                          bottomRight: Radius.circular(26),
                        ),
                        child: Image.network(banner.image, fit: BoxFit.cover, height: double.infinity),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (index) {
            final active = index == currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active ? const Color(0xFF6C5CE7) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(99),
              ),
            );
          }),
        )
      ],
    );
  }
}