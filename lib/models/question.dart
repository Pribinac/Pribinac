/// Jedno pitanje sa četiri ponuđena odgovora.
class Question {
  const Question({
    required this.id,
    required this.category,
    required this.text,
    required this.answers,
    required this.correctIndex,
  });

  final int id;
  final String category;
  final String text;
  final List<String> answers;
  final int correctIndex;

  bool isCorrect(int? index) => index == correctIndex;
}
