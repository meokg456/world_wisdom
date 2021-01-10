class Exercise {
  Exercise({
    this.id,
    this.title,
    this.numberQuestion,
    this.usersDoExercises,
    this.exercisesQuestions,
  });

  String id;
  String title;
  int numberQuestion;
  List<dynamic> usersDoExercises;
  List<ExercisesQuestion> exercisesQuestions;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["id"],
        title: json["title"],
        numberQuestion: json["numberQuestion"],
        usersDoExercises:
            List<dynamic>.from(json["users_do_exercises"].map((x) => x)),
        exercisesQuestions: List<ExercisesQuestion>.from(
            json["exercises_questions"]
                .map((x) => ExercisesQuestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "numberQuestion": numberQuestion,
        "users_do_exercises":
            List<dynamic>.from(usersDoExercises.map((x) => x)),
        "exercises_questions":
            List<dynamic>.from(exercisesQuestions.map((x) => x.toJson())),
      };
}

class ExercisesQuestion {
  ExercisesQuestion({
    this.id,
  });

  String id;

  factory ExercisesQuestion.fromJson(Map<String, dynamic> json) =>
      ExercisesQuestion(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
