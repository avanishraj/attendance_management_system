import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'lastpage.dart';
import 'token_manager.dart';

class AttendanceModel {
  final String name;
  final String enrollmentNo;

  AttendanceModel({
    required this.name,
    required this.enrollmentNo,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      name: json['name'] as String,
      enrollmentNo: json['enrollment_no'] as String,
    );
  }

  @override
  String toString() {
    return 'AttendanceModel(name: $name, enrollmentNo: $enrollmentNo)';
  }
}

class AttendancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {
  List<AttendanceModel> studentsList = [];
  final tokenManager = TokenManager(); // Create an instance of TokenManager
  String courseName = ''; // Add a variable to store the course name
  String stream = ''; // Add a variable to store the stream
  List<bool> isSelected =
      []; // Add a list to track the selection status of each student
  List<AttendanceModel> selectedStudents = [];
  bool _isMounted = false;

  Future<String> getCourseName() async {
    try {
      final token = await tokenManager
          .getToken(); // Retrieve the token using TokenManager
      if (token == null) {
        throw Exception('Token not found');
      }

      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
      };

      final url =
          Uri.parse('https://sdcusarattendance.onrender.com/api/v1/getClasses');

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>;
        final batches = data['batches'] as List<dynamic>;
        final subjectName = batches[0]['subject_name'] as String;
        final stream = batches[0]['stream'] as String; // Fetch the stream
        setState(() {
          courseName = subjectName;
          this.stream =
              stream; // Assign the fetched stream to the stream variable
        });
        return subjectName; // Return the course name
      } else {
        throw Exception('Failed to fetch subject name');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true; // Set the mounted state to true
    getCourseName().then((name) {
      if (_isMounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          courseName = name;
        });
      }
    }).catchError((error) {
      print('Error fetching course name: $error');
    });
  }

  @override
  void dispose() {
    _isMounted =
        false; // Set the mounted state to false when disposing the widget
    super.dispose();
  }

  Future<List<AttendanceModel>> getStudentsDataApi(
      String batchId, String semster) async {
    try {
      final token = await tokenManager
          .getToken(); // Retrieve the token using TokenManager
      if (token == null) {
        throw Exception('Token not found');
      }

      final headers = {
        'Authorization':
            token, // Include the token in the Authorization header as a token
        'Content-Type': 'application/json',
      };

      final url = Uri.parse(
          'https://sdcusarattendance.onrender.com/api/v1/getStudents');

      final body = {
        'batchId': batchId,
        'semster': semster,
      };

      final response =
          await http.post(url, headers: headers, body: json.encode(body));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success']) {
          final students = responseData['result'] as List;
          studentsList =
              students.map((json) => AttendanceModel.fromJson(json)).toList();
          setState(() {
            isSelected = List.generate(studentsList.length, (index) => false);
          });
          return studentsList;
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 100,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        courseName,
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        stream, // Add the stream variable here
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Expanded(
                  child: FutureBuilder<List<AttendanceModel>>(
                    future: getStudentsDataApi("23", "4"),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final student = snapshot.data![index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Color.fromRGBO(4, 29, 83, 1),
                                child: Icon(
                                  Icons.person_outline_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(student.name),
                              subtitle: Text(student.enrollmentNo),
                              trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    final isSelected =
                                        !selectedStudents.contains(student);
                                    if (isSelected) {
                                      selectedStudents.add(
                                          student); // Add the student to the selected students list
                                    } else {
                                      selectedStudents.remove(
                                          student); // Remove the student from the selected students list
                                    }
                                    print(
                                        'Selected Students: $selectedStudents');
                                  });
                                },
                                child: Icon(
                                  selectedStudents.contains(student)
                                      ? Icons.check_circle
                                      : Icons.circle,
                                  size: 40,
                                  color: selectedStudents.contains(student)
                                      ? Color.fromRGBO(4, 29, 83, 1)
                                      : Colors.grey,
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return AlertDialog(
                          title: Text('Welcome'),
                          content: Text('${snapshot.error}'),
                          actions: [],
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(15)),
              SizedBox(
                height: 50,
                width: 320,
                child: SlideAction(
                  outerColor: Color.fromRGBO(0, 70, 121, 1),
                  innerColor: Colors.white,
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  onSubmit: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confirm Attendance',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  'Selected Students:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: selectedStudents.map((student) {
                                    return Text(
                                      student.name,
                                      style: TextStyle(fontSize: 14.0),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                    SizedBox(width: 10.0),
                                    ElevatedButton(
                                      child: Text(
                                        'Confirm',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        markAttendance(
                                            selectedStudents); // Call the function to mark attendance
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(padding: EdgeInsets.all(15)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> markAttendance(List<AttendanceModel> selectedStudents) async {
    try {
      final token = await tokenManager
          .getToken(); // Retrieve the token using TokenManager
      if (token == null) {
        throw Exception('Token not found');
      }

      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
      };

      final url = Uri.parse(
          'https://sdcusarattendance.onrender.com/api/v1/markingattendance');

      final body = {
        'data': selectedStudents.map((student) {
          return {
            'enrollment_no': student.enrollmentNo,
            'attendancestatus':
                1, // Set the attendance status as required (1 for present, 0 for absent)
          };
        }).toList(),
      };

      final response =
          await http.post(url, headers: headers, body: json.encode(body));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        // Process the response if needed
        print('Attendance marked successfully');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SubmitPage()));
      } else {
        throw Exception(
            'Failed to mark attendance. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
