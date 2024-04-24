import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';

class ImageUploadWidget extends StatefulWidget {
  final String title;
  final int maxImages;
  final Function(List<XFile> images) onImagesSelected;

  const ImageUploadWidget({
    super.key,
    required this.title,
    required this.maxImages,
    required this.onImagesSelected,
  });

  @override
  ImageUploadWidgetState createState() => ImageUploadWidgetState();
}

class ImageUploadWidgetState extends State<ImageUploadWidget> {
  List<XFile> _images = [];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedImages = await picker.pickMultiImage();
    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _images = pickedImages.length > widget.maxImages
            ? pickedImages.sublist(0, widget.maxImages)
            : pickedImages;
        widget.onImagesSelected(_images);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(widget.title, style: const TextStyle(fontSize: 16)),
          ),
        _images.isEmpty
            ? Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  // Add Padding here
                  padding: const EdgeInsets.only(
                      left:
                          20), // Add left padding to move the button towards the right from the left edge
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.appPrimaryColor,
          
                    ),
                    onPressed: _pickImage,
                    child: const Text('อัพโหลดเอกสาร', style: TextStyle(color: Colors.white)),
                  ),
                ),
              )
            : SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.file(File(_images[index].path)),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
