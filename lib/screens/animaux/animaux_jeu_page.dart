import 'package:flutter/material.dart';
import '../../models/animaux_model.dart';

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

  @override
  void initState() {
    super.initState();
    _genererQuestions();
  }

  void _genererQuestions() {
    // Prendre 5 animaux pour le niveau actuel
    int startIndex = (widget.niveau - 1) * 5;
    int endIndex = startIndex + 5;

    if (endIndex > animaux.length) {
      endIndex = animaux.length;
    }

    List<Animal> animauxNiveau = animaux.sublist(startIndex, endIndex);

    questions = animauxNiveau.map((animal) {
      // Générer des questions variées
      List<String> typesQuestions = ['nom', 'petit', 'habitat'];
      String type = typesQuestions[questionActuelle % 3];

      String question;
      String reponseCorrecte;
      List<String> options = [];

      switch (type) {
        case 'nom':
          question = 'ما اسم صغير ${animal.nom}؟';
          reponseCorrecte = animal.petit;
          // MODIFICATION : Prendre seulement 2 mauvaises réponses
          List<String> autresPetits = animaux
              .where((a) => a.petit != animal.petit)
              .map((a) => a.petit)
              .toList();
          autresPetits.shuffle();
          options = [animal.petit, ...autresPetits.take(2)]; // 2 au lieu de 3
          break;

        case 'petit':
          question = 'ما اسم الحيوان الذي صغيره يسمى "${animal.petit}"؟';
          reponseCorrecte = animal.nom;
          // MODIFICATION : Prendre seulement 2 mauvaises réponses
          List<String> autresNoms = animaux
              .where((a) => a.nom != animal.nom)
              .map((a) => a.nom)
              .toList();
          autresNoms.shuffle();
          options = [animal.nom, ...autresNoms.take(2)]; // 2 au lieu de 3
          break;

        case 'habitat':
          question = 'أين يعيش حيوان ${animal.nom}؟';
          reponseCorrecte = animal.habitat;
          // MODIFICATION : Prendre seulement 2 mauvaises réponses
          List<String> autresHabitats = animaux
              .where((a) => a.habitat != animal.habitat)
              .map((a) => a.habitat)
              .toList();
          autresHabitats.shuffle();
          options = [animal.habitat, ...autresHabitats.take(2)]; // 2 au lieu de 3
          break;

        default:
          question = 'ما اسم صغير ${animal.nom}؟';
          reponseCorrecte = animal.petit;
      }

      options.shuffle();

      return {
        'question': question,
        'reponseCorrecte': reponseCorrecte,
        'options': options,
        'animal': animal,
        'type': type,
      };
    }).toList();
  }

  void _verifierReponse(String reponse) {
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

    Future.delayed(const Duration(seconds: 3), () {
      if (questionActuelle < questions.length - 1) {
        setState(() {
          questionActuelle++;
          reponseSelectionnee = null;
          reponseChoisie = null;
          messageFeedback = null;
          showInfo = false;
        });
      } else {
        widget.onNiveauTermine(score);
        Navigator.pop(context);

        showDialog(
          context: context,
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
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFFFA726),
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
                      colors: [Color(0xFF795548), Color(0xFFA1887F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        score >= 3
                            ? 'لقد نجحت في هذا المستوى!'
                            : 'لم تحقق النتيجة المطلوبة',
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
                            color: Color(0xFF795548),
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
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'يجب أن تحصل على 3/5 على الأقل للانتقال للمستوى التالي',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548),
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
    switch (nom) {
      case 'الأسد': return '🦁';
      case 'الفيل': return '🐘';
      case 'الحصان': return '🐎';
      case 'البقرة': return '🐄';
      case 'الخروف': return '🐑';
      case 'النمر': return '🐅';
      case 'الدب': return '🐻';
      case 'الغزال': return '🦌';
      case 'الذئب': return '🐺';
      case 'القرد': return '🐵';
      case 'الدلفين': return '🐬';
      case 'الحوت': return '🐋';
      case 'القرش': return '🦈';
      case 'السلحفاة': return '🐢';
      case 'نجم البحر': return '⭐';
      default: return '🐾';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFEFEBE9),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF795548)),
                strokeWidth: 5,
              ),
              const SizedBox(height: 20),
              const Text(
                'جاري التحميل...',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF795548),
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
      backgroundColor: const Color(0xFFEFEBE9),
      body: SafeArea(
        child: Column(
          children: [
            // Header avec dégradé marron
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF795548), Color(0xFFA1887F)],
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
                        size: 24, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      '🐾 المستوى ${widget.niveau} 🐾',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Score et progression
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF795548), Color(0xFFA1887F)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF795548).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '⭐ ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '$score/${questions.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8D6E63), Color(0xFFBCAAA4)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8D6E63).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            '${questionActuelle + 1}/${questions.length} 📝',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Barre de progression
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: LinearProgressIndicator(
                          value: (questionActuelle + 1) / questions.length,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF795548),
                          ),
                          minHeight: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Message de feedback
                    if (messageFeedback != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 20),
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
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: couleurMessage.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          messageFeedback!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    // Question avec design enfantin
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF795548).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF795548),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _getEmojiForAnimal(animal.nom),
                            style: const TextStyle(fontSize: 60),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            question['question'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Information sur l'animal (affichée après réponse)
                    if (showInfo)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF795548).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '🐾 معلومات عن الحيوان:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF795548),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'الاسم: ${animal.nom}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'الصغير: ${animal.petit}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'الموطن: ${animal.habitat}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'التغذية: ${animal.alimentation}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              animal.faitInteressant,
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 30),

                    // Options de réponse - MAINTENANT SEULEMENT 3 CHOIX
                    ...question['options'].map<Widget>((option) {
                      bool estCorrecte = option == question['reponseCorrecte'];
                      Color couleurBouton = const Color(0xFF795548);
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

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: couleurBouton.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
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
                              minimumSize: const Size(double.infinity, 70),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (icone != null) ...[
                                  Icon(icone, size: 28),
                                  const SizedBox(width: 10),
                                ],
                                Flexible(
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
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
}