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
            // Ảnh thu nhỏ bên dưới
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length, // Số lượng ảnh trong danh sách
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Khi người dùng nhấn vào ảnh, cập nhật ảnh chính
                        setState(() {
                          selectedImage = imagePaths[index];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                            child: Image.asset(
                            imagePaths[index], // Hiển thị ảnh thu nhỏ
                            fit: BoxFit.cover,
                            width: 80,
                          ),
                        )
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
