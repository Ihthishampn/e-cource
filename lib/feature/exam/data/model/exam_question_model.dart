class ExamQuestionModel {
  final String question;
  final List<String> options;
  final String correctAnswer;

  const ExamQuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory ExamQuestionModel.fromMap(Map<String, dynamic> map) {
    return ExamQuestionModel(
      question: map['question'] as String? ?? '',
      options: List<String>.from(map['options'] as List? ?? []),
      correctAnswer: map['correctAnswer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}
