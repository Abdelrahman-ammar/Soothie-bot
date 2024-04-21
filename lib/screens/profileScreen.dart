import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:mapfeature_project/screens/settings.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _selectedImage;
  TextEditingController fullNameController =
      TextEditingController(text: "Rehab Megahed Salem");
  TextEditingController phoneNumberController =
      TextEditingController(text: '01033886818');
  String? selectedGender;
  TextEditingController dobController =
      TextEditingController(text: "22/2/2002");
  bool showPassword = false;
  bool isEditMode = false;

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('       Personal Info'),
        actions: [
          if (isEditMode) // Show save button only in edit mode
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditMode = false; // Exit edit mode
                });
                // Save functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB7C3C5),
                padding: EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "SAVE",
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2.2,
                  color: Colors.white,
                ),
              ),
            ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode; // Toggle edit mode
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isEditMode) {
                        _pickImage(); // Open gallery only in edit mode
                      }
                    },
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (isEditMode) {
                            _pickImage(); // Open gallery only in edit mode
                          }
                        },
                        child: CircleAvatar(
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                                  as ImageProvider<Object>
                              : NetworkImage(
                                  "http://mental-health-ef371ab8b1fd.herokuapp.com/image/NDTSGTzMmQhYW00aWihEDgbmOrSU3vuhO9GRDQja.jpg",
                                ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Visibility(
                      visible: isEditMode,
                      child: GestureDetector(
                        onTap: () {
                          _pickImage(); // Open gallery when edit icon is tapped
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Color(0xFFB7C3C5),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Text(
              'Full Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            buildTextField('.', fullNameController),
            Text(
              'Phone Number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            buildTextField('..', phoneNumberController),
            Text(
              'Gender',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            buildGenderDropdown(),
            Text(
              'Date of Birth',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            buildTextField('...', dobController,
                onTap: () => _selectDate(context)),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsPage()), // تستبدل SecondScreen بشاشة الوجهة الثانية الخاصة بك
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reset your password',
                      style:
                          TextStyle(fontSize: 16.0, color: Color(0xFF355A5C)),
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SettingsPage()), // تستبدل SecondScreen بشاشة الوجهة الثانية الخاصة بك
                  );
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      Text('  Log Out',
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: labelText == "."
          ? TextFormField(
              controller: controller,
              readOnly: !isEditMode, // Set readOnly based on edit mode
              onTap: onTap,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.grey[500],
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold, // تجعل النص داخل الحقل bold
              ),
            )
          : labelText == ".."
              ? IntlPhoneField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // تجعل النص داخل الحقل bold
                  ),
                  controller: controller,
                  enabled: isEditMode,
                  initialCountryCode: 'EG', // تعيين رمز البلد لمصر
                  onChanged: (phone) {
                    // يمكنك إضافة العمليات التي تريدها هنا على أساس التغييرات في الحقل
                  },
                )
              : TextFormField(
                  controller: controller,
                  readOnly: !isEditMode, // Set readOnly based on edit mode
                  onTap: onTap,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    suffixIcon: labelText == "..."
                        ? Icon(
                            Icons.calendar_today,
                            color: Colors.grey[500],
                          )
                        : null,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // تجعل النص داخل الحقل bold
                  ),
                ),
    );
  }

  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        onChanged: isEditMode
            ? (value) {
                setState(() {
                  selectedGender = value;
                });
              }
            : null, // Disable onChanged outside edit mode
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          labelText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        items: ["Male", "Female"].map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!isEditMode) return; // Exit if not in edit mode

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
}
