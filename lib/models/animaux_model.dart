// models/animaux_model.dart
class Animal {
  final String nom;
  final String petit;
  final String habitat;
  final String alimentation; // 'لاحم', 'عاشب', 'كُلِّي'
  final String faitInteressant;

  Animal({
    required this.nom,
    required this.petit,
    required this.habitat,
    required this.alimentation,
    required this.faitInteressant,
  });
}

List<Animal> animaux = [
  // Niveau 1 (Animaux domestiques / fermiers)
  Animal(
    nom: 'الكلب',
    petit: 'جرو',
    habitat: 'المنازل والمزارع',
    alimentation: 'كُلِّي',
    faitInteressant: 'يعتبر من أقدم الحيوانات المستأنسة ويملك حسّ شمي قوي.',
  ),
  Animal(
    nom: 'القط',
    petit: 'قُطَيّ',
    habitat: 'المنازل والمزارع',
    alimentation: 'لاحم',
    faitInteressant: 'يحبّ النظافة ويقضي ساعات في التلعثم لتنظيف نفسه.',
  ),
  Animal(
    nom: 'البقرة',
    petit: 'عجل',
    habitat: 'المزارع',
    alimentation: 'عاشب',
    faitInteressant: 'لها أربعة بطون تساعدها في هضم النباتات.',
  ),
  Animal(
    nom: 'الخروف',
    petit: 'حمل',
    habitat: 'المراعي والمزارع',
    alimentation: 'عاشب',
    faitInteressant: 'الصوف يحميه من البرد ويستخدمه البشر منذ آلاف السنين.',
  ),
  Animal(
    nom: 'الماعز',
    petit: 'جديّ',
    habitat: 'المراعي والمزارع',
    alimentation: 'عاشب',
    faitInteressant: 'قادر على التسلق في مناطق صعبة ويأكل مجموعة متنوعة من النباتات.',
  ),
  Animal(
    nom: 'الحصان',
    petit: 'مهر',
    habitat: 'المزارع والمراعي',
    alimentation: 'عاشب',
    faitInteressant: 'يمكنه النوم واقفاً وله ذاكرة جيدة للمسارات والوجوه.',
  ),
  Animal(
    nom: 'الدجاجة',
    petit: 'صوص',
    habitat: 'المزارع',
    alimentation: 'كُلِّي',
    faitInteressant: 'تضع بيضاً بانتظام ويمكن لبعض السلالات وضع مئات البيضات سنوياً.',
  ),
  Animal(
    nom: 'البطة',
    petit: 'زريعة',
    habitat: 'المستنقعات والمزارع',
    alimentation: 'كُلِّي',
    faitInteressant: 'ممتازة للسباحة وعاجزة على الطيران لمسافات طويلة في بعض السلالات.',
  ),
  Animal(
    nom: 'الحمامة',
    petit: 'صغير الحمامة',
    habitat: 'المدن والحقول',
    alimentation: 'كُلِّي',
    faitInteressant: 'استخدمها الناس قديماً كرسائل بسبب حبّها للعودة إلى عشه.',
  ),
  Animal(
    nom: 'النحلة',
    petit: 'يرقة',
    habitat: 'الحدائق والمواقع المزهرة',
    alimentation: 'عاشب',
    faitInteressant: 'تلعب دوراً أساسياً في تلقيح النباتات وتصنع العسل.',
  ),

  // Niveau 2 (Animaux sauvages)
  Animal(
    nom: 'الأسد',
    petit: 'شبل',
    habitat: 'السافانا والسهول',
    alimentation: 'لاحم',
    faitInteressant: 'يُسمّى ملك الغابة وعادة يعيش في مجموعات تسمى "زمرة".',
  ),
  Animal(
    nom: 'النمر',
    petit: 'شبل',
    habitat: 'الغابات والسهول',
    alimentation: 'لاحم',
    faitInteressant: 'يمتاز بخطوط على الفراء تساعده على التخفي أثناء الصيد.',
  ),
  Animal(
    nom: 'الفيل',
    petit: 'صغير الفيل',
    habitat: 'الغابات والسافانا',
    alimentation: 'عاشب',
    faitInteressant: 'أكبر الثدييات البرّية وله ذاكرة ممتازة وعلاقات إجتماعية قوية.',
  ),
  Animal(
    nom: 'الدب',
    petit: 'دُبّ',
    habitat: 'الغابات والجبال',
    alimentation: 'كُلِّي',
    faitInteressant: 'بعض الأنواع تدخل في سبات شتوي وتستغني عن الطعام لأسابيع.',
  ),
  Animal(
    nom: 'الذئب',
    petit: 'جرو',
    habitat: 'الغابات والسهول والجبال',
    alimentation: 'لاحم',
    faitInteressant: 'يعيش في مجموعات مترابطة ويعتمد على الصيد التعاوني.',
  ),
  Animal(
    nom: 'الغزال',
    petit: 'ظِمل' , // مصطلح عامي، يمكن أيضاً "صغير الغزال"
    habitat: 'السهول والغابات',
    alimentation: 'عاشب',
    faitInteressant: 'ماهر في القفز والهرب من المفترسات بسرعة.',
  ),
  Animal(
    nom: 'الزرافة',
    petit: 'جَوْل',
    habitat: 'السافانا',
    alimentation: 'عاشب',
    faitInteressant: 'أطول حيوان بري ويمتلك رقبة طويلة تصل للأوراق العالية.',
  ),
  Animal(
    nom: 'الجاموس',
    petit: 'عجل الجاموس',
    habitat: 'المستنقعات والمراعي',
    alimentation: 'عاشب',
    faitInteressant: 'قوي التحمل ويستخدمه الإنسان في الأعمال الزراعية في بعض البلدان.',
  ),
  Animal(
    nom: 'الراكون',
    petit: 'جُرَيّ',
    habitat: 'الغابات والمناطق الحضرية',
    alimentation: 'كُلِّي',
    faitInteressant: 'ذكيّ ويستخدم مخالبه بحرفية لفتح الأطعمة والحاويات.',
  ),
  Animal(
    nom: 'الكنغر',
    petit: 'مولود الكنغر (جوي)',
    habitat: 'السهول والغابات الأسترالية',
    alimentation: 'عاشب',
    faitInteressant: 'يحمل صغيره في جرابه حتى يصبح قادراً على المشي.',
  ),
  Animal(
    nom: 'التمساح',
    petit: 'صغير التمساح',
    habitat: 'المستنقعات والأنهار',
    alimentation: 'لاحم',
    faitInteressant: 'له فكّ قوي للغاية ويستطيع البقاء لفترات طويلة تحت الماء.',
  ),
  Animal(
    nom: 'الثعلب',
    petit: 'جرو',
    habitat: 'الغابات والسهول والمناطق القريبة من الإنسان',
    alimentation: 'كُلِّي',
    faitInteressant: 'ذكي وماهر في الاختباء والبحث عن الطعام ليلاً.',
  ),
  Animal(
    nom: 'الضبع',
    petit: 'جرو',
    habitat: 'السافانا والسهول',
    alimentation: 'كُلِّي',
    faitInteressant: 'قادر على تناول أجزاء عظمية بفضل جهاز هضمي قوي.',
  ),
  Animal(
    nom: 'السلوقي',
    petit: 'جرو',
    habitat: 'الصحارى والسهول',
    alimentation: 'لاحم',
    faitInteressant: 'سريع جداً ويستخدم للصيد والسباقات في بعض الثقافات.',
  ),
  Animal(
    nom: 'الوطواط',
    petit: 'جُرَيّ',
    habitat: 'الكهوف والمباني والحدائق',
    alimentation: 'لاحم',
    faitInteressant: 'يستخدم الصدى (اِيكولوكايشن) للتنقّل في الظلام.',
  ),
  Animal(
    nom: 'السمور (المِصْطَلِح على القندس صغير)',
    petit: 'جُرَيّ',
    habitat: 'الأنهار والغابات المائية',
    alimentation: 'عاشب',
    faitInteressant: 'يبني سدوداً ويغير بيئته لتناسب حياته.',
  ),
  Animal(
    nom: 'اليلق',
    petit: 'صغير',
    habitat: 'الجُزر والسهول الساحلية',
    alimentation: 'كُلِّي',
    faitInteressant: 'تختلف أنواع الليلق كثيراً من حيث الحجم والسلوك.',
  ),
  Animal(
    nom: 'الثعبان',
    petit: 'صغير الثعبان',
    habitat: 'الصحارى والغابات والمناطق الرطبة',
    alimentation: 'لاحم',
    faitInteressant: 'بعض الأنواع سامة وبعضها يلتف لقتل فريسته.',
  ),
  Animal(
    nom: 'اللاما',
    petit: 'صغير اللاما',
    habitat: 'الهضاب الجبلية في أمريكا الجنوبية',
    alimentation: 'عاشب',
    faitInteressant: 'يستخدم كحيوان حِمل في المناطق الجبلية وقدّم للإنسان منذ آلاف السنين.',
  ),

  // Niveau 3 (Animaux marins)
  Animal(
    nom: 'الدلفين',
    petit: 'صغير الدلفين',
    habitat: 'المحيطات والبحار',
    alimentation: 'لاحم',
    faitInteressant: 'ذكي للغاية ويتواصل مع أفراد جماعته بصوتيات معقّدة.',
  ),
  Animal(
    nom: 'الحوت',
    petit: 'صغير الحوت',
    habitat: 'المحيطات',
    alimentation: 'كُلِّي', // بعض الحيتان آكلة للعوالق، بعضها لاحمة
    faitInteressant: 'أكبر الثدييات في العالم؛ بعضها يقطع آلاف الكيلومترات في موسم الهجرة.',
  ),
  Animal(
    nom: 'القرش',
    petit: 'صغير القرش',
    habitat: 'المحيطات والبحار',
    alimentation: 'لاحم',
    faitInteressant: 'له حاسة شم قوية وحواس متقدمة تساعده في تتبّع الفريسة.',
  ),
  Animal(
    nom: 'السلحفاة البحرية',
    petit: 'صغير السلحفاة',
    habitat: 'المحيطات والسواحل',
    alimentation: 'كُلِّي',
    faitInteressant: 'تعود إلى الشاطئ ذاته الذي وُلدت عليه لوضع بيضها.',
  ),
  Animal(
    nom: 'نجمة البحر',
    petit: 'صغير نجمة البحر',
    habitat: 'قاع البحر',
    alimentation: 'لاحم/كُلِّي',
    faitInteressant: 'بعضها قادر على تجديد أطرافه المفقودة.',
  ),
  Animal(
    nom: 'أخطبوط',
    petit: 'صغير الأخطبوط',
    habitat: 'قاع البحر والشعاب',
    alimentation: 'لاحم',
    faitInteressant: 'ذكي جداً ويستعمل حيلة التمويه ولديه أذرع قوية مع مصاصات.',
  ),
  Animal(
    nom: 'حبار',
    petit: 'صغير الحبار',
    habitat: 'المحيطات',
    alimentation: 'لاحم',
    faitInteressant: 'يستطيع إطلاق حبر للدفاع عن نفسه ويغيّر لونه بسرعة.',
  ),
  Animal(
    nom: 'المرجان (كائن شُعابي)',
    petit: 'شُعاب صغيرة',
    habitat: 'الشعاب المرجانية',
    alimentation: 'مصغّي (يأخذ غذاءً دقيقاً من الماء)',
    faitInteressant: 'الشعاب المرجانية تبني بيئة بحرية غنية وتدعم تنوعاً حيوياً كبيراً.',
  ),
  Animal(
    nom: 'الروبيان',
    petit: 'صغير الروبيان',
    habitat: 'البحار والمستجمعات المائية',
    alimentation: 'كُلِّي',
    faitInteressant: 'جزء مهم من السلسلة الغذائية والاقتصاد البحري (صيد).',
  ),
  Animal(
    nom: 'الأسماك الذهبية',
    petit: 'زريعة',
    habitat: 'الأنهار والبرك والأحواض',
    alimentation: 'كُلِّي',
    faitInteressant: 'تعيش في الأحواض المنزلية وتتكاثر بسرعة في ظروف مناسبة.',
  ),

  // Oiseaux (طيور)
  Animal(
    nom: 'الصقر',
    petit: 'شاهين صغير',
    habitat: 'الجبال والسهول',
    alimentation: 'لاحم',
    faitInteressant: 'صائد ماهر ويستخدم في الصيد التقليدي في بعض البلدان.',
  ),
  Animal(
    nom: 'البوم',
    petit: 'صغير البومة',
    habitat: 'الغابات والجبال',
    alimentation: 'لاحم',
    faitInteressant: 'يصطاد ليلاً ويملك سمعاً وعيوناً متطورتين.',
  ),
  Animal(
    nom: 'النورس',
    petit: 'صغير النورس',
    habitat: 'السواحل والبحار',
    alimentation: 'كُلِّي',
    faitInteressant: 'ذكي ويتكيف مع المناطق الحضرية أحياناً للبحث عن الطعام.',
  ),
  Animal(
    nom: 'الطيور المهاجرة (عام)',
    petit: 'صغير الطائر',
    habitat: 'مسارات هجرة عبر القارات',
    alimentation: 'كُلِّي/عاشب',
    faitInteressant: 'تقطع مسافات هائلة بين مواطن التكاثر والمواطن الشتوية.',
  ),
  Animal(
    nom: 'النعامة',
    petit: 'صغير النعامة',
    habitat: 'السهول والبراري',
    alimentation: 'عاشب',
    faitInteressant: 'أكبر طير على الأرض لكن لا يطير، سريع على الأرض.',
  ),
  Animal(
    nom: 'الببغاء',
    petit: 'صغير الببغاء',
    habitat: 'الغابات الاستوائية',
    alimentation: 'كُلِّي',
    faitInteressant: 'قادر على تقليد أصوات والكلام البشري عند بعض الأنواع.',
  ),
  Animal(
    nom: 'الطاووس',
    petit: 'صغير الطاووس',
    habitat: 'الغابات والمزارع',
    alimentation: 'كُلِّي',
    faitInteressant: 'لكنه مشهور بذيل الذكر المزخرف أثناء عرض التزاوج.',
  ),
  Animal(
    nom: 'السمّان',
    petit: 'صغير السمان',
    habitat: 'الحقول والمراعي',
    alimentation: 'كُلِّي',
    faitInteressant: 'طيور صغيرة تُربّى أحياناً للبيض واللحم.',
  ),
  Animal(
    nom: 'الطيور المائية (إجمالاً)',
    petit: 'صغير',
    habitat: 'المستنقعات والبحيرات',
    alimentation: 'كُلِّي',
    faitInteressant: 'تلعب دوراً في النظام البيئي للمياه العذبة والسواحل.',
  ),
  Animal(
    nom: 'السمّانة الكبيرة (الإوز)',
    petit: 'صغير الإوز',
    habitat: 'المسطحات المائية والمروج',
    alimentation: 'عاشب',
    faitInteressant: 'يهاجر بعضها لمسافات طويلة ويملك سلوكاً جماعياً قوياً.',
  ),

  // Reptiles & Amphibiens
  Animal(
    nom: 'الضفدع',
    petit: 'شرغوف',
    habitat: 'المستنقعات والبرك',
    alimentation: 'لاحم',
    faitInteressant: 'يمرّ بمراحل تطور واضحة من بيضة إلى شرغوف ثم إلى ضفدع بالغ.',
  ),
  Animal(
    nom: 'السحلية',
    petit: 'صغير السحلية',
    habitat: 'الصحارى والغابات والصخور',
    alimentation: 'كُلِّي/عاشب',
    faitInteressant: 'بعض الأنواع تجلد ذيلها للهروب ويمكنها تجديده لاحقاً.',
  ),
  Animal(
    nom: 'التّمساح (مذكور مرّة أخرى للبحار العذبة)',
    petit: 'صغير التمساح',
    habitat: 'الأنهار والمستنقعات',
    alimentation: 'لاحم',
    faitInteressant: 'من أقدم الزواحف على الأرض وبقاع جسده مصمّمة للصيد في الماء.',
  ),
  Animal(
    nom: 'الأفعى',
    petit: 'صغير الأفعى',
    habitat: 'الصحارى والغابات',
    alimentation: 'لاحم',
    faitInteressant: 'تتحرّك بلا أطراف وتتنقّل بطرق متنوّعة وتستخدم السمّ لدى بعضها.',
  ),
  Animal(
    nom: 'السمندل',
    petit: 'صغير السمندل',
    habitat: 'المياه العذبة والغابات الرطبة',
    alimentation: 'لاحم',
    faitInteressant: 'قادر على تجديد أجزاء من جسمه مثل الذيل في بعض الأنواع.',
  ),
  Animal(
    nom: 'التمساح البحري الكبير',
    petit: 'صغير التمساح البحري',
    habitat: 'المستنقعات الساحلية والأنهار',
    alimentation: 'لاحم',
    faitInteressant: 'قوي جداً وله قدرة على الصيد تحت الماء وعلى اليابسة.',
  ),

  // Insectes & petits animaux
  Animal(
    nom: 'الفراشة',
    petit: 'يرقة (يسروع)',
    habitat: 'الحدائق والغابات',
    alimentation: 'عاشب (مرحلة اليرقة)',
    faitInteressant: 'تمرّ بتحوّل كامل من يرقة إلى شرنقة ثم فراشة بالغة.',
  ),
  Animal(
    nom: 'الخنفساء',
    petit: 'صغير الخنفساء',
    habitat: 'التربة والنباتات',
    alimentation: 'كُلِّي/عاشب',
    faitInteressant: 'توجد أنواع تساعد على تنظيف الطبيعة من المواد العضوية.',
  ),
  Animal(
    nom: 'النملة',
    petit: 'صغير النملة',
    habitat: 'التربة والأماكن الحضرية',
    alimentation: 'كُلِّي',
    faitInteressant: 'تنظم مجتمعات معقدة وتقسم العمل بين أفرادها.',
  ),
  Animal(
    nom: 'اليعسوب',
    petit: 'صغير اليعسوب',
    habitat: 'قرب المسطحات المائية',
    alimentation: 'لاحم',
    faitInteressant: 'طيار ماهر يصيد الحشرات أثناء الطيران.',
  ),
  Animal(
    nom: 'العقرب',
    petit: 'صغير العقرب',
    habitat: 'الصحارى والصخور',
    alimentation: 'لاحم',
    faitInteressant: 'بعض الأنواع لها لذعة مؤلمة لكنها نادرة المميتة.',
  ),
  Animal(
    nom: 'القندس',
    petit: 'صغير القندس',
    habitat: 'الأنهار والمستنقعات',
    alimentation: 'عاشب',
    faitInteressant: 'يبني السدود ويغيّر مسار المياه لصالح موطنه.',
  ),
  Animal(
    nom: 'الخفاش (مذكور مرة ثانية لتقسيم)',
    petit: 'صغير الخفاش',
    habitat: 'الكهوف والمباني',
    alimentation: 'لاحم/كُلِّي',
    faitInteressant: 'يساهم في السيطرة على الحشرات وبعض الأنواع تساعد في نشر بذور الفواكه.',
  ),
  Animal(
    nom: 'الزرافة (مذكور سابقاً لكن هنا ببيان نموذجي آخر)',
    petit: 'جَوْل',
    habitat: 'السافانا',
    alimentation: 'عاشب',
    faitInteressant: 'لسانها طويل ولونه أزرق-أرجواني مما يساعدها في التقاط الأوراق.',
  ),

  // Animaux supplémentaires مختلفون لتكملة 70
  Animal(
    nom: 'القرد',
    petit: 'صغير القرد',
    habitat: 'الغابات الاستوائية',
    alimentation: 'كُلِّي',
    faitInteressant: 'بعض الأنواع تستخدم الأدوات ولها ذكاء اجتماعي مرتفع.',
  ),
  Animal(
    nom: 'الوشق',
    petit: 'شبل الوشق',
    habitat: 'الغابات والجبال',
    alimentation: 'لاحم',
    faitInteressant: 'يملك أذنين مميزتين وشعر كثيف يساعده في البرد.',
  ),
  Animal(
    nom: 'البيسون',
    petit: 'صغير البيسون',
    habitat: 'السهول والأراضي العشبية',
    alimentation: 'عاشب',
    faitInteressant: 'حيوان قوي وهام لنظم المراعي في أمريكا الشمالية.',
  ),
  Animal(
    nom: 'الظربان (الراكون الأفريقي)',
    petit: 'صغير',
    habitat: 'الغابات والسافانا',
    alimentation: 'كُلِّي',
    faitInteressant: 'ذكي ومتكيف مع البيئات المتغيرة.',
  ),
  Animal(
    nom: 'اللاما (مذكورة سابقاً) - ببديل',
    petit: 'صغير اللاما',
    habitat: 'هضاب الأنديز',
    alimentation: 'عاشب',
    faitInteressant: 'مفيد كحيوان نقل ويحفظه السكان المحليون لعدة قرون.',
  ),
  Animal(
    nom: 'السترو (طائر النعام الأسترالي)',
    petit: 'صغير',
    habitat: 'داخل أستراليا',
    alimentation: 'عاشب',
    faitInteressant: 'طائر قوي ويتحمّل ظروف قاسية.',
  ),
];

class QuestionAnimaux {
  final String question;
  final String reponseCorrecte;
  final List<String> options;
  final String type; // "nom", "petit", "habitat", "alimentation", "fait"

  QuestionAnimaux({
    required this.question,
    required this.reponseCorrecte,
    required this.options,
    required this.type,
  });
}
