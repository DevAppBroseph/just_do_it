class About {
  List<Question> question;
  String about;
  String aboutEng;
  String confidence;
  String confidenceEng;
  String agreement;
  String agreementEng;

  About({
    required this.question,
    required this.about,
    required this.aboutEng,
    required this.confidence,
    required this.confidenceEng,
    required this.agreement,
    required this.agreementEng,
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
      aboutEng: json["about_eng"], confidenceEng: json["confidence_eng"], agreementEng: json["agreement_eng"],
    );
  }
}

class Question {
  int id;
  String question;
  String questionEng;
  String answer;
  String answerEng;

  Question({
    required this.id,
    required this.question,
    required this.questionEng,
    required this.answer,
    required this.answerEng,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        questionEng: json["question_eng"],
        answerEng: json["answer_eng"],
      );
}
