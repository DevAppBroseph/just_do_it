class About {
  List<Question> question;
  String about;
  String confidence;
  String agreement;

  About({
    required this.question,
    required this.about,
    required this.confidence,
    required this.agreement,
  });

  factory About.fromJson(Map<String, dynamic> json) {
    List<Question> question = [];
    for (var element in json['questions']) {
      question.add(Question.fromJson(element));
    }
    return About(
      question: question,
      about: json["about"],
      confidence: json["confidence"],
      agreement: json["agreement"],
    );
  }
}

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
