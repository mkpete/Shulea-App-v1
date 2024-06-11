// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shulea_app/auth/constants.dart';
import 'package:shulea_app/colors/colors.dart';
import 'package:shulea_app/models/main_academic_models.dart';

class MystudentDataScreen extends StatefulWidget {
  final int examId;
  final int year;
  final int term;
  const MystudentDataScreen({
    super.key,
    required this.examId,
    required this.year,
    required this.term,
  });

  @override
  State<MystudentDataScreen> createState() => _MystudentDataScreenState();
}

class _MystudentDataScreenState extends State<MystudentDataScreen> {
  Grade? selectedGrade;
  Student? selectedStudent;
  bool isLoading = false;

  List<Student> students = [];
  List<Grade> grades = [];
  ExamReport? examReport;

  @override
  void initState() {
    super.initState();
    fetchGrades();
    fetchMyStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set Grade",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: aquaColor,
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: DropdownButtonFormField<Grade>(
                              hint: const Text(
                                "grade",
                                style: TextStyle(fontSize: 20),
                              ),
                              items: grades.map((Grade grade) {
                                final String combinedName = grade.stream != null
                                    ? 'grade ${grade.name} ${grade.stream}'
                                    : 'grade ${grade.name}';
                                return DropdownMenuItem<Grade>(
                                  value: grade,
                                  child: Text(
                                    combinedName,
                                    style: const TextStyle(
                                      fontSize: 20, // Set the font size
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newvalue) {
                                setState(() {
                                  selectedGrade = newvalue;
                                  _fetchExamReport();
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 2,
                            child: DropdownButtonFormField<Student>(
                              hint: const Text(
                                "student",
                                style: TextStyle(fontSize: 20),
                              ),
                              items: students.map((Student student) {
                                return DropdownMenuItem<Student>(
                                  value: student,
                                  child: Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontSize: 20, // Set the font size
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newvalue) {
                                setState(() {
                                  selectedStudent = newvalue;
                                  _fetchExamReport();
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    if (examReport != null &&
                        examReport!.examResults.isNotEmpty) ...[
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Student name",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text("${examReport?.examResults[0].studentName}"),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  "Current grade",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    'Grade: ${examReport!.studentCurrentGrade}')
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildExamResultsTable(),
                      const SizedBox(height: 20),
                      _buildExamWiseTotalsChart(),
                    ],
                    if (examReport == null || examReport!.examResults.isEmpty)
                      _buildErrorWidget()
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> fetchMyStudents() async {
    const String myStudentsUrl =
        '${ApiEndpoints.baseUrl}/actions/all/my/students';
    await initHeaders();
    final response = await http.get(
      Uri.parse(myStudentsUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        students =
            data.map((json) => Student.fromJson(json)).cast<Student>().toList();
      });
    } else {}
  }

  Future<void> fetchGrades() async {
    const String myStudentGradesUrl = '${ApiEndpoints.baseUrl}/actions/levels';
    await initHeaders();
    final response = await http.get(
      Uri.parse(myStudentGradesUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        grades =
            data.map((json) => Grade.fromJson(json)).cast<Grade>().toList();
      });
    } else {}
  }

  Future<void> _fetchExamReport() async {
    if (selectedGrade?.id != null && selectedStudent?.id != null) {
      String baseUrl =
          '${ApiEndpoints.baseUrl}/exam-results/compare/${widget.year}/${widget.term}/${widget.examId}/${selectedGrade?.id}/${selectedStudent?.id}';
      setState(() {
        examReport = null;
        isLoading = true;
      });
      await initHeaders();
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );
      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        ExamReport fetchedExamResult = ExamReport.fromJson(jsonResponse);
        setState(() {
          try {
            examReport = fetchedExamResult;
          } catch (e) {
            _buildErrorWidget();
          }
        });
      } else {
        examReport = [] as ExamReport?;
      }
    }
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Avoid excessive space
        children: [
          Icon(
            Icons.warning, // Or any other appropriate icon
            color: Colors.orange, // Adjust color as needed
            size: 48.0,
          ),
          SizedBox(height: 16.0),
          Text(
            "No exam report available",
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget _buildExamResultsTable() {
    if (examReport == null || examReport!.examResults.isEmpty) {
      _buildErrorWidget();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          children: [
            const TableRow(children: [
              TableCell(child: Center(child: Text('Subject'))),
              TableCell(child: Center(child: Text('Score'))),
              TableCell(child: Center(child: Text('Grade'))),
              TableCell(child: Center(child: Text('% Chge'))),
            ]),
            for (var result in examReport!.examResults)
              TableRow(children: [
                TableCell(child: Center(child: Text(result.subjectName))),
                TableCell(child: Center(child: Text(result.score.toString()))),
                TableCell(child: Center(child: Text(result.grade))),
                TableCell(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        result.scoreChange != null
                            ? Icon(
                                result.scoreChange! > 0
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: result.scoreChange! > 0
                                    ? Colors.green
                                    : Colors.red,
                              )
                            : const Text("0 %"),
                      ],
                    ),
                  ),
                ),
              ]),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Important summary",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ),
        Text("This exam's total:  ${examReport?.totalMarks} "),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Learner Deviation",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ),
        Text("Previous exam total:  ${examReport?.previousTotalMarks} "),
        Row(
          children: [
            const Text("Overal % Deviation :"),
            examReport?.percentageChange != null
                ? Text(
                    " ${examReport!.percentageChange?.abs().toStringAsFixed(2)}%",
                    style: TextStyle(
                      color: examReport!.percentageChange! > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  )
                : const Text("0 %"),
          ],
        )
      ],
    );
  }

  Widget _buildExamWiseTotalsChart() {
    List<BarChartGroupData> barGroups = [];
    int index = 0;
    examReport!.examWiseTotals.forEach((examName, total) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: total.toDouble(), // Updated to use 'y' instead of 'toY'
              color: greyColor, // Updated to use 'colors' array
              width: 20,
              borderRadius: BorderRadius.zero,
            ),
          ],
          // showingTooltipIndicators: [0],
        ),
      );
      index++;
    });

    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String? examName =
                      examReport?.examWiseTotals.keys.toList()[groupIndex];

                  if (examName != null) {
                    return BarTooltipItem(
                      '$examName\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: rod.toY
                              .round()
                              .toString(), // Updated to use 'rod.y' and round()
                          style: const TextStyle(
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Handle the case where examName is null (optional)
                    return null;
                  }
                },
              ),
            ),
            titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false, reservedSize: 16)),
                bottomTitles: AxisTitles(
                  drawBelowEverything: true,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 100,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      // Ensure the index is within bounds and handle null examReport
                      if (examReport != null &&
                          value >= 0 &&
                          value < examReport!.examWiseTotals.keys.length) {
                        return Transform(
                          alignment: Alignment.center,
                          transform:
                              Matrix4.rotationZ(pi / 4), // Rotate by 90 degrees

                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              examReport!.examWiseTotals.keys
                                  .elementAt(value.toInt()),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Text(
                            ''); // Return empty Text widget for out-of-bounds or null examReport
                      }
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                ))),
            barGroups: barGroups,
          ),
        ),
      ),
    );
  }
}
