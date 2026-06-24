
class QuizModel {
  final String question;
  final List<String> options;
  final String answer;

  QuizModel({required this.question, required this.options, required this.answer});

  // This logic automatically reads the quiz JSON data
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      answer: json['answer'] ?? '',
    );
  }
}

// This is the exact data Peblo asked us to use!
const String jsonPayload = '''
{
  "question": "What colour was Pip the Robot's lost gear?",
  "options": ["Red", "Green", "Blue", "Yellow"],
  "answer": "Blue"
}
''';
