import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Method to upload multiple images
  Future<List<String>> uploadImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isEmpty) return [];

    List<String> downloadUrls = [];

    for (var image in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('images/$fileName');

      await ref.putFile(File(image.path));
      String downloadUrl = await ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }

  // Method to capture an image using the camera
  Future<String?> captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null; // Return null if no image was captured

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = _storage.ref().child('images/$fileName');

    await ref.putFile(File(image.path));
    return await ref.getDownloadURL(); // Return the download URL of the uploaded image
  }
}
