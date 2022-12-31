class Homework {
  late int? id;
  late String title;
  late String subject;
  late String description;
  late String deadline;

  Homework({
    this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.deadline,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'description': description,
      'deadline': deadline,
    };
  }

  Homework.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    subject = map['subject'];
    description = map['description'];
    deadline = map['deadline'];
  }
}
