import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:user_registration/components/my_button.dart';
import 'package:user_registration/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final collegeController = TextEditingController();
  final yearController = TextEditingController();

  static String selectedValue = "Student";
  String imgUrl = "";

  // reading the message with the help of the data got from the server
  // Stream<List<User>> readMessage() => FirebaseFirestore.instance
  //     .collection(widget.whichChat!)
  //     .orderBy('sentTime')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());

  Future createUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                    ),
                    value: selectedValue,
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 20),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: dropdownItems),
              ),
              Row(
                children: [
                  // name field
                  Text(
                    "Enter your name: ",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: MyTextField(
                      controller: nameController,
                      hintText: 'Name',
                      obscureText: false,
                    ),
                  ),
                ],
              ),

              // email field
              Row(
                children: [
                  Text(
                    "Enter your Email: ",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                  ),
                ],
              ),

              // password field
              Row(
                children: [
                  Text(
                    "Enter your Password: ",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: MyTextField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                  ),
                ],
              ),

              //phone number field
              Row(
                children: [
                  Text(
                    "Enter your Phone: ",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: MyTextField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      hintText: 'Phone no.',
                      obscureText: false,
                    ),
                  ),
                ],
              ),

              //college name field
              Row(
                children: [
                  Text(
                    "Enter your College: ",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: MyTextField(
                      controller: collegeController,
                      hintText: 'College ',
                      obscureText: false,
                    ),
                  ),
                ],
              ),

              //if student then admission year else means Alumini then passout year
              if (!(selectedValue == "Faculty"))
                Row(
                  children: [
                    Text(
                      (selectedValue == "Student")
                          ? "Enter your Admission Year: "
                          : "Enter your Passout Year: ",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: MyTextField(
                        keyboardType: TextInputType.number,
                        controller: yearController,
                        hintText: 'Year ',
                        obscureText: false,
                      ),
                    ),
                  ],
                ),
              Row(
                children: [
                  Text(
                    "Upload your profile picture: ",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.camera);
                        print('${file?.path}');

                         if (file == null) return;
                    //Import dart:core
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                        //step 2 : upload the image to firebase storage
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('images');

                        //Create a reference for the image to be stored
                        Reference referenceImageToUpload =
                            referenceDirImages.child(uniqueFileName);

                        //Handle errors/success
                    try {
                      //Store the file
                      await referenceImageToUpload.putFile(File(file.path));
                      //Success: get the download URL
                      imgUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      //Some error occurred
                    }
                      },
                      icon: const Icon(Icons.file_upload_outlined))
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              MyButton(
                  onTap: () {
                    if (imgUrl.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Please upload an image')));

                      return;
                    }
                    User user = User(
                      type: selectedValue,
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      college: collegeController.text,
                      phone: phoneController.text,
                      year: yearController.text,
                      image: imgUrl,
                    );
                    createUser(user);
                    setState(() {
                      nameController.text = '';
                      emailController.text = '';
                      passwordController.text = '';
                      collegeController.text = '';
                      phoneController.text = '';
                      yearController.text = '';
                      passwordController.text = '';
                    });
                  },
                  text: "Submit")
            ],
          ),
        ),
      ),
    );
  }
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(child: Text("Student"), value: "Student"),
    const DropdownMenuItem(child: Text("Faculty"), value: "Faculty"),
    const DropdownMenuItem(child: Text("Alumni"), value: "Alumni"),
  ];
  return menuItems;
}

//message class definition
class User {
  String? id;
  final String type;

  final String name;
  final String email;
  final String password;
  final String college;
  final String phone;
  String? year;
  String? image;

  final sentTime = DateTime.now().toLocal();

  User({
    this.id,
    required this.type,
    this.year,
    this.image,
    required this.name,
    required this.email,
    required this.password,
    required this.college,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'sentTime': sentTime,
        'name': name,
        'email': email,
        'password': password,
        'college': college,
        'phone': phone,
        'year': year,
        'image': image,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        type: json['type'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        college: json['college'],
        phone: json['phone'],
        year: json['year'],
        image: json['image'],
      );
}
