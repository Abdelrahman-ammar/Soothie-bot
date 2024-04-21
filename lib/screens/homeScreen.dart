// HOMEScreen file
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapfeature_project/moodTracer/mood_selector.dart';
import 'package:mapfeature_project/moodTracer/sentiment.dart';
import 'package:mapfeature_project/screens/ChatScreen.dart';
import 'package:mapfeature_project/moodTracer/graph.dart';
import 'package:mapfeature_project/Todo/todo.dart';


class HOMEScreen extends StatefulWidget {
  final String userId;
  final List<SentimentRecording> moodRecordings;
  final Function(SentimentRecording) onMoodSelected;
  final double selectedMoodPercentage;
  final String token;

  HOMEScreen({
    required this.userId,
    required this.moodRecordings,
    required this.onMoodSelected,
    required this.selectedMoodPercentage,
    required this.token,
  });

  @override
  _HOMEScreenState createState() => _HOMEScreenState();
}

class _HOMEScreenState extends State<HOMEScreen> {
  String userName = '';
  double selectedMoodPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(int.parse(widget.userId)).then((profileData) {
      if (profileData != null) {
        setState(() {
          userName = profileData['name']; // Assign the user's name
        });
      }
    });
  }

  Future<Map<String, dynamic>?> _fetchUserProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://mental-health-ef371ab8b1fd.herokuapp.com/api/users/$userId'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to fetch user profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  //  Future<void> getdata() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://mental-health-ef371ab8b1fd.herokuapp.com/api/login'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },

  //     );

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseData = jsonDecode(response.body);
  //       String userId = responseData['id'].toString();
  //       String name = responseData['Name'];
  //       // String userEmail = responseData['email'];
  //       String token = responseData['token'];

  //       // Here you can use the user information as needed
  //       print('User ID: $userId');
  //       print('Name: $name');
  //       // print('Email: $userEmail');
  //       print('Token: $token');

  //       // Example: Navigate to the home screen with userId
  //     }}catch (e) {
  //     print(e.toString());
  //   //   showSnackBar(context, 'Failed to connect to the server');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          Stack(
            children: [
              Container(
                height: 100.0,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Card(
                  elevation: 4.0,
                  shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80.0),
                      topLeft: Radius.circular(80.0),
                    ),
                  ),
                  color: const Color(0xffC4DEE4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          top: 30.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello $userName,',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                fontFamily: 'Langar',
                              ),
                            ),
                            const Text(
                              'How are you feeling today ? ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: 'Langar',
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Image.asset(
                            'images/photo_2024-01-17_04-23-53-removebg-preview.png',
                            width: 140.0,
                            height: 220.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 190,
                left: 30,
                child: MoodSelector(
                  onSelected: widget.onMoodSelected,
                  updateSelectedMood:
                      _updateSelectedMood, // Pass updateSelectedMood here
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 290, right: 20, left: 20),
                child: MoodGraph(
                  moodData: {'currentDay': selectedMoodPercentage},
                  selectedMoodPercentage: selectedMoodPercentage,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 470, right: 10, left: 10),
                child: _buildFeatureList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _labelText(String labelText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        labelText,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          fontFamily: 'Langar',
          color: Color(0xff1F5D6B),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelText('AI Friend'),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatBot(
                  userId: widget.userId,
                  userName: userName, // Pass the userName to ChatBot
                ),
              ),
            );
          },
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xffC4DEE4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 6, top: 10, bottom: 4),
                  child: Image.asset(
                    'images/photo_2024-01-17_04-14-54-removebg-preview.png',
                    width: 100,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 70.0),
                  child: Text(
                    'How was your Day ?',
                    style: TextStyle(
                        fontFamily: 'Langar',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        _labelText('SELF TEST'), // Add spacing between label and cards
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'test');
          },
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xffC4DEE4),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 70.0),
                  child: Text(
                    'Beck Depression Test',
                    style: TextStyle(
                        fontFamily: 'Langar',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 6, top: 0, bottom: 0),
                  child: Image.asset(
                    'images/photo_2024-01-18_02-56-42-removebg-preview.png',
                    width: 140,
                    height: 160,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),
        _labelText('SELF CARE KIT'),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'recommendation');
          },
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xffC4DEE4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5, bottom: 4),
                  child: Image.asset(
                    'images/photo_2024-01-18_02-56-32-removebg-preview.png',
                    width: 100,
                    height: 150,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '100+',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Langar',
                            color: Colors.white),
                      ),
                      Text(
                        'Recommendations',
                        style: TextStyle(
                            fontFamily: 'Langar',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'To Ease Your Mind',
                        style: TextStyle(
                            fontFamily: 'Langar',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _labelText('TIME KEEPER'),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'Todo');
          },
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xffC4DEE4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5, bottom: 4),
                  child: Image.asset(
                    "images/photo_2024-01-18_05-46-33-removebg-preview.png",
                    width: 100,
                    height: 150,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time Table Companion',
                        style: TextStyle(
                            fontFamily: 'Langar',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Add more sets as needed
      ],
    );
  }

  void _updateSelectedMood(double moodPercentage) {
    setState(() {
      selectedMoodPercentage = moodPercentage;
    });
  }
}
