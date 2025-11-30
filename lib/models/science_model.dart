// models/science_model.dart
class QuestionScience {
  final String question;
  final String reponseCorrecte;
  final List<String> options;
  final String explication;

  QuestionScience({
    required this.question,
    required this.reponseCorrecte,
    required this.options,
    required this.explication,
  });
}

List<QuestionScience> questionsScience = [
  // Niveau 1 (Basique)
  QuestionScience(
    question: 'ما هو العضو المسؤول عن ضخ الدم في الجسم؟',
    reponseCorrecte: 'القلب',
    options: ['القلب', 'الرئتين', 'المعدة', 'الدماغ'],
    explication: 'القلب هو المضخة التي تضخ الدم إلى جميع أجزاء الجسم.',
  ),
  QuestionScience(
    question: 'كم عدد العظام في جسم الإنسان البالغ؟',
    reponseCorrecte: '206',
    options: ['200', '206', '210', '215'],
    explication: 'يحتوي جسم الإنسان البالغ على 206 عظمة.',
  ),
  QuestionScience(
    question: 'ما هو أكبر عضو في جسم الإنسان؟',
    reponseCorrecte: 'الجلد',
    options: ['الجلد', 'الكبد', 'القلب', 'الرئتين'],
    explication: 'الجلد هو أكبر عضو في جسم الإنسان ويغطي كامل الجسم.',
  ),
  QuestionScience(
    question: 'ما هو العضو المسؤول عن التنفس؟',
    reponseCorrecte: 'الرئتين',
    options: ['الرئتين', 'القلب', 'الكبد', 'المعدة'],
    explication: 'الرئتان تقومان بأخذ الأكسجين وإطلاق ثاني أكسيد الكربون.',
  ),
  QuestionScience(
    question: 'ما هو لون الدم في شراييننا؟',
    reponseCorrecte: 'أحمر',
    options: ['أحمر', 'أزرق', 'أخضر', 'شفاف'],
    explication: 'الدم أحمر اللون بسبب وجود الهيموغلوبين الذي يحمل الأكسجين.',
  ),

  // Niveau 2 (Intermediaire)
  QuestionScience(
    question: 'ما هو العضو المسؤول عن تنظيف الدم؟',
    reponseCorrecte: 'الكلى',
    options: ['الكلى', 'الكبد', 'القلب', 'الرئتين'],
    explication: 'الكلى تقوم بتنقية الدم من الفضلات والسموم.',
  ),
  QuestionScience(
    question: 'كم عدد غرف القلب في الإنسان؟',
    reponseCorrecte: '4',
    options: ['2', '3', '4', '5'],
    explication: 'يحتوي القلب على 4 غرف: أذينين وبطينين.',
  ),
  QuestionScience(
    question: 'ما هو العضو المسؤول عن الهضم؟',
    reponseCorrecte: 'المعدة',
    options: ['المعدة', 'الكبد', 'القلب', 'الرئتين'],
    explication: 'المعدة تبدأ عملية هضم الطعام بواسطة الأحماض والإنزيمات.',
  ),
  QuestionScience(
    question: 'ما هو العضو المسؤول عن التوازن في الجسم؟',
    reponseCorrecte: 'الأذن الداخلية',
    options: ['الأذن الداخلية', 'العين', 'الأنف', 'اللسان'],
    explication: 'الأذن الداخلية تحتوي على أعضاء مسئولة عن التوازن.',
  ),
  QuestionScience(
    question: 'ما هو عدد الأسنان اللبنية عند الأطفال؟',
    reponseCorrecte: '20',
    options: ['18', '20', '22', '24'],
    explication: 'يحتوي فم الطفل على 20 سناً لبنيًا تظهر ثم تستبدل بالأسنان الدائمة.',
  ),

  // Niveau 3 (Avancé)
  QuestionScience(
    question: 'ما هو العضو الذي ينتج الأنسولين؟',
    reponseCorrecte: 'البنكرياس',
    options: ['البنكرياس', 'الكبد', 'المعدة', 'القلب'],
    explication: 'البنكرياس ينتج الأنسولين الذي ينظم مستوى السكر في الدم.',
  ),
  QuestionScience(
    question: 'ما هو أقوى عظم في جسم الإنسان؟',
    reponseCorrecte: 'عظم الفخذ',
    options: ['عظم الفخذ', 'عظم الجمجمة', 'عظم الذراع', 'عظم الساق'],
    explication: 'عظم الفخذ هو أقوى وأطول عظم في جسم الإنسان.',
  ),
  QuestionScience(
    question: 'ما هو العضو المسؤول عن حاسة الشم؟',
    reponseCorrecte: 'الأنف',
    options: ['الأنف', 'اللسان', 'العين', 'الأذن'],
    explication: 'الأنف يحتوي على خلايا شم متخصصة تكتشف الروائح.',
  ),
  QuestionScience(
    question: 'كم عدد العضلات في جسم الإنسان؟',
    reponseCorrecte: 'أكثر من 600',
    options: ['أكثر من 600', 'أكثر من 400', 'أكثر من 800', 'أكثر من 1000'],
    explication: 'يحتوي جسم الإنسان على أكثر من 600 عضلة.',
  ),
  QuestionScience(
    question: 'ما هو العضو الذي ينمو طوال حياة الإنسان؟',
    reponseCorrecte: 'الأنف والأذنان',
    options: ['الأنف والأذنان', 'اليدان', 'القدمان', 'العينان'],
    explication: 'الأنف والأذنان يستمران في النمو ببطء طوال حياة الإنسان.',
  ),
];