import 'package:flutter/material.dart';

// ─── Question data class ──────────────────────────────────────────────────────
class ExamQuestion {
  final TextEditingController questionCtrl = TextEditingController();
  final List<TextEditingController> optionCtrls = [
    TextEditingController(),
    TextEditingController(),
  ];
  String correctAnswer = 'A';

  String labelFor(int index) => String.fromCharCode('A'.codeUnitAt(0) + index);

  List<String> get optionLabels =>
      List.generate(optionCtrls.length, labelFor);

  void dispose() {
    questionCtrl.dispose();
    for (final c in optionCtrls) {
      c.dispose();
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────
class ExamLocalProvider extends ChangeNotifier {
  // -- Exam details --
  // Duration: selected from predefined minute options
  int? selectedDuration; // in minutes, null = not chosen
  static const List<int> durationOptions = [
    5, 10, 15, 20, 30, 45, 60, 90, 120
  ];

  // Marks: text editing controllers for entering numbers
  final TextEditingController totalMarkCtrl = TextEditingController();
  final TextEditingController passMarkCtrl = TextEditingController();

  // -- Terms --
  final List<TextEditingController> termCtrls = [TextEditingController()];

  // -- Questions --
  final List<ExamQuestion> questions = [ExamQuestion()];

  // -- Retry --
  bool hasRetry = true;
  String? retryDuration;
  static const retryOptions = ['1 Day', '3 Days', '1 Week', '1 Month'];

  // ── Exam detail setters ────────────────────────────────────────────────────
  void setDuration(int? value) {
    selectedDuration = value;
    notifyListeners();
  }

  // ── Terms ──────────────────────────────────────────────────────────────────
  void addTerm() {
    termCtrls.add(TextEditingController());
    notifyListeners();
  }

  void removeTerm(int index) {
    if (termCtrls.length <= 1) return;
    termCtrls[index].dispose();
    termCtrls.removeAt(index);
    notifyListeners();
  }

  // ── Questions ──────────────────────────────────────────────────────────────
  void addQuestion() {
    questions.add(ExamQuestion());
    notifyListeners();
  }

  void removeQuestion(int index) {
    if (questions.length <= 1) return;
    questions[index].dispose();
    questions.removeAt(index);
    notifyListeners();
  }

  // ── Options ────────────────────────────────────────────────────────────────
  void addOption(int questionIndex) {
    if (questions[questionIndex].optionCtrls.length >= 6) return;
    questions[questionIndex].optionCtrls.add(TextEditingController());
    notifyListeners();
  }

  void removeOption(int questionIndex, int optionIndex) {
    final q = questions[questionIndex];
    if (q.optionCtrls.length <= 2) return;
    q.optionCtrls[optionIndex].dispose();
    q.optionCtrls.removeAt(optionIndex);
    if (!q.optionLabels.contains(q.correctAnswer)) {
      q.correctAnswer = 'A';
    }
    notifyListeners();
  }

  void setCorrectAnswer(int questionIndex, String label) {
    questions[questionIndex].correctAnswer = label;
    notifyListeners();
  }

  // ── Retry ──────────────────────────────────────────────────────────────────
  void setHasRetry(bool value) {
    hasRetry = value;
    if (!hasRetry) retryDuration = null;
    notifyListeners();
  }

  void setRetryDuration(String? value) {
    retryDuration = value;
    notifyListeners();
  }

  // ── Dispose ────────────────────────────────────────────────────────────────
  @override
  void dispose() {
    totalMarkCtrl.dispose();
    passMarkCtrl.dispose();
    for (final c in termCtrls) {
      c.dispose();
    }
    for (final q in questions) {
      q.dispose();
    }
    super.dispose();
  }

  void clearFields() {
    selectedDuration = null;
    totalMarkCtrl.clear();
    passMarkCtrl.clear();

    for (final c in termCtrls) {
      c.dispose();
    }
    termCtrls
      ..clear()
      ..add(TextEditingController());

    for (final q in questions) {
      q.dispose();
    }
    questions
      ..clear()
      ..add(ExamQuestion());

    hasRetry = true;
    retryDuration = null;

    notifyListeners();
  }
}
