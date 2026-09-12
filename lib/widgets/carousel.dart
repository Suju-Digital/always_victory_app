import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AppCarousel<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;

  final double height;
  final bool autoPlay;
  final Duration autoPlayDuration;
  final bool showIndicator;

  const AppCarousel({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.height = 200,
    this.autoPlay = true,
    this.autoPlayDuration = const Duration(seconds: 4),
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
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        if (widget.showIndicator)
          Positioned(
            bottom: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.items.length,
                (index) {
                  final isActive = index == currentIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 24 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        if (isActive)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
