import 'package:flutter/material.dart';
import '../../models/math_model.dart';
import '../../services/local_storage_service.dart'; // AJOUT: Import du service

class MathJeuPage extends StatefulWidget {
  final int niveau;
  final Function(int) onNiveauTermine;

  const MathJeuPage({
    super.key,
    required this.niveau,
    required this.onNiveauTermine,
  });

  @override
  State<MathJeuPage> createState() => _MathJeuPageState();
}

class _MathJeuPageState extends State<MathJeuPage> {
  int questionActuelle = 0;
  int score = 0;
  List<ProblemeMath> questions = [];
  bool? reponseSelectionnee;
  int? reponseChoisie;
  String? messageFeedback;
  Color couleurMessage = Colors.green;

  // AJOUT: Instance du service de stockage
  final LocalStorageService _storageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _genererQuestions();
  }

  void _genererQuestions() {
    // Pour supporter tous les 25 niveaux avec répétition
    List<ProblemeMath> problemesDisponibles = List.from(problemesMath);
    problemesDisponibles.shuffle();

    int questionsNecessaires = 5;
    List<ProblemeMath> problemesSelectionnes = [];

    if (problemesDisponibles.length >= questionsNecessaires) {
      int startIndex = ((widget.niveau - 1) * 5) % problemesDisponibles.length;

      for (int i = 0; i < questionsNecessaires; i++) {
        int index = (startIndex + i) % problemesDisponibles.length;
        problemesSelectionnes.add(problemesDisponibles[index]);
      }

      problemesSelectionnes.shuffle();
    } else {
      problemesSelectionnes = List.from(problemesDisponibles);

      while (problemesSelectionnes.length < questionsNecessaires) {
        int randomIndex = (widget.niveau + problemesSelectionnes.length) % problemesDisponibles.length;
        problemesSelectionnes.add(problemesDisponibles[randomIndex]);
      }

      problemesSelectionnes = problemesSelectionnes.take(5).toList();
    }

    setState(() {
      questions = problemesSelectionnes;
    });
  }

  // AJOUT: Fonction pour sauvegarder la progression
  Future<void> _saveProgress() async {
    try {
      await _storageService.saveProgress(
        category: 'math', // Catégorie pour les mathématiques
        niveau: widget.niveau,
        score: score,
        niveauTermine: score >= 3,
      );
      print('✅ Progression sauvegardée pour le niveau ${widget.niveau} (math)');
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde: $e');
    }
  }

  void _verifierReponse(int reponse) async { // AJOUT: async
    final bool estCorrecte = reponse == questions[questionActuelle].reponseCorrecte;

    setState(() {
      reponseSelectionnee = true;
      reponseChoisie = reponse;

      if (estCorrecte) {
        score++;
        messageFeedback = '🎉 أحسنت! الإجابة صحيحة 🎉';
        couleurMessage = const Color(0xFF4CAF50);
      } else {
        messageFeedback = '❌ الإجابة خاطئة. الإجابة الصحيحة هي: ${questions[questionActuelle].reponseCorrecte}';
        couleurMessage = const Color(0xFFFF6B6B);
      }
    });

    Future.delayed(const Duration(seconds: 2), () async { // AJOUT: async
      if (questionActuelle < questions.length - 1) {
        setState(() {
          questionActuelle++;
          reponseSelectionnee = null;
          reponseChoisie = null;
          messageFeedback = null;
        });
      } else {
        // AJOUT: Sauvegarder la progression avant d'afficher le dialogue
        await _saveProgress();

        widget.onNiveauTermine(score);

        showDialog(
          context: context,
          barrierDismissible: false, // AJOUT: Empêcher la fermeture accidentelle
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              score >= 3 ? '🎉 تهانينا! 🎉' : '😊 حاول مرة أخرى',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: score >= 3 ? const Color(0xFF4CAF50) : const Color.fromARGB(255, 255, 167, 38), // Color(0xFFFFA726)
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  score >= 3
                      ? 'لقد نجحت في المستوى ${widget.niveau}!'
                      : 'لم تحقق النتيجة المطلوبة في المستوى ${widget.niveau}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 245, 232), // Color(0xFFE8F5E8)
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF4CAF50)),
                  ),
                  child: Text(
                    'النتيجة: $score/5 ⭐',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
                if (score < 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 249, 230), // Color(0xFFFFF9E6)
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade100),
                      ),
                      child: const Text(
                        'يجب أن تحصل على 3/5 على الأقل للانتقال للمستوى التالي',
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    elevation: 5,
                  ),
                  child: const Text(
                    'حسنا 👍',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 232, 245, 232), // Color(0xFFE8F5E8)
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF4CAF50)),
                strokeWidth: 5,
              ),
              const SizedBox(height: 20),
              Text(
                'جاري تحميل المستوى ${widget.niveau}...',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[questionActuelle];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 245, 232), // Color(0xFFE8F5E8)
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: Text(
          'المستوى ${widget.niveau} - السؤال ${questionActuelle + 1}/5',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25), // withOpacity(0.1)
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'النتيجة: $score/5',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF66BB6A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25), // withOpacity(0.1)
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'السؤال ${questionActuelle + 1}/5',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Barre de progression
            Container(
              height: 12,
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
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                  minHeight: 12,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Message de feedback
            if (messageFeedback != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: couleurMessage == const Color(0xFF4CAF50)
                      ? const Color(0xFF4CAF50).withAlpha(25) // CORRIGÉ
                      : const Color(0xFFFF6B6B).withAlpha(25), // CORRIGÉ
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: couleurMessage == const Color(0xFF4CAF50)
                        ? const Color(0xFF4CAF50).withAlpha(75) // CORRIGÉ
                        : const Color(0xFFFF6B6B).withAlpha(75), // CORRIGÉ
                    width: 2,
                  ),
                ),
                child: Text(
                  messageFeedback!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: couleurMessage,
                  ),
                ),
              ),

            // Question
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(75), // withOpacity(0.3) CORRIGÉ
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF4CAF50).withAlpha(75), // CORRIGÉ
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.calculate,
                    size: 50,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    question.question,
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

            const SizedBox(height: 40),

            // Options de réponse
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5,
                children: question.options.map<Widget>((option) {
                  bool estCorrecte = option == question.reponseCorrecte;
                  Color couleurBouton = const Color(0xFF4CAF50);
                  Color couleurTexte = Colors.white;
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
                      couleurTexte = Colors.black54;
                    }
                  }

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: couleurBouton.withAlpha(50), // CORRIGÉ
                          blurRadius: 8,
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
                        foregroundColor: couleurTexte,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icone != null) ...[
                            Icon(icone, size: 30, color: Colors.white),
                            const SizedBox(height: 8),
                          ],
                          Text(
                            '$option',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: couleurTexte,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}