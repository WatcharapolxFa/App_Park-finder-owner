import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:parking_finder_app_provider/screens/logged-in/index.dart';
import 'package:parking_finder_app_provider/services/profile_service.dart';
import 'package:parking_finder_app_provider/widgets/add_image/Image_upload.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';
import '../../assets/colors/constant.dart';
import 'package:parking_finder_app_provider/widgets/custom_text_field.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key, required this.profileID});
  final String profileID;
  @override
  AddAccountPageState createState() => AddAccountPageState();
}

class AddAccountPageState extends State<AddAccountPage> {
  final profileService = ProfileService();
  int bankAccountImageCount = 0; // Add this line
  List<XFile>? bankAccountImage;
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มบัญชีธนาคารของคุณ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                color: AppColor.blackgroundColor,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("กรอกข้อมูลบัญชีของคุณ",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: accountNumberController,
                      label: "เลขที่บัญชี",
                    ),
                  ),
                  const SizedBox(width: 10), // Provide some spacing
                  Expanded(
                    child: CustomTextField(
                      controller: bankController,
                      label: "ธนาคาร",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                label: "ชื่อบัญชี",
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                color: AppColor.blackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("ภาพถ่ายหน้าบัญชีธนาคาร",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                    Text("($bankAccountImageCount/1)",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ImageUploadWidget(
                title: "",
                maxImages: 1,
                onImagesSelected: (List<XFile> images) {
                  // Update the UI to reflect the image count
                  setState(() {
                    bankAccountImageCount = images.length;
                    bankAccountImage = images;
                  });
                  // Here, you might also handle the image(s) further, e.g., preparing for upload
                },
              ),
              const SizedBox(height: 400),
              BlueButton(
                  label: 'บันทึก',
                  onPressed: () async {
                    EasyLoading.show();
                    String bookAccountIMG = await profileService.uploadBankIMG(
                        widget.profileID, bankAccountImage![0].path);
                    final response = await profileService.updateBankAccount(
                        bookAccountIMG,
                        bankController.text,
                        nameController.text,
                        accountNumberController.text);
                    if (response) {
                      EasyLoading.dismiss();
                      EasyLoading.showSuccess("บันทึกสำเร็จ");
                      // ignore: use_build_context_synchronously
                      Navigator.popUntil(context, (route) => route.isFirst);
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoggedInPage(screenIndex: 4)));
                    }
                    else {
                       EasyLoading.dismiss();
                       EasyLoading.showError("บันทึกไม่สำเร็จ");
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
