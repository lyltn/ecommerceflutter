import 'package:flutter/material.dart';

class PhotoGallery extends StatefulWidget {
  final List<String> imagePaths;

  const PhotoGallery({Key? key, required this.imagePaths}) : super(key: key);

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  // Ảnh chính được hiển thị ban đầu
  late String selectedImage;

  @override
  void initState() {
    super.initState();
    // Set the initial selected image to the first image in the list
    selectedImage = widget.imagePaths.isNotEmpty ? widget.imagePaths[0] : ''; // Initialize selected image
  }

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
                child: Image.network(
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
                  itemCount: widget.imagePaths.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImage = widget.imagePaths[index];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: 80,
                          child: Image.network(
                            widget.imagePaths[index],
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
