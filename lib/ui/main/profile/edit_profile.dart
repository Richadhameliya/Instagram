import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_app/controller/editprofile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  final EditProfileController _controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _controller.saveProfile,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _controller.pickImage,
                        child: Obx(() {
                          return Container(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: _controller.image.value != null
                                  ? DecorationImage(
                                      image:
                                          FileImage(_controller.image.value!),
                                      fit: BoxFit.cover)
                                  : _controller.profileImageUrl.value.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(_controller
                                              .profileImageUrl.value),
                                          fit: BoxFit.cover)
                                      : null,
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    const Center(
                      child: Text(
                        "Edit Picture or Avatar",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    TextField(
                      controller: _controller.usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextField(
                      controller: _controller.emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextField(
                      controller: _controller.pronounsController,
                      decoration: InputDecoration(
                        labelText: "Pronouns",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextField(
                      controller: _controller.bioController,
                      decoration: InputDecoration(
                        labelText: "Bio",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Text("Add link", style: TextStyle(fontSize: 16)),
                    SizedBox(height: screenHeight * 0.03),
                    const Text("Add banners", style: TextStyle(fontSize: 16)),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon:
                            const Icon(Icons.arrow_forward_ios, size: 17),
                        labelText: "Gender",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Obx(() {
                      return Row(
                        children: [
                          const Text("Show Thread badge",
                              style: TextStyle(fontSize: 17)),
                          const Spacer(),
                          Switch(
                            value: _controller.isSwitched.value,
                            onChanged: _controller.toggleSwitch,
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                      height: screenHeight * 0.05, color: Colors.grey.shade200),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.03),
                    child: Text("Switch to professional account",
                        style: TextStyle(fontSize: 18, color: Colors.blue)),
                  ),
                  Divider(
                      height: screenHeight * 0.05, color: Colors.grey.shade200),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.03),
                    child: Text("Personal information setting",
                        style: TextStyle(fontSize: 18, color: Colors.blue)),
                  ),
                  Divider(
                      height: screenHeight * 0.05, color: Colors.grey.shade200),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
