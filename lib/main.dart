import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapfeature_project/Test/firstscreen.dart';
import 'package:mapfeature_project/screens/OTP_Screen.dart';
import 'package:mapfeature_project/screens/QuotesCategoryScreen.dart';
import 'package:mapfeature_project/screens/activities.dart';
import 'package:mapfeature_project/screens/moviesscreen.dart';
import 'package:mapfeature_project/screens/musicScreen.dart';
import 'package:mapfeature_project/screens/soothe_screen.dart';
import 'package:mapfeature_project/NavigationBar.dart';
import 'package:mapfeature_project/moodTracer/sentiment.dart';
import 'package:mapfeature_project/screens/ChatScreen.dart';
import 'package:mapfeature_project/screens/LogInScreen.dart';
import 'package:mapfeature_project/screens/SignUpScreen.dart';
import 'package:mapfeature_project/Todo/todo.dart';

int userScore = 0;
int cognitiveScore = 0;
int somaticScore = 0;
late Box<Map<String, dynamic>> _messagesBox; // Hive box for storing messages

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await Hive.initFlutter(); // Initialize Hive
  _messagesBox =
      await Hive.openBox<Map<String, dynamic>>('messages'); // Open Hive box
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final String? token;
  final String? userId; // Add userId here
  final String? userName; // Add userName here
  const MyApp({Key? key, this.token, this.userId, this.userName})
      : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<SentimentRecording> moodRecordings = [];
  String? userId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'login': (context) => const LogInScreen(),
        'signup': (context) => const SignUpScreen(),
        'otp_screen': (context) {
          final userId = ModalRoute.of(context)!.settings.arguments as String?;
          return OtpScreen(userId: userId);
        },

        'chat': (context) => ChatBot(
            userId: widget.userId ?? "", userName: widget.userName ?? ""),
        'test': (context) => const testScreen(),
        'QCategory': (context) => QuotesCategoryScreen(),
        'sothee': (context) => const sotheeScreen(),
        'movies': (context) => MoviesScreen(), // Use MoviesScreen as a route
        'music': (context) => const musicScreen(),
        'recommendation': (context) => RecommendationsScreen(),
        'Todo': (context) =>  const HomePage(),
        'navigator': (context) => NavigationTabs(
              userId: userId,
              moodRecordings: moodRecordings,
              onMoodSelected: (moodRecording) {
                setState(() {
                  moodRecordings.add(moodRecording);
                });
              },
              selectedMoodPercentage: 0.0,
              token: widget.token ?? '', // Provide a value here
            ),
      },
      initialRoute: 'sothee',
    );
  }
}
