import 'package:flutter/material.dart';
import '../../models/animaux_model.dart';
import '../../services/local_storage_service.dart'; // AJOUT: Import du service de stockage

class AnimauxJeuPage extends StatefulWidget {
  final int niveau;
  final Function(int) onNiveauTermine;

  const AnimauxJeuPage({
    super.key,
    required this.niveau,
    required this.onNiveauTermine,
  });

  @override
  State<AnimauxJeuPage> createState() => _AnimauxJeuPageState();
}

class _AnimauxJeuPageState extends State<AnimauxJeuPage> {
  int questionActuelle = 0;
  int score = 0;
  List<Map<String, dynamic>> questions = [];
  bool? reponseSelectionnee;
  String? reponseChoisie;
  String? messageFeedback;
  Color couleurMessage = Colors.green;
  bool showInfo = false;

  // AJOUT: Instance du service de stockage
  final LocalStorageService _storageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _genererQuestions();
  }

  void _genererQuestions() {
    // Pour supporter tous les 25 niveaux avec répétition
    List<Animal> animauxDisponibles = List.from(animaux);
    animauxDisponibles.shuffle();

    int questionsNecessaires = 5;
    List<Animal> animauxSelectionnes = [];

    if (animauxDisponibles.length >= questionsNecessaires) {
      int startIndex = ((widget.niveau - 1) * 5) % animauxDisponibles.length;

      for (int i = 0; i < questionsNecessaires; i++) {
        int index = (startIndex + i) % animauxDisponibles.length;
        animauxSelectionnes.add(animauxDisponibles[index]);
      }

      animauxSelectionnes.shuffle();
    } else {
      animauxSelectionnes = List.from(animauxDisponibles);

      while (animauxSelectionnes.length < questionsNecessaires) {
        int randomIndex = (widget.niveau + animauxSelectionnes.length) % animauxDisponibles.length;
        animauxSelectionnes.add(animauxDisponibles[randomIndex]);
      }

      animauxSelectionnes = animauxSelectionnes.take(5).toList();
    }

    questions = [];
    for (int i = 0; i < animauxSelectionnes.length; i++) {
      final animal = animauxSelectionnes[i];
      List<String> typesQuestions = ['nom', 'petit', 'habitat'];
      String type = typesQuestions[i % 3]; // CORRECTION: utiliser i au lieu de questions.length

      String question;
      String reponseCorrecte;
      List<String> options = [];

      switch (type) {
        case 'nom':
          question = 'ما اسم صغير ${animal.nom}؟';
          reponseCorrecte = animal.petit;
          List<String> autresPetits = animaux
              .where((a) => a.petit != animal.petit)
              .map((a) => a.petit)
              .toList();
          autresPetits.shuffle();
          options = [animal.petit, ...autresPetits.take(2)];
          break;

        case 'petit':
          question = 'ما اسم الحيوان الذي صغيره يسمى "${animal.petit}"؟';
          reponseCorrecte = animal.nom;
          List<String> autresNoms = animaux
              .where((a) => a.nom != animal.nom)
              .map((a) => a.nom)
              .toList();
          autresNoms.shuffle();
          options = [animal.nom, ...autresNoms.take(2)];
          break;

        case 'habitat':
          question = 'أين يعيش حيوان ${animal.nom}؟';
          reponseCorrecte = animal.habitat;
          List<String> autresHabitats = animaux
              .where((a) => a.habitat != animal.habitat)
              .map((a) => a.habitat)
              .toList();
          autresHabitats.shuffle();
          options = [animal.habitat, ...autresHabitats.take(2)];
          break;

        default:
          question = 'ما اسم صغير ${animal.nom}؟';
          reponseCorrecte = animal.petit;
      }

      options.shuffle();

      questions.add({
        'question': question,
        'reponseCorrecte': reponseCorrecte,
        'options': options,
        'animal': animal,
        'type': type,
      });
    }
  }

  // AJOUT: Fonction pour sauvegarder la progression
  Future<void> _saveProgress() async {
    try {
      await _storageService.saveProgress(
        category: 'animaux', // Catégorie pour les animaux
        niveau: widget.niveau,
        score: score,
        niveauTermine: score >= 3,
      );
      print('✅ Progression sauvegardée pour le niveau ${widget.niveau}');
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde: $e');
    }
  }

  void _verifierReponse(String reponse) async { // AJOUT: async
    final bool estCorrecte = reponse == questions[questionActuelle]['reponseCorrecte'];

    setState(() {
      reponseSelectionnee = true;
      reponseChoisie = reponse;
      showInfo = true;

      if (estCorrecte) {
        score++;
        messageFeedback = '🎉 أحسنت! الإجابة صحيحة 🎉';
        couleurMessage = const Color(0xFF4CAF50);
      } else {
        messageFeedback = '❌ الإجابة خاطئة';
        couleurMessage = const Color(0xFFFF6B6B);
      }
    });

    Future.delayed(const Duration(seconds: 3), () async { // AJOUT: async
      if (questionActuelle < questions.length - 1) {
        setState(() {
          questionActuelle++;
          reponseSelectionnee = null;
          reponseChoisie = null;
          messageFeedback = null;
          showInfo = false;
        });
      } else {
        // AJOUT: Sauvegarder la progression avant d'afficher le dialogue
        await _saveProgress();

        widget.onNiveauTermine(score);

        showDialog(
          context: context,
          barrierDismissible: false, // Empêcher la fermeture accidentelle
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: Column(
              children: [
                Text(
                  score >= 3 ? '🎉' : '😊',
                  style: const TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 10),
                Text(
                  score >= 3 ? 'تهانينا!' : 'حاول مرة أخرى',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: score >= 3
                        ? const Color.fromARGB(255, 121, 85, 72) // Color(0xFF795548)
                        : const Color.fromARGB(255, 255, 167, 38), // Color(0xFFFFA726)
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 121, 85, 72), // Color(0xFF795548)
                        Color.fromARGB(255, 161, 136, 127) // Color(0xFFA1887F)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25), // withOpacity(0.1)
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        score >= 3
                            ? 'لقد نجحت في المستوى ${widget.niveau}!'
                            : 'لم تحقق النتيجة المطلوبة في المستوى ${widget.niveau}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'النتيجة: $score/${questions.length} ⭐',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 121, 85, 72), // Color(0xFF795548)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (score < 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 249, 230), // Color(0xFFFFF9E6)
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'يجب أن تحصل على 3/5 على الأقل للانتقال للمستوى التالي',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 102, 102, 102), // Color(0xFF666666)
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Fermer la boîte de dialogue
                    Navigator.pop(context); // Retourner à l'écran précédent
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 121, 85, 72), // Color(0xFF795548)
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    elevation: 5,
                  ),
                  child: const Text(
                    'حسنا 👍',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  String _getEmojiForAnimal(String nom) {
    final emojiMap = {
      'الأسد': '🦁',
      'الفيل': '🐘',
      'الحصان': '🐎',
      'البقرة': '🐄',
      'الخروف': '🐑',
      'النمر': '🐅',
      'الدب': '🐻',
      'الغزال': '🦌',
      'الذئب': '🐺',
      'القرد': '🐒', // أكثر دقّة للقرد
      'الدلفين': '🐬',
      'الحوت': '🐋',
      'القرش': '🦈',
      'السلحفاة': '🐢',
      'نجم البحر': '🌟', // ⭐ ليس حيوان — استبدلته بـ 🌟 الممكنة الوحيدة
      'الفراشة': '🦋',
      'النحلة': '🐝',
      'العصفور': '🐦',
      'البطريق': '🐧',
      'البومة': '🦉',
      'الخفاش': '🦇',
      'الثعلب': '🦊',
      'الزرافة': '🦒',
      'فرس النهر': '🦛',
      'الكوالا': '🐨',
      'الباندا': '🐼',
      'الكسلان (Sloth)': '🦥',
      'الظبي': '🦌', // نفس الغزال
      'الكنغر': '🦘',
      'الراكون': '🦝',
      'الهامستر': '🐹',
      'الأرنب': '🐰',
      'الفأر': '🐭',
      'السنجاب': '🐿️',
      'القنفذ': '🦔',
      'التمساح': '🐊',
      'الحرباء': '🦎',
      'الأفعى': '🐍',
      'العقرب': '🦂',
      'العنكبوت': '🕷️',
      'النملة': '🐜',
      'الصرصور': '🪳',
      'الجندب': '🦗',
      'الحلزون': '🐌',
      'قنديل البحر': '🪼', // الإيموجي الصحيح
      'الأخطبوط': '🐙',
      'السمكة': '🐟',
    };

    return emojiMap[nom] ?? '🐾';
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 239, 235, 233), // Color(0xFFEFEBE9)
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromARGB(255, 121, 85, 72), // Color(0xFF795548)
                ),
                strokeWidth: 5,
              ),
              const SizedBox(height: 20),
              Text(
                'جاري تحميل المستوى ${widget.niveau}...',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 121, 85, 72), // Color(0xFF795548)
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[questionActuelle];
    final Animal animal = question['animal'];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 235, 233), // Color(0xFFEFEBE9)
      body: SafeArea(
        child: Column(
          children: [
            // Header avec dégradé marron
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 121, 85, 72), // Color(0xFF795548)
                    Color.fromARGB(255, 161, 136, 127) // Color(0xFFA1887F)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        size: 22, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      '🐾 المستوى ${widget.niveau} 🐾',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Score et progression
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard('⭐ النقاط', '$score/${questions.length}', [
                            const Color.fromARGB(255, 121, 85, 72),
                            const Color.fromARGB(255, 161, 136, 127)
                          ]),
                          _buildStatCard('📝 السؤال', '${questionActuelle + 1}/${questions.length}', [
                            const Color.fromARGB(255, 141, 110, 99),
                            const Color.fromARGB(255, 188, 170, 164)
                          ]),
                        ],
                      ),
                    ),

                    // Barre de progression
                    Container(
                      height: 12,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (questionActuelle + 1) / questions.length,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 121, 85, 72),
                          ),
                          minHeight: 12,
                        ),
                      ),
                    ),

                    // Message de feedback
                    if (messageFeedback != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: couleurMessage == const Color(0xFF4CAF50)
                                ? [
                              const Color(0xFF4CAF50),
                              const Color(0xFF66BB6A)
                            ]
                                : [
                              const Color(0xFFFF6B6B),
                              const Color(0xFFFF8787)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: couleurMessage == const Color(0xFF4CAF50)
                                  ? const Color(0xFF4CAF50).withAlpha(100)
                                  : const Color(0xFFFF6B6B).withAlpha(100),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          messageFeedback!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    // Question
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 121, 85, 72).withAlpha(50),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: const Color.fromARGB(255, 121, 85, 72),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _getEmojiForAnimal(animal.nom),
                            style: const TextStyle(fontSize: 50),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            question['question'],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Information sur l'animal
                    if (showInfo)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 245, 245, 245),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(255, 121, 85, 72).withAlpha(100),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🐾 معلومات عن الحيوان:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 121, 85, 72),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow('الاسم', animal.nom),
                            _buildInfoRow('الصغير', animal.petit),
                            _buildInfoRow('الموطن', animal.habitat),
                            _buildInfoRow('التغذية', animal.alimentation),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 121, 85, 72).withAlpha(50),
                                ),
                              ),
                              child: Text(
                                animal.faitInteressant,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Options de réponse
                    ...question['options'].map<Widget>((option) {
                      bool estCorrecte = option == question['reponseCorrecte'];
                      Color couleurBouton = const Color.fromARGB(255, 121, 85, 72);
                      IconData? icone;

                      if (reponseSelectionnee != null) {
                        if (estCorrecte) {
                          couleurBouton = const Color(0xFF4CAF50);
                          icone = Icons.check_circle;
                        } else if (option == reponseChoisie) {
                          couleurBouton = const Color(0xFFFF6B6B);
                          icone = Icons.cancel;
                        } else {
                          couleurBouton = Colors.grey.shade300;
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: couleurBouton.withAlpha(50),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: reponseSelectionnee == null
                              ? () => _verifierReponse(option)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: couleurBouton,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (icone != null) ...[
                                Icon(icone, size: 24),
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AJOUT: Méthode pour créer une carte de statistiques
  Widget _buildStatCard(String title, String value, List<Color> colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.first.withAlpha(75),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // AJOUT: Méthode pour créer une ligne d'information
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}