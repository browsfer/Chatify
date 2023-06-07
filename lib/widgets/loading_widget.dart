import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  const LoadingWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.flickr(
      leftDotColor: Theme.of(context).colorScheme.primary,
      rightDotColor: Theme.of(context).colorScheme.secondary,
      size: size ?? 45,
    );
  }
}
