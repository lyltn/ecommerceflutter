import 'package:flutter/material.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({Key? key}) : super(key: key);

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  // Danh sách các đường dẫn ảnh khác nhau
  final List<String> imagePaths = [
    'images/imageProduct.png',
    'images/image 47.png',
    'images/image 47 (1).png',
    'images/image 47 (2).png',
    'images/image 47 (3).png',
    'images/image 47 (4).png',
  ];

  // Ảnh chính được hiển thị ban đầu
  String selectedImage = 'images/imageProduct.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ảnh chính
            Expanded(
              flex: 3,
              child: Container(
                child: Image.asset(
                  selectedImage, // Sử dụng ảnh được chọn
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Thumbnails
            SizedBox(
              height: 100, // Set the height for the thumbnails container
              child: Container(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImage = imagePaths[index];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: 80,
                          child: Image.asset(
                            imagePaths[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
