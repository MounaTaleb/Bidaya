// models/animaux_model.dart
class Animal {
  final String nom;
  final String petit;
  final String habitat;
  final String alimentation;
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
  // Niveau 1 (Animaux domestiques)
  Animal(
    nom: 'الأسد',
    petit: 'الشبل',
    habitat: 'السافانا الأفريقية',
    alimentation: 'لاحم',
    faitInteressant: 'يسمى ملك الغابة ويمكن سماع زئيره من مسافة 8 كم',
  ),
  Animal(
    nom: 'الفيل',
    petit: 'الديسم',
    habitat: 'الغابات والسافانا',
    alimentation: 'عاشب',
    faitInteressant: 'أكبر حيوان بري ويمكن أن يعيش حتى 70 سنة',
  ),
  Animal(
    nom: 'الحصان',
    petit: 'المهر',
    habitat: 'المزارع والمراعي',
    alimentation: 'عاشب',
    faitInteressant: 'يمكنه النوم واقفاً ويتمتع بذاكرة قوية',
  ),
  Animal(
    nom: 'البقرة',
    petit: 'العجل',
    habitat: 'المزارع',
    alimentation: 'عاشب',
    faitInteressant: 'لديها 4 معدات لهضم الطعام وتمضغ الطعام أكثر من 40 مرة في الدقيقة',
  ),
  Animal(
    nom: 'الخروف',
    petit: 'الحمل',
    habitat: 'المزارع والمراعي',
    alimentation: 'عاشب',
    faitInteressant: 'يتميز بذاكرة قوية يمكنه تذكر وجوه الأغنام الأخرى لسنوات',
  ),

  // Niveau 2 (Animaux sauvages)
  Animal(
    nom: 'النمر',
    petit: 'الجرموز',
    habitat: 'الغابات والسهول',
    alimentation: 'لاحم',
    faitInteressant: 'أسرع حيوان بري يمكنه الركض بسرعة 110 كم/ساعة',
  ),
  Animal(
    nom: 'الدب',
    petit: 'الديسم',
    habitat: 'الغابات والجبال',
    alimentation: 'قارت',
    faitInteressant: 'يمكنه السبات الشتوي لمدة 6 أشهر دون طعام أو شراب',
  ),
  Animal(
    nom: 'الغزال',
    petit: 'الخشف',
    habitat: 'الغابات والسهول',
    alimentation: 'عاشب',
    faitInteressant: 'يتميز بحاسة سمع قوية ويمكنه القفز لمسافة 10 أمتار',
  ),
  Animal(
    nom: 'الذئب',
    petit: 'الجرو',
    habitat: 'الغابات والجبال',
    alimentation: 'لاحم',
    faitInteressant: 'يعيش في مجموعات تسمى القطعان ويمكنه العواء للتواصل',
  ),
  Animal(
    nom: 'القرد',
    petit: 'الرضيع',
    habitat: 'الغابات الاستوائية',
    alimentation: 'قارت',
    faitInteressant: 'يستخدم الأدوات ويمكنه تعلم لغة الإشارة',
  ),

  // Niveau 3 (Animaux marins)
  Animal(
    nom: 'الدلفين',
    petit: 'العجل',
    habitat: 'المحيطات',
    alimentation: 'لاحم',
    faitInteressant: 'يستخدم نظام سونار طبيعي للتنقل والصيد',
  ),
  Animal(
    nom: 'الحوت',
    petit: 'العجل',
    habitat: 'المحيطات',
    alimentation: 'قارت',
    faitInteressant: 'أكبر حيوان على وجه الأرض وقلبه بحجم سيارة',
  ),
  Animal(
    nom: 'القرش',
    petit: 'الجرو',
    habitat: 'المحيطات',
    alimentation: 'لاحم',
    faitInteressant: 'يمتلك حاسة شم قوية يمكنه شم رائحة الدم من مسافة 5 كم',
  ),
  Animal(
    nom: 'السلحفاة',
    petit: 'الصغير',
    habitat: 'البحر والبر',
    alimentation: 'قارت',
    faitInteressant: 'يمكنها العيش لأكثر من 100 سنة وتحمل صدفتها طوال حياتها',
  ),
  Animal(
    nom: 'نجم البحر',
    petit: 'اليرقة',
    habitat: 'قاع المحيط',
    alimentation: 'لاحم',
    faitInteressant: 'يمكنه تجديد أطرافه المفقودة وقد ينمو جسم جديد من طرف واحد',
  ),
];

class QuestionAnimaux {
  final String question;
  final String reponseCorrecte;
  final List<String> options;
  final String type; // "nom", "petit", "habitat"

  QuestionAnimaux({
    required this.question,
    required this.reponseCorrecte,
    required this.options,
    required this.type,
  });
}