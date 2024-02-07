class GradeModel {
  String key, en, fr;
  String? abbrev;
  int level;

  GradeModel({required this.key, required this.en, required this.fr, this.abbrev, required this.level});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['level'] = level;
    return data;
  }
}