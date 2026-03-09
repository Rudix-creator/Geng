import 'package:dart_application_practos/dart_application_practos.dart' as dart_application_practos;
import 'dart:io';

void main(List<String> arguments) {
  print('Hello world: ${dart_application_practos.calculate()}!');

  Map<String, Map<String, int>> journal = {
    'Иванов': {'Математика': 5, 'Физика': 4, 'Химия': 5, 'Информатика': 5},
    'Петров': {'Математика': 4, 'Физика': 4, 'Химия': 3, 'Информатика': 4},
    'Сидоров': {'Математика': 3, 'Физика': 2, 'Химия': 3, 'Информатика': 3},
    'Смирнова': {'Математика': 5, 'Физика': 5, 'Химия': 5, 'Информатика': 5},
    'Козлов': {'Математика': 4, 'Физика': 3, 'Химия': 4, 'Информатика': 2},
  };

  List<String> subjects = ['Математика', 'Физика', 'Химия', 'Информатика'];

  printSummaryTable(journal, subjects);
  searchStudent(journal, subjects, 'Иванов');
  searchStudent(journal, subjects, 'Сидоров');
  printUniqueGrades(journal);
  printMaxMinBySubject(journal, subjects);
  printStudentsWithOneTwo(journal, subjects);
  printSubjectsAboveAverage(journal, subjects);
  printCategoriesCount(journal, subjects);
}

void printSummaryTable(Map<String, Map<String, int>> journal, List<String> subjects) {
  print('\n1. Сводная таблица');
  stdout.write('Студент\t');
  for (var sub in subjects) stdout.write('$sub\t');
  print('Средний');
  print('-' * 70);

  double totalSum = 0;
  int totalCount = 0;

  for (var student in journal.keys) {
    stdout.write('$student\t');
    double studentSum = 0;
    int studentCount = 0;

    for (var sub in subjects) {
      int? grade = journal[student]?[sub];
      if (grade != null) {
        stdout.write('$grade\t');
        studentSum += grade;
        studentCount++;
        totalSum += grade;
        totalCount++;
      } else {
        stdout.write('-\t');
      }
    }

    double avg = studentCount > 0 ? studentSum / studentCount : 0;
    print(avg.toStringAsFixed(2));
  }

  print('-' * 70);
  stdout.write('Средний\t');
  for (var sub in subjects) {
    double sum = 0;
    int count = 0;
    for (var student in journal.keys) {
      int? grade = journal[student]?[sub];
      if (grade != null) {
        sum += grade;
        count++;
      }
    }
    double avg = count > 0 ? sum / count : 0;
    stdout.write('${avg.toStringAsFixed(1)}\t');
  }
  double overall = totalCount > 0 ? totalSum / totalCount : 0;
  print(overall.toStringAsFixed(2));
}

void searchStudent(Map<String, Map<String, int>> journal, List<String> subjects, String name) {
  print('\n2. Поиск студента: $name');
  if (!journal.containsKey(name)) {
    print('Студент не найден');
    return;
  }

  var grades = journal[name]!;
  double sum = 0;
  int count = 0;

  for (var sub in subjects) {
    int? grade = grades[sub];
    if (grade != null) {
      print('$sub: $grade');
      sum += grade;
      count++;
    }
  }

  double avg = count > 0 ? sum / count : 0;
  print('Средний балл: ${avg.toStringAsFixed(2)}');

  if (avg >= 4.5) {
    print('Категория: отличник');
  } else if (avg >= 3.5) {
    print('Категория: хорошист');
  } else {
    print('Категория: остальные');
  }
}

void printUniqueGrades(Map<String, Map<String, int>> journal) {
  print('\n3. Уникальные оценки');
  Set<int> unique = {};
  for (var student in journal.values) {
    for (var grade in student.values) {
      unique.add(grade);
    }
  }
  var sorted = unique.toList()..sort();
  print(sorted);
}

void printMaxMinBySubject(Map<String, Map<String, int>> journal, List<String> subjects) {
  print('\n4. Макс/мин по предметам');
  for (var sub in subjects) {
    int? maxGrade, minGrade;
    List<String> maxStudents = [], minStudents = [];

    for (var student in journal.keys) {
      int? grade = journal[student]?[sub];
      if (grade != null) {
        if (maxGrade == null || grade > maxGrade) {
          maxGrade = grade;
          maxStudents = [student];
        } else if (grade == maxGrade) {
          maxStudents.add(student);
        }
        if (minGrade == null || grade < minGrade) {
          minGrade = grade;
          minStudents = [student];
        } else if (grade == minGrade) {
          minStudents.add(student);
        }
      }
    }

    if (maxGrade != null) {
      print('$sub: макс=$maxGrade (${maxStudents.join(', ')}), мин=$minGrade (${minStudents.join(', ')})');
    }
  }
}

void printStudentsWithOneTwo(Map<String, Map<String, int>> journal, List<String> subjects) {
  print('\n5. Студенты с одной двойкой');
  for (var student in journal.keys) {
    var twos = subjects.where((sub) => journal[student]?[sub] == 2).toList();
    if (twos.length == 1) {
      print('$student: двойка по предмету ${twos.first}');
    }
  }
}

void printSubjectsAboveAverage(Map<String, Map<String, int>> journal, List<String> subjects) {
  print('\n6. Предметы выше общего среднего');
  var allGrades = journal.values.expand((s) => s.values).toList();
  double overallAvg = allGrades.isNotEmpty
      ? allGrades.fold(0.0, (sum, g) => sum + g) / allGrades.length
      : 0;

  print('Общий средний: ${overallAvg.toStringAsFixed(2)}');

  for (var sub in subjects) {
    var grades = journal.values
        .map((s) => s[sub])
        .where((g) => g != null)
        .cast<int>()
        .toList();

    if (grades.isNotEmpty) {
      double avg = grades.reduce((a, b) => a + b) / grades.length;
      if (avg > overallAvg) {
        print('$sub: ${avg.toStringAsFixed(2)}');
      }
    }
  }
}

void printCategoriesCount(Map<String, Map<String, int>> journal, List<String> subjects) {
  print('\n7. Количество студентов по категориям');
  int excellent = 0, good = 0, other = 0;

  for (var student in journal.keys) {
    var grades = journal[student]!.values.toList();
    if (grades.isEmpty) continue;

    double avg = grades.reduce((a, b) => a + b) / grades.length;

    if (avg >= 4.5) {
      excellent++;
    } else if (avg >= 3.5) {
      good++;
    } else {
      other++;
    }
  }

  print('Отличники: $excellent');
  print('Хорошисты: $good');
  print('Остальные: $other');
}