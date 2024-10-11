class ResumeData {
  String name;
  String email;
  String phone;
  String github;
  String summary;
  List<String> skills;
  List<Project> projects;
  List<PoR> positionsOfResponsibility;
  List<Extracurricular> extracurriculars;

  ResumeData({
    required this.name,
    required this.email,
    required this.phone,
    required this.github,
    required this.summary,
    required this.skills,
    required this.projects,
    required this.positionsOfResponsibility,
    required this.extracurriculars,
    required List experiences,
    required List education,
  });
}

class Project {
  String? title;
  String? githubLink;
  String? description;
  List<String> bullets;

  Project(
      {this.title, this.githubLink, this.description, required this.bullets});
}

class PoR {
  String? title;

  PoR({this.title});
}

class Extracurricular {
  String? title;

  Extracurricular({this.title});
}

