import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AppCarousel<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;

  final double height;
  final bool autoPlay;
  final Duration autoPlayDuration;
  final Duration autoPlayAnimationDuration;
  final Curve scrollCurve;
  final bool showIndicator;

  const AppCarousel({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.height = 155,
    this.autoPlay = true,
    this.autoPlayDuration = const Duration(seconds: 4),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.scrollCurve = Curves.fastOutSlowIn,
    this.showIndicator = true,
  });

  @override
  State<AppCarousel<T>> createState() => _AppCarouselState<T>();
}

class _AppCarouselState<T> extends State<AppCarousel<T>> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index, realIndex) {
            return widget.itemBuilder(
              widget.items[index],
              index,
            );
          },
          options: CarouselOptions(
            height: widget.height,
            autoPlay: widget.autoPlay,
            autoPlayInterval: widget.autoPlayDuration,
            autoPlayAnimationDuration: widget.autoPlayAnimationDuration,
            autoPlayCurve: widget.scrollCurve,
            viewportFraction: 0.90,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        // Indicator Dots overlay
        if (widget.showIndicator)
          Positioned(
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.items.length,
                  (index) {
                    final isActive = index == currentIndex;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isActive ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
