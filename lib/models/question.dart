class Question {
  int id;
  String question;
  String answer;

  Question({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
      );
}
