
//HIVE CONSTANTS
import '../models/grade_model.dart';

const String userBoxLabel = "USER";
const String authBoxLabel = "AUTH";
const String themeBoxLabel = "THEME";
const String languageBoxLabel = "LANGUAGE";
const String isFistInstallKey = "isFirstInstall";
const String isDarkKey = 'isDark';


//RegExp
RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");


//Other constants
const String orphanageCollection = "ORPHANAGES";

const String ongoing = "ONGOING";
const String intended = "INTENDED";
const String completed = "COMPLETED";

//Grades
final gradesList = [
  GradeModel(key: "NONE", en: "Non literate", fr: "Non litteré", abbrev: "None", level: 0),
  GradeModel(key: "NOT_YET", en: "Pre-School", fr: "Pré-école", abbrev: "Pre", level: 0),
  GradeModel(key: "NURSERY", en: "Nursery", fr: "Maternelle", abbrev: "Pre", level: 1),
  GradeModel(key: "GRADE_1", en: "Class 1", fr: "SIL", level: 1),
  GradeModel(key: "GRADE_2", en: "Class 2", fr: "CP", level: 1),
  GradeModel(key: "GRADE_3", en: "Class 3", fr: "CE1", level: 1),
  GradeModel(key: "GRADE_4", en: "Class 4", fr: "CE2", level: 1),
  GradeModel(key: "GRADE_5", en: "Class 5", fr: "CM1", level: 1),
  GradeModel(key: "GRADE_6", en: "Class 6", fr: "CM2", level: 1),
  GradeModel(key: "GRADE_7", en: "Form 1", fr: "6ème", level: 2),
  GradeModel(key: "GRADE_8", en: "Form 2", fr: "5ème", level: 2),
  GradeModel(key: "GRADE_9", en: "Form 3", fr: "4ème", level: 2),
  GradeModel(key: "GRADE_10", en: "Form 4", fr: "3ème", level: 2),
  GradeModel(key: "GRADE_11", en: "Form 5", fr: "2nde", level: 2),
  GradeModel(key: "GRADE_12", en: "O Level", fr: "1ère", level: 2),
  GradeModel(key: "GRADE_13", en: "A level", fr: "Tle", level: 2),
  GradeModel(key: "UNIVERSITY", en: "University", fr: "Université", abbrev: "Univ", level: 3),
];