import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'National ID Insight',
      theme: ThemeData(
        primaryColor: Color(0xFF181819),
        scaffoldBackgroundColor: Color(0xFF181819),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatelessWidget {
  final TextEditingController _nicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            Text('National ID Insight', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF181819), Color(0xFF1E1E2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 8),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nicController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Enter NIC Number',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFB006D),
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      String nic = _nicController.text.trim();
                      if (nic.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(nic: nic),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please enter a valid NIC number')),
                        );
                      }
                    },
                    child: Text('Decode NIC',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String nic;
  ResultScreen({required this.nic});

  String getGender(int dayOfYear) {
    return dayOfYear < 500 ? 'Male' : 'Female';
  }

  String getWeekdayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  Map<String, dynamic> decodeNIC(String nic) {
    bool isOldFormat = nic.length == 10;
    int birthYear;
    int dayOfYear;
    String gender;
    DateTime dateOfBirth;
    int age;
    String weekdayName;
    String serialNumber;
    String formatType;
    String? voteAbility;

    if (isOldFormat) {
      birthYear = int.parse(nic.substring(0, 2)) + 1900;
      dayOfYear = int.parse(nic.substring(2, 5));
      formatType = "Old Format (Before 2016)";
      gender = getGender(dayOfYear);
      dateOfBirth =
          DateTime(birthYear, 1, 1).add(Duration(days: dayOfYear - 1));
      age = DateTime.now().year - birthYear;
      weekdayName = getWeekdayName(dateOfBirth);
      serialNumber = nic.substring(5, 9);
      voteAbility = nic[9].toUpperCase() == 'V' ? 'Can Vote' : 'Cannot Vote';
    } else {
      birthYear = int.parse(nic.substring(0, 4));
      dayOfYear = int.parse(nic.substring(4, 7));
      formatType = "New Format (After 2016)";
      gender = getGender(dayOfYear);
      dateOfBirth =
          DateTime(birthYear, 1, 1).add(Duration(days: dayOfYear - 1));
      age = DateTime.now().year - birthYear;
      weekdayName = getWeekdayName(dateOfBirth);
      serialNumber = nic.substring(7, 12);
    }

    return {
      'formatType': formatType,
      'dateOfBirth': dateOfBirth,
      'weekdayName': weekdayName,
      'age': age,
      'gender': gender,
      'serialNumber': serialNumber,
      'voteAbility': voteAbility,
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> decodedData = decodeNIC(nic);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('National ID Insight Result',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF181819), Color(0xFF1E1E2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.black45,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                        Icons.calendar_today,
                        'Date of Birth',
                        DateFormat('yyyy-MM-dd')
                            .format(decodedData['dateOfBirth'])),
                    _buildInfoRow(
                        Icons.today, 'Weekday', decodedData['weekdayName']),
                    _buildInfoRow(
                        Icons.cake, 'Age', decodedData['age'].toString()),
                    _buildInfoRow(Icons.wc, 'Gender', decodedData['gender']),
                    _buildInfoRow(
                        Icons.info, 'NIC Format', decodedData['formatType']),
                    _buildInfoRow(Icons.confirmation_number, 'Serial Number',
                        decodedData['serialNumber']),
                    if (decodedData['voteAbility'] != null)
                      _buildInfoRow(Icons.how_to_vote, 'Voting Eligibility',
                          decodedData['voteAbility']!),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFB006D),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
              label: Text('Back', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 22),
          SizedBox(width: 10),
          Text('$label:',
              style: TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          Expanded(child: Text(value, style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
