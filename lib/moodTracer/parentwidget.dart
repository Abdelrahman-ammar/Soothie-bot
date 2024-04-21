import 'package:flutter/material.dart';

class MoodGraph extends StatelessWidget {
  final Map<String, double> moodData;

  MoodGraph({
    required this.moodData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDayColumn('Mon', moodData['Mon'] ?? 0.0),
          _buildDayColumn('Tue', moodData['Tue'] ?? 0.0),
          _buildDayColumn('Wed', moodData['Wed'] ?? 0.0),
          _buildDayColumn('Thu', moodData['Thu'] ?? 0.0),
          _buildDayColumn('Fri', moodData['Fri'] ?? 0.0),
          _buildDayColumn('Sat', moodData['Sat'] ?? 0.0),
          _buildDayColumn('Sun', moodData['Sun'] ?? 0.0),
        ],
      ),
    );
  }

  Widget _buildDayColumn(String day, double moodPercentage) {
    final double maxHeight = 120.0;
    bool isCurrentDay = _isCurrentDay(day);

    return Column(
      children: [
        Container(
          width: 30.0,
          height: maxHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: maxHeight * (1 - moodPercentage),
                color: Colors.grey.withOpacity(0.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
              ),
              if (isCurrentDay)
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: maxHeight * moodPercentage,
                    width: 30.0,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                  ),
                )
              else
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: maxHeight * moodPercentage,
                    width: 30.0,
                    decoration: BoxDecoration(
                      color: _getColorForMood(moodPercentage),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          day,
          style: TextStyle(
            fontSize: 16.0,
            color: isCurrentDay ? Colors.blue : null,
          ),
        ),
      ],
    );
  }

  Color _getColorForMood(double moodPercentage) {
    if (moodPercentage >= 0.75) {
      return Colors.green;
    } else if (moodPercentage >= 0.5) {
      return Colors.yellow;
    } else if (moodPercentage >= 0.25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  bool _isCurrentDay(String day) {
    DateTime now = DateTime.now();
    String currentDay = _getDayName(now.weekday);
    return currentDay == day;
  }

  String _getDayName(int dayIndex) {
    switch (dayIndex) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
