import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shulea_app/auth/constants.dart';
import 'package:shulea_app/colors/colors.dart';
import 'dart:convert';
import 'package:shulea_app/models/main_academic_models.dart';
import 'package:shulea_app/screens/student_progress_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academic Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AcademicSelectionPage(),
    );
  }
}

class AcademicSelectionPage extends StatefulWidget {
  const AcademicSelectionPage({super.key});

  @override
  AcademicSelectionPageState createState() => AcademicSelectionPageState();
}

class AcademicSelectionPageState extends State<AcademicSelectionPage> {
  int? selectedYear;
  Term? selectedTerm;
  Exam? selectedExam;
  Grade? selectedGrade;
  Student? selectedStudent;
  bool _isLoading = false;

  List<AcademicYear> academicYears = [];
  List<Term> terms = [];
  List<Exam> exams = [];
  List<Grade> grades = [];
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    fetchAcademicYears();
    fetchExams();
  }

  Future<void> fetchAcademicYears() async {
    const String academicYearsUrl = '${ApiEndpoints.baseUrl}/actions/allYears';
    await initHeaders();
    final response = await http.get(
      Uri.parse(academicYearsUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        academicYears =
            data.map((json) => AcademicYear.fromJson(json)).toList();
      });
    } else {}
  }

  Future<void> fetchExams() async {
    String baseUrl = '${ApiEndpoints.baseUrl}/actions/allExams';
    String urlWithQueryParams =
        selectedYear != null ? '$baseUrl?year=$selectedYear' : baseUrl;
    setState(() {
      _isLoading = true;
      exams = [];
    });
    await initHeaders();
    final response = await http.get(
      Uri.parse(urlWithQueryParams),
      headers: headers,
    );
    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Exam> fetchedExams =
          jsonResponse.map((data) => Exam.fromJson(data)).toList();

      setState(() {
        exams = fetchedExams;
      });
    } else {
      exams = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Set academic year',
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<AcademicYear>(
                    hint: const Text(
                      "change academic year",
                      style: TextStyle(fontSize: 20),
                    ),
                    items: academicYears.map((AcademicYear year) {
                      return DropdownMenuItem<AcademicYear>(
                        value: year,
                        child: Text(
                          year.name,
                          style: const TextStyle(
                            fontSize: 20, // Set the font size
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newvalue) {
                      setState(() {
                        selectedYear = newvalue?.id;
                        fetchExams();
                      });
                    }),
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: exams.isEmpty
                          ? const Text("No data found")
                          : ListView.builder(
                              shrinkWrap:
                                  true, // Add this property to limit the height of the ListView
                              physics:
                                  const NeverScrollableScrollPhysics(), // Disable scrolling on the outer SingleChildScrollView
                              itemCount: exams.length,
                              itemBuilder: (context, index) {
                                final exam = exams[index];
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: greyColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: SizedBox(
                                      height: screenHeight * 0.2,
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            "Label: ${exam.name}")),
                                                  ],
                                                ),
                                                Text("Year: ${exam.year_name}"),
                                                Text(
                                                    "Term : ${exam.term_name}"),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0, bottom: 8),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          aquaColor),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return MystudentDataScreen(
                                                      examId: exam.id,
                                                      term: exam.term,
                                                      year: exam.year,
                                                    );
                                                  }));
                                                },
                                                child: Text(
                                                  "Check it",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
            ])));
  }
}
