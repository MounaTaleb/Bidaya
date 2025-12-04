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
    question: 'ما هو العضو الذي يضخ الدم في الجسم؟',
    reponseCorrecte: 'القلب',
    options: ['القلب', 'الرئتين', 'المعدة'],
    explication: 'القلب هو المضخة التي تضخ الدم إلى جميع أجزاء الجسم.',
  ),
  QuestionScience(
    question: 'كم عدد العظام في جسم الإنسان البالغ؟',
    reponseCorrecte: '206',
    options: ['206', '200', '210'],
    explication: 'يحتوي جسم الإنسان البالغ على 206 عظمة.',
  ),
  QuestionScience(
    question: 'ما هو العضو المسؤول عن التنفس؟',
    reponseCorrecte: 'الرئتان',
    options: ['الرئتان', 'القلب', 'الكبد'],
    explication: 'الرئتان تقومان بأخذ الأكسجين وإطلاق ثاني أكسيد الكربون.',
  ),
  QuestionScience(
    question: 'ما هو أكبر عضو في جسم الإنسان؟',
    reponseCorrecte: 'الجلد',
    options: ['الجلد', 'الكبد', 'القلب'],
    explication: 'الجلد هو أكبر عضو ويغطي كامل الجسم.',
  ),
  QuestionScience(
    question: 'أي عضو يتحكم بحاسة الشم؟',
    reponseCorrecte: 'الأنف',
    options: ['الأنف', 'اللسان', 'الأذن'],
    explication: 'الأنف يحتوي على خلايا متخصصة تكتشف الروائح.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم مسؤول عن التوازن؟',
    reponseCorrecte: 'الأذن الداخلية',
    options: ['الأذن الداخلية', 'العين', 'اليد'],
    explication: 'الأذن الداخلية تحتوي على أعضاء مسؤولة عن التوازن.',
  ),
  QuestionScience(
    question: 'كم عدد الأسنان اللبنية عند الأطفال؟',
    reponseCorrecte: '20',
    options: ['20', '18', '22'],
    explication: 'يحتوي فم الطفل على 20 سناً لبنيًا تظهر ثم تستبدل بالأسنان الدائمة.',
  ),
  QuestionScience(
    question: 'أي عضو ينتج الأنسولين؟',
    reponseCorrecte: 'البنكرياس',
    options: ['البنكرياس', 'الكبد', 'المعدة'],
    explication: 'البنكرياس ينظم مستوى السكر في الدم عن طريق إنتاج الأنسولين.',
  ),
  QuestionScience(
    question: 'أي عضو مسؤول عن هضم الطعام؟',
    reponseCorrecte: 'المعدة',
    options: ['المعدة', 'الكبد', 'القلب'],
    explication: 'المعدة تبدأ عملية هضم الطعام بواسطة الأحماض والإنزيمات.',
  ),
  QuestionScience(
    question: 'أي جزء من العين يتحكم بكمية الضوء الداخل؟',
    reponseCorrecte: 'القزحية',
    options: ['القزحية', 'العدسة', 'الشبكية'],
    explication: 'القزحية تتحكم بحجم الحدقة ومن ثم كمية الضوء الداخلة للعين.',
  ),
  QuestionScience(
    question: 'أي جزء في الجسم يحمي الأعضاء الداخلية؟',
    reponseCorrecte: 'الهيكل العظمي',
    options: ['الهيكل العظمي', 'العضلات', 'الجلد'],
    explication: 'الهيكل العظمي يوفر حماية للأعضاء الحيوية كالقلب والرئتين.',
  ),
  QuestionScience(
    question: 'أي جزء من الدم ينقل الأكسجين؟',
    reponseCorrecte: 'كريات الدم الحمراء',
    options: ['كريات الدم الحمراء', 'الصفائح الدموية', 'البلازما'],
    explication: 'كريات الدم الحمراء تحتوي على الهيموغلوبين الذي ينقل الأكسجين.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يتحكم بحركة العضلات؟',
    reponseCorrecte: 'الدماغ',
    options: ['الدماغ', 'القلب', 'الكبد'],
    explication: 'الدماغ يرسل إشارات عصبية تتحكم بحركة العضلات.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على التوازن أثناء المشي؟',
    reponseCorrecte: 'الأذن الداخلية',
    options: ['الأذن الداخلية', 'القدم', 'الركبة'],
    explication: 'الأذن الداخلية تحتوي على أعضاء تساعد على حفظ التوازن.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على الرؤية؟',
    reponseCorrecte: 'العين',
    options: ['العين', 'الأذن', 'الأنف'],
    explication: 'العين هي العضو المسؤول عن حاسة البصر.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يخزن الطاقة؟',
    reponseCorrecte: 'الدهون',
    options: ['الدهون', 'العضلات', 'العظام'],
    explication: 'الدهون تخزن الطاقة الزائدة للجسم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يقاوم الأمراض؟',
    reponseCorrecte: 'الجهاز المناعي',
    options: ['الجهاز المناعي', 'القلب', 'الكبد'],
    explication: 'الجهاز المناعي يحمي الجسم من الأمراض والجراثيم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم ينقل الإشارات الكهربائية؟',
    reponseCorrecte: 'الأعصاب',
    options: ['الأعصاب', 'العضلات', 'الدم'],
    explication: 'الأعصاب تنقل الإشارات الكهربائية من الدماغ إلى باقي الجسم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يفرز العرق لتبريد الجسم؟',
    reponseCorrecte: 'الغدد العرقية',
    options: ['الغدد العرقية', 'الكبد', 'الكلى'],
    explication: 'الغدد العرقية تفرز العرق لتبريد الجسم عند ارتفاع الحرارة.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على الحركة؟',
    reponseCorrecte: 'العضلات',
    options: ['العضلات', 'العظام', 'الأعصاب'],
    explication: 'العضلات تتقلص لتسمح بحركة الجسم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم ينقل الغذاء من الفم للمعدة؟',
    reponseCorrecte: 'المريء',
    options: ['المريء', 'الأمعاء', 'اللسان'],
    explication: 'المريء ينقل الطعام من الفم إلى المعدة عن طريق حركات انقباض وانبساط.',
  ),
  // أسئلة 21-60
  QuestionScience(
    question: 'أي جزء من الجسم يمتص الطعام المهضوم؟',
    reponseCorrecte: 'الأمعاء الدقيقة',
    options: ['الأمعاء الدقيقة', 'المعدة', 'الكبد'],
    explication: 'الأمعاء الدقيقة تمتص المواد الغذائية من الطعام المهضوم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يزيل الفضلات السائلة؟',
    reponseCorrecte: 'الكلى',
    options: ['الكلى', 'الكبد', 'الأمعاء'],
    explication: 'الكلى تنقي الدم وتخرج الفضلات على شكل بول.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يرسل الدم إلى كل أنحاء الجسم؟',
    reponseCorrecte: 'القلب',
    options: ['القلب', 'الكبد', 'الرئتين'],
    explication: 'القلب يضخ الدم المحمل بالأكسجين إلى كامل الجسم.',
  ),
  QuestionScience(
    question: 'أي جزء من الدم يساعد على تجلط الدم؟',
    reponseCorrecte: 'الصفائح الدموية',
    options: ['الصفائح الدموية', 'كريات الدم البيضاء', 'البلازما'],
    explication: 'الصفائح الدموية تساعد على إيقاف النزيف وتجلط الدم.',
  ),
  QuestionScience(
    question: 'أي عضو يخزن العصارة الصفراوية؟',
    reponseCorrecte: 'المرارة',
    options: ['المرارة', 'الكبد', 'المعدة'],
    explication: 'المرارة تخزن العصارة الصفراوية التي تساعد على هضم الدهون.',
  ),
  QuestionScience(
    question: 'أي جزء من العين يركز الضوء على الشبكية؟',
    reponseCorrecte: 'العدسة',
    options: ['العدسة', 'القزحية', 'البؤبؤ'],
    explication: 'العدسة تقوم بتركيز الضوء على الشبكية لتمكين الرؤية الواضحة.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم ينتج خلايا الدم؟',
    reponseCorrecte: 'النخاع العظمي',
    options: ['النخاع العظمي', 'الكبد', 'القلب'],
    explication: 'النخاع العظمي ينتج كريات الدم الحمراء والبيضاء والصفائح الدموية.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يضبط حرارة الجسم؟',
    reponseCorrecte: 'الجلد',
    options: ['الجلد', 'الكبد', 'الكلى'],
    explication: 'الجلد يفرز العرق للمساعدة على تبريد الجسم عند ارتفاع الحرارة.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يحمي الدماغ؟',
    reponseCorrecte: 'الجمجمة',
    options: ['الجمجمة', 'الرقبة', 'العمود الفقري'],
    explication: 'الجمجمة تحمي الدماغ من الصدمات والإصابات.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم ينظم مستوى السكر في الدم؟',
    reponseCorrecte: 'البنكرياس',
    options: ['البنكرياس', 'الكبد', 'الكلى'],
    explication: 'البنكرياس يفرز الأنسولين لتنظيم مستوى السكر في الدم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على الحركة والقوة؟',
    reponseCorrecte: 'العضلات',
    options: ['العضلات', 'العظام', 'الأعصاب'],
    explication: 'العضلات تتقلص وتستجيب للأوامر العصبية للحركة.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على الشم؟',
    reponseCorrecte: 'الأنف',
    options: ['الأنف', 'اللسان', 'العين'],
    explication: 'الأنف يحتوي على خلايا شمية للكشف عن الروائح.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على التذوق؟',
    reponseCorrecte: 'اللسان',
    options: ['اللسان', 'الأنف', 'الفم'],
    explication: 'اللسان يحتوي على براعم تذوق تمكننا من تمييز النكهات.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يحافظ على التوازن أثناء الجري؟',
    reponseCorrecte: 'الأذن الداخلية',
    options: ['الأذن الداخلية', 'القدم', 'الركبة'],
    explication: 'الأذن الداخلية تساعد على حفظ التوازن أثناء الحركة.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم ينقل إشارات الدماغ؟',
    reponseCorrecte: 'الأعصاب',
    options: ['الأعصاب', 'العضلات', 'الدم'],
    explication: 'الأعصاب تنقل الرسائل الكهربائية بين الدماغ وباقي الجسم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يقوم بهضم الدهون؟',
    reponseCorrecte: 'الكبد',
    options: ['الكبد', 'المعدة', 'المرارة'],
    explication: 'الكبد ينتج العصارة الصفراوية اللازمة لهضم الدهون.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يشارك في التنفس؟',
    reponseCorrecte: 'الرئتين',
    options: ['الرئتين', 'القلب', 'المعدة'],
    explication: 'الرئتان تستقبلان الأكسجين وتطلقان ثاني أكسيد الكربون.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على الاستجابة للحرارة والبرودة؟',
    reponseCorrecte: 'الجلد',
    options: ['الجلد', 'الأعصاب', 'العضلات'],
    explication: 'الجلد يحتوي على مستقبلات تحس بالحرارة والبرودة.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم ينقل الغذاء من المعدة للأمعاء؟',
    reponseCorrecte: 'الأمعاء الدقيقة',
    options: ['الأمعاء الدقيقة', 'الأمعاء الغليظة', 'المعدة'],
    explication: 'الأمعاء الدقيقة تستمر في هضم الطعام وامتصاص العناصر الغذائية.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يفرز الإنزيمات لهضم الطعام؟',
    reponseCorrecte: 'المعدة',
    options: ['المعدة', 'الكبد', 'اللسان'],
    explication: 'المعدة تفرز الأحماض والإنزيمات لهضم الطعام.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يحمي الجسم من الأمراض؟',
    reponseCorrecte: 'الجهاز المناعي',
    options: ['الجهاز المناعي', 'الكبد', 'القلب'],
    explication: 'الجهاز المناعي يهاجم الجراثيم والفيروسات لحماية الجسم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على التوازن؟',
    reponseCorrecte: 'الأذن الداخلية',
    options: ['الأذن الداخلية', 'القدم', 'الركبة'],
    explication: 'الأذن الداخلية تحتوي على أعضاء التوازن للحفاظ على الجسم مستقيمًا.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يحمي القلب؟',
    reponseCorrecte: 'القفص الصدري',
    options: ['القفص الصدري', 'الجمجمة', 'العمود الفقري'],
    explication: 'القفص الصدري يحمي القلب والرئتين من الصدمات.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يفرز اللعاب؟',
    reponseCorrecte: 'الغدد اللعابية',
    options: ['الغدد اللعابية', 'المعدة', 'الكبد'],
    explication: 'الغدد اللعابية تساعد على تليين الطعام وبدء الهضم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يمتص الماء من الطعام؟',
    reponseCorrecte: 'الأمعاء الغليظة',
    options: ['الأمعاء الغليظة', 'الأمعاء الدقيقة', 'المعدة'],
    explication: 'الأمعاء الغليظة تمتص الماء والمعادن قبل إخراج الفضلات.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يحمي الدماغ من الصدمات؟',
    reponseCorrecte: 'الجمجمة',
    options: ['الجمجمة', 'الرقبة', 'العمود الفقري'],
    explication: 'الجمجمة تغلف الدماغ وتحميه من الإصابات.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يتحكم في الحركة؟',
    reponseCorrecte: 'الدماغ',
    options: ['الدماغ', 'القلب', 'الكبد'],
    explication: 'الدماغ يرسل إشارات للأعصاب لتنسيق الحركة.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يخزن الدم؟',
    reponseCorrecte: 'الطحال',
    options: ['الطحال', 'الكبد', 'القلب'],
    explication: 'الطحال يخزن الدم ويزيل الخلايا التالفة من الجسم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يحتوي على المستقبلات العصبية للمس؟',
    reponseCorrecte: 'الجلد',
    options: ['الجلد', 'العضلات', 'العظام'],
    explication: 'الجلد يحتوي على نهايات عصبية تستشعر اللمس والحرارة والضغط.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على تحريك العين؟',
    reponseCorrecte: 'عضلات العين',
    options: ['عضلات العين', 'الدماغ', 'القزحية'],
    explication: 'عضلات العين تتحكم بحركة العين للأعلى والأسفل والجوانب.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على البلع؟',
    reponseCorrecte: 'اللسان',
    options: ['اللسان', 'المعدة', 'الأمعاء'],
    explication: 'اللسان يساعد على دفع الطعام نحو البلعوم والمريء.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على الشم والتذوق معاً؟',
    reponseCorrecte: 'الأنف واللسان',
    options: ['الأنف واللسان', 'العين واليد', 'الأذن واللسان'],
    explication: 'الأنف يكتشف الروائح واللسان يتذوق النكهات.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على ضخ الدم إلى الرئتين؟',
    reponseCorrecte: 'البطين الأيمن',
    options: ['البطين الأيمن', 'البطين الأيسر', 'الأذين الأيمن'],
    explication: 'البطين الأيمن يضخ الدم غير المؤكسج إلى الرئتين للتنقية.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يحتوي على خلايا الدم البيضاء؟',
    reponseCorrecte: 'الدم',
    options: ['الدم', 'البلازما', 'الصفائح الدموية'],
    explication: 'خلايا الدم البيضاء تحمي الجسم من العدوى والجراثيم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يفرز الأحماض لهضم الطعام؟',
    reponseCorrecte: 'المعدة',
    options: ['المعدة', 'الكبد', 'الأمعاء'],
    explication: 'المعدة تفرز الأحماض والإنزيمات لبدء عملية الهضم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على حاسة السمع؟',
    reponseCorrecte: 'الأذن',
    options: ['الأذن', 'العين', 'الأنف'],
    explication: 'الأذن تحتوي على أعضاء حيوية تساعد على السمع.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يحول الطعام المهضوم إلى طاقة؟',
    reponseCorrecte: 'الخلايا',
    options: ['الخلايا', 'المعدة', 'الأمعاء'],
    explication: 'الخلايا تحول المواد الغذائية إلى طاقة يمكن للجسم استخدامها.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم ينقل المواد الغذائية إلى الدم؟',
    reponseCorrecte: 'الأمعاء الدقيقة',
    options: ['الأمعاء الدقيقة', 'الأمعاء الغليظة', 'المعدة'],
    explication: 'الأمعاء الدقيقة تمتص المواد الغذائية وتدخلها مجرى الدم.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على الحفاظ على وضعية الجسم؟',
    reponseCorrecte: 'العمود الفقري',
    options: ['العمود الفقري', 'الرقبة', 'الركبة'],
    explication: 'العمود الفقري يدعم الجسم ويساعد على الوقوف والحركة.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يساعد على تحريك اليدين؟',
    reponseCorrecte: 'العضلات',
    options: ['العضلات', 'الأعصاب', 'العظام'],
    explication: 'العضلات تتحرك بتلقي إشارات من الأعصاب لتحريك اليدين.',
  ),
  QuestionScience(
    question: 'أي جزء من الجسم يخزن الطاقة على المدى الطويل؟',
    reponseCorrecte: 'الدهون',
    options: ['الدهون', 'العظام', 'العضلات'],
    explication: 'الدهون تخزن الطاقة لتستعمل لاحقاً عند الحاجة.',
  ),


];
