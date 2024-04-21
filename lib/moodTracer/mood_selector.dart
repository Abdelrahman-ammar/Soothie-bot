import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sentiment.dart';

class MoodSelector extends StatefulWidget {
  final Function(SentimentRecording) onSelected;
  final void Function(double) updateSelectedMood;
  const MoodSelector({
    Key? key,
    required this.onSelected,
    required this.updateSelectedMood,
  }) : super(key: key);

  @override
  createState() => new MoodSelectorState(
        onSelected,
        updateSelectedMood,
      );
}

class MoodSelectorState extends State<MoodSelector> {
  var timeFormatter = new DateFormat('jm');
  var dayFormatter = new DateFormat('MMMd');
  DateTime selectedDate = DateTime.now();

  final ValueSetter<SentimentRecording> onSelected;
  final void Function(double) updateSelectedMood;

  MoodSelectorState(this.onSelected, this.updateSelectedMood);

  double selectedMoodPercentage = 0.0;

  void _handleSentiment(Sentiment sentiment) {
    double moodPercentage = 0.0;

    if (sentiment == Sentiment.veryHappy) {
      moodPercentage = 1.0;
    } else if (sentiment == Sentiment.happy) {
      moodPercentage = 0.75;
    } else if (sentiment == Sentiment.neutral) {
      moodPercentage = 0.5;
    } else if (sentiment == Sentiment.unhappy) {
      moodPercentage = 0.25;
    } else if (sentiment == Sentiment.veryUnhappy) {
      moodPercentage = 0.1;
    }

    setState(() {
      selectedMoodPercentage = moodPercentage;
    });

    updateSelectedMood(selectedMoodPercentage);

    widget.onSelected(SentimentRecording(
      sentiment,
      DateTime.now(),
      activities: ['activity1', 'activity2'],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(200),
          bottomRight: Radius.circular(200),
          topLeft: Radius.circular(200),
          topRight: Radius.circular(200),
        ),
      ),
      color: const Color.fromARGB(255, 217, 224, 226),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            ButtonBar(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => _handleSentiment(Sentiment.veryHappy),
                        icon: const Icon(Icons.sentiment_very_satisfied),
                        iconSize: 40.0,
                        color: Colors.blueGrey,
                      ),
                      IconButton(
                        onPressed: () => _handleSentiment(Sentiment.happy),
                        icon: const Icon(Icons.sentiment_satisfied),
                        iconSize: 40.0,
                        color: Colors.blueGrey,
                      ),
                      IconButton(
                        onPressed: () => _handleSentiment(Sentiment.neutral),
                        icon: const Icon(Icons.sentiment_neutral),
                        iconSize: 40.0,
                        color: Colors.blueGrey,
                      ),
                      IconButton(
                        onPressed: () => _handleSentiment(Sentiment.unhappy),
                        icon: const Icon(Icons.sentiment_dissatisfied),
                        iconSize: 40.0,
                        color: Colors.blueGrey,
                      ),
                      IconButton(
                        onPressed: () =>
                            _handleSentiment(Sentiment.veryUnhappy),
                        icon: const Icon(Icons.sentiment_very_dissatisfied),
                        iconSize: 40.0,
                        color: Colors.blueGrey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
