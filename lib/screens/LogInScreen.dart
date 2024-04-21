import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapfeature_project/NavigationBar.dart';
import 'package:mapfeature_project/helper/show_snack_bar.dart';
import 'package:mapfeature_project/moodTracer/sentiment.dart';
import 'package:mapfeature_project/screens/resetpassScreen.dart';
import 'package:mapfeature_project/widgets/customButton.dart';
import 'package:mapfeature_project/widgets/customTextField.dart';
import 'package:mapfeature_project/widgets/customdivider.dart';
import 'package:mapfeature_project/widgets/passwordfield.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LogInScreen extends StatefulWidget {
  final String? token; // Add token parameter here

  const LogInScreen({Key? key, this.token}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  List<SentimentRecording> moodRecordings = [];
  String? userId;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          height: double.infinity,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                DividerImage(),
                const SizedBox(height: 35),
                Container(
                  height: 500,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F8F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 210, top: 20),
                              child: Text(
                                'Hello !',
                                style: TextStyle(
                                  fontFamily: 'Langar',
                                  fontSize: 29,
                                  color: Color.fromARGB(255, 128, 133, 134),
                                ),
                              ),
                            ),
                            Text(
                              'WELCOME BACK',
                              style: TextStyle(
                                fontFamily: 'Langar',
                                fontSize: 29,
                                color: Color(0xff1F5D6B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        CustomFormTextField(
                          onChanged: (data) {
                            email = data;
                          },
                          hintText: '  Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            if (!RegExp(
                                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value)) {
                              return 'Invalid email format';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        PasswordField(
                          onChanged: (data) {
                            password = data;
                          },
                          hintText: '  Password',
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            if (email != null) {
                              try {
                                // Call the forgetPassword function with the entered email
                                await forgetPassword(email!);
                                // Navigate to the ResetPasswordScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ResetPasswordScreen(email: email!),
                                  ),
                                );
                                // showSnackBar(context,
                                //     'Password reset instructions sent to your email');
                              } catch (e) {
                                // Handle any errors, such as network issues or invalid email
                                print(e.toString());
                                showSnackBar(
                                    context, 'Failed to reset password');
                              }
                            } else {
                              // Handle the case where email is null
                              showSnackBar(context, 'Please enter your email');
                            }
                          },
                          child: const Text(
                            'Forgot Password ? ',
                            style: TextStyle(
                              fontFamily: 'Langar',
                              fontSize: 18,
                              color: Color(0xff1F5D6B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await loginUser();
                              } catch (ex) {
                                print(ex);
                                showSnackBar(context, 'There was an error');
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          text: '    Log in    ',
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontFamily: 'Langar',
                                color: Color.fromARGB(255, 136, 136, 136),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to the sign-up screen
                                Navigator.pushNamed(context, 'signup');
                              },
                              child: const Text(
                                ' Sign up',
                                style: TextStyle(
                                  fontFamily: 'Langar',
                                  color: Color(0xff1F5D6B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> forgetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://mental-health-ef371ab8b1fd.herokuapp.com/api/forget_password'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        // Password reset link sent successfully
        // Navigate to the ResetPasswordScreen with email parameter
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: email),
          ),
        );
        showSnackBar(context, 'Password reset instructions sent to your email');
      } else {
        // Handle other status codes (error scenarios)
        // For example, if the email entered by the user is not registered
        showSnackBar(context, 'Email address not found');
      }
    } catch (e) {
      // Handle network errors
      print(e.toString());
      showSnackBar(context, 'Failed to connect to the server');
    }
  }

  Future<void> loginUser() async {
    try {
      final response = await http.post(
        Uri.parse('https://mental-health-ef371ab8b1fd.herokuapp.com/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email!,
          'password': password!,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String userId = responseData['id'].toString();
        String name = responseData['Name'];
        String userEmail = responseData['email'];
        String token = responseData['token'];

        // Here you can use the user information as needed
        print('User ID: $userId');
        print('Name: $name');
        print('Email: $userEmail');
        print('Token: $token');

        // Example: Navigate to the home screen with userId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationTabs(
              userId: userId,
              moodRecordings: moodRecordings,
              onMoodSelected: (moodRecording) {
                setState(() {
                  moodRecordings.add(moodRecording);
                });
              },
              selectedMoodPercentage: 0.0,
              token: responseData['token'],
            ),
          ),
        );
      } else if (response.statusCode == 401) {
        throw Exception('Email not registered or wrong password');
      } else if (response.statusCode == 403) {
        throw Exception('Invalid user information');
      } else {
        throw Exception('Failed to log in');
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(context, 'Failed to connect to the server');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
