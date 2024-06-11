// ignore_for_file: non_constant_identifier_names

class AcademicYear {
  final int id;
  final String name;

  AcademicYear({required this.id, required this.name});

  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class Term {
  final String id;
  final String name;

  Term({required this.id, required this.name});

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Exam {
  final int id;
  final String? term_name; // Corrected to match JSON key
  final String? year_name; // Corrected to match JSON key
  final String name;
  final bool published;
  final int school;
  final int year;
  final int term;

  Exam({
    required this.id,
    required this.term_name,
    required this.year_name,
    required this.name,
    required this.published,
    required this.school,
    required this.year,
    required this.term,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as int,
      term_name: json["term_name"] as String?,
      year_name: json['year_name'] as String?,
      name: json['name'] as String,
      published: json['published'] as bool,
      school: json['school'] as int,
      year: json['year'] as int,
      term: json['term'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'term_name': term_name,
        'year_name': year_name,
        'name': name,
        'published': published,
        'school': school,
        'year': year,
        'term': term,
      };

  // Other methods remain unchanged...
}

class Grade {
  final int id;
  final int name;
  final String? stream;

  Grade({required this.id, required this.name, this.stream});

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'] as int,
      name: json['name'] as int,
      stream: json["stream"] as String,
    );
  }
}

class Student {
  final int id;
  final String name;

  Student({required this.id, required this.name});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class ExamResult {
  final int id;
  final String subjectName;
  final String grade;
  final int score;
  final int? previousScore;
  final int? scoreChange;
  final double? percentageChange;
  final String studentName;

  ExamResult({
    required this.id,
    required this.subjectName,
    required this.grade,
    required this.score,
    this.previousScore,
    this.scoreChange,
    this.percentageChange,
    required this.studentName,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id'] as int,
      subjectName: json['subject_name'] as String,
      studentName: json["student_name"] as String,
      grade: json['grade'] as String,
      score: json['score'] as int,
      previousScore:
          json['previous_score'] != null ? json['previous_score'] as int : null,
      scoreChange:
          json['score_change'] != null ? json['score_change'] as int : null,
      percentageChange: json['percentage_change'] != null
          ? json['percentage_change'] as double
          : null,
    );
  }
}

class ExamReport {
  final int studentCurrentGrade;
  final List<ExamResult> examResults;
  final int totalMarks;
  final int previousTotalMarks;
  final double? percentageChange;
  final Map<String, int> examWiseTotals;

  ExamReport({
    required this.studentCurrentGrade,
    required this.examResults,
    required this.totalMarks,
    required this.previousTotalMarks,
    this.percentageChange,
    required this.examWiseTotals,
  });

  factory ExamReport.fromJson(Map<String, dynamic> json) {
    var list = json['exam_results'] as List;
    List<ExamResult> examResultsList =
        list.map((i) => ExamResult.fromJson(i)).toList();

    return ExamReport(
      studentCurrentGrade: json['student_current_grade'] as int,
      examResults: examResultsList,
      totalMarks: json['total_marks'] as int,
      previousTotalMarks: json['previous_total_marks'] as int,
      percentageChange: json['percentage_change'] != null
          ? json['percentage_change'] as double
          : null,
      examWiseTotals: Map<String, int>.from(json['exam_wise_totals']),
    );
  }
}
