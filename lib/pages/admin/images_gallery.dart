import 'package:flutter/material.dart';

class ImagesGallery extends StatelessWidget {
  final List<String> imageUrls;

  const ImagesGallery({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return imageUrls.isNotEmpty
        ? SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.network(
              imageUrls[index],
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    )
        : const Center(child: Text('No images available'));
  }
}
