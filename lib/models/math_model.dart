// math_problems.dart

class ProblemeMath {
  final String question;
  final int reponseCorrecte;
  final List<int> options;
  final String? image;

  ProblemeMath({
    required this.question,
    required this.reponseCorrecte,
    required this.options,
    this.image,
  });
}

List<ProblemeMath> problemesMath = [

  // -------------------- Niveau 1 --------------------
  ProblemeMath(
    question: 'إذا كان عندي 3 تفاحات وأعطتني أمي 2 تفاحتين أخريين، فكم تفاحة أصبح لدي؟',
    reponseCorrecte: 5,
    options: [4, 5, 6, 3],
  ),
  ProblemeMath(
    question: 'لدى أحمد 4 أقلام واشترى 3 أقلام أخرى. كم قلماً أصبح لديه؟',
    reponseCorrecte: 7,
    options: [6, 7, 8, 5],
  ),
  ProblemeMath(
    question: 'في الحديقة 5 أزهار حمراء و 3 أزهار صفراء. كم زهرة في المجموع؟',
    reponseCorrecte: 8,
    options: [7, 8, 9, 6],
  ),
  ProblemeMath(
    question: 'سارة لديها 6 قطع حلوى وأكلت قطعتين. كم قطعة بقيت معها؟',
    reponseCorrecte: 4,
    options: [3, 4, 5, 6],
  ),
  ProblemeMath(
    question: 'في الصف 7 تلاميذ حضروا و 2 تغيبوا. كم تلميذ في الصف؟',
    reponseCorrecte: 9,
    options: [8, 9, 10, 7],
  ),

  // -------------------- Niveau 2 --------------------
  ProblemeMath(
    question: 'اشترى علي كتاب بـ 8 دنانير وقلم بـ 3 دنانير. كم دفع في المجموع؟',
    reponseCorrecte: 11,
    options: [10, 11, 12, 9],
  ),
  ProblemeMath(
    question: 'كان مع يوسف 15 ديناراً وأنفق 7 دنانير. كم بقي معه؟',
    reponseCorrecte: 8,
    options: [7, 8, 9, 10],
  ),
  ProblemeMath(
    question: 'في السلة 12 تفاحة، أخذت منها 4 تفاحات. كم بقي في السلة؟',
    reponseCorrecte: 8,
    options: [7, 8, 9, 10],
  ),
  ProblemeMath(
    question: 'أكمل: 9 + 6 - 4 = ؟',
    reponseCorrecte: 11,
    options: [10, 11, 12, 13],
  ),
  ProblemeMath(
    question: 'إذا كان 5 × 4 = 20، فما هو 20 ÷ 4؟',
    reponseCorrecte: 5,
    options: [4, 5, 6, 7],
  ),

  // -------------------- Niveau 3 --------------------
  ProblemeMath(
    question: 'لدى كل طفل 3 كرات. إذا كان هناك 4 أطفال، فكم كرة في المجموع؟',
    reponseCorrecte: 12,
    options: [10, 12, 14, 16],
  ),
  ProblemeMath(
    question: 'وزع المعلم 18 قلماً على 3 تلاميذ بالتساوي. كم قلماً أخذ كل تلميذ؟',
    reponseCorrecte: 6,
    options: [5, 6, 7, 8],
  ),
  ProblemeMath(
    question: 'ما هو ناتج 7 × 8؟',
    reponseCorrecte: 56,
    options: [54, 56, 58, 60],
  ),
  ProblemeMath(
    question: 'إذا كان 6 × 5 = 30، فما هو 30 ÷ 6؟',
    reponseCorrecte: 5,
    options: [4, 5, 6, 7],
  ),
  ProblemeMath(
    question: 'اشترت سارة 4 علب عصير، كل علبة بـ 3 دنانير. كم دفعت؟',
    reponseCorrecte: 12,
    options: [10, 12, 14, 16],
  ),

  // -------------------- Niveau 4 --------------------
  ProblemeMath(
    question: 'مريم عمرها 8 سنوات، وعمر أخيها 12 سنة. ما الفرق بين عمريهما؟',
    reponseCorrecte: 4,
    options: [3, 4, 5, 6],
  ),
  ProblemeMath(
    question: 'إذا كان سعر القلم 250 مليم وسعر الدفتر 750 مليم، فكم المليمات التي سأحتاجها لشراء الاثنين؟',
    reponseCorrecte: 1000,
    options: [900, 1000, 1100, 1200],
  ),
  ProblemeMath(
    question: 'بدأت الحفلة الساعة 3:00 وانتهت الساعة 5:30. كم دقيقة استمرت الحفلة؟',
    reponseCorrecte: 150,
    options: [120, 150, 180, 210],
  ),
  ProblemeMath(
    question: 'مزرعة تحتوي على 24 شجرة برتقال موزعة على 6 صفوف. كم شجرة في كل صف؟',
    reponseCorrecte: 4,
    options: [3, 4, 5, 6],
  ),
  ProblemeMath(
    question: 'اشترى أحمد 3 كيلوغرامات من التفاح بسعر 5 دنانير للكيلو. كم دفع؟',
    reponseCorrecte: 15,
    options: [12, 15, 18, 20],
  ),

  // -------------------- EXTRA Questions (10) --------------------
  ProblemeMath(
    question: 'لدى منى 20 قطعة شوكولاتة وأعطت 5 لصديقتها. كم بقي معها؟',
    reponseCorrecte: 15,
    options: [10, 12, 15, 17],
  ),
  ProblemeMath(
    question: 'كم نتيجة: 14 - 9 + 5 ؟',
    reponseCorrecte: 10,
    options: [8, 9, 10, 11],
  ),
  ProblemeMath(
    question: 'إذا كان ثمن اللعبتين 7 دنانير للواحدة، كم ثمن 3 لعب؟',
    reponseCorrecte: 21,
    options: [18, 20, 21, 24],
  ),
  ProblemeMath(
    question: 'قطة لديها 4 صغار. كم عدد الأرجل لجميع القطط؟ (عدد الأرجل = 4)',
    reponseCorrecte: 20,
    options: [16, 20, 24, 28],
  ),
  ProblemeMath(
    question: 'نتيجة: 9 × 3 ؟',
    reponseCorrecte: 27,
    options: [24, 27, 30, 21],
  ),
  ProblemeMath(
    question: 'قضى سامي 45 دقيقة في الدراسة و 30 دقيقة في اللعب. كم استغرق في المجموع؟',
    reponseCorrecte: 75,
    options: [60, 70, 75, 80],
  ),
  ProblemeMath(
    question: 'بستان فيه 30 شجرة، قام المزارع بقطع 6. كم بقي؟',
    reponseCorrecte: 24,
    options: [20, 22, 24, 26],
  ),
  ProblemeMath(
    question: 'ما هو ناتج 48 ÷ 6 ؟',
    reponseCorrecte: 8,
    options: [6, 7, 8, 9],
  ),
  ProblemeMath(
    question: 'في الفصل 18 تلميذاً، غاب 3. كم حضر اليوم؟',
    reponseCorrecte: 15,
    options: [14, 15, 16, 17],
  ),
  ProblemeMath(
    question: 'لدى تاجر 50 تفاحة وباع 23. كم بقي لديه؟',
    reponseCorrecte: 27,
    options: [25, 27, 28, 30],
  ),
];
