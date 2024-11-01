import 'package:flutter/material.dart';

class ProductSellCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final double price;
  final int discountPercentage;
  final double rating;
  final int reviewCount;
  final double? width;  // New parameter
  final double? height; // New parameter

  const ProductSellCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate sizes based on provided width or default
    final cardWidth = width ?? 200.0;
    final cardHeight = height ?? 300.0;
    final imageHeight = cardHeight * 0.6;
    final contentPadding = cardWidth * 0.05;
    final titleStyle = width != null 
        ? Theme.of(context).textTheme.titleSmall 
        : Theme.of(context).textTheme.titleMedium;
    final bodyStyle = width != null 
        ? Theme.of(context).textTheme.bodySmall 
        : Theme.of(context).textTheme.bodyMedium;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight,
              width: cardWidth,
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: contentPadding / 2),
                    Text(
                      'VNĐ${(price * (100 - discountPercentage) / 100).toStringAsFixed(0)}',
                      style: titleStyle?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'VNĐ$price',
                          style: bodyStyle?.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: contentPadding / 2),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: contentPadding / 2, vertical: contentPadding / 4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 252, 237, 238),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$discountPercentage% OFF',
                            style: TextStyle(
                              color: Colors.red[800],
                              fontSize: bodyStyle?.fontSize ?? 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: contentPadding / 2),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < rating.floor() ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: bodyStyle?.fontSize ?? 12,
                          ),
                        ),
                        SizedBox(width: contentPadding / 2),
                        Text(
                          '$rating ($reviewCount)',
                          style: bodyStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}