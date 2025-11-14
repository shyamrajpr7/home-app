// PROFILE PAGE
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController(
    text: "rolex",
  );
  final TextEditingController emailController = TextEditingController(
    text: "rolex.doe@example.com",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "+91 9876543210",
  );
  final TextEditingController addressController = TextEditingController(
    text: "123, Main Street, City, Country",
  );

  bool isEditing = false;
  File? profileImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: isEditing ? pickImage : null,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : const AssetImage("images/Untitled106_20250821114107.jpg")
                          as ImageProvider,
                child: isEditing
                    ? const Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(Icons.camera_alt, size: 20),
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Name
            _buildField("Name", nameController, Icons.person),
            const SizedBox(height: 12),

            // Email
            _buildField("Email", emailController, Icons.email),
            const SizedBox(height: 12),

            // Phone
            _buildField("Phone", phoneController, Icons.phone),
            const SizedBox(height: 12),

            // Address
            _buildField("Address", addressController, Icons.location_on),
            const SizedBox(height: 24),

            // Settings card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.settings, color: Colors.deepPurple),
                title: const Text("Settings"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: isEditing
            ? TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
              )
            : Text(controller.text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
