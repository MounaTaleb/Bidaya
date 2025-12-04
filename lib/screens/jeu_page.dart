// pages/jeu_page.dart
import 'package:flutter/material.dart';
import '../models/pays_model.dart';

class JeuPage extends StatefulWidget {
  final int niveau;
  final Function(int) onNiveauTermine;

  const JeuPage({
    super.key,
    required this.niveau,
    required this.onNiveauTermine,
  });

  @override
  State<JeuPage> createState() => _JeuPageState();
}

class _JeuPageState extends State<JeuPage> {
  int questionActuelle = 0;
  int score = 0;
  List<Map<String, dynamic>> questions = [];
  bool? reponseSelectionnee;
  String? reponseChoisie;

  @override
  void initState() {
    super.initState();
    _genererQuestions();
  }

  void _genererQuestions() {
    List<Pays> paysDisponibles = List.from(paysArabes);
    paysDisponibles.shuffle();

    int questionsNecessaires = 5;
    List<Pays> paysSelectionnes = [];

    if (paysDisponibles.length >= questionsNecessaires) {
      int startIndex = ((widget.niveau - 1) * 5) % paysDisponibles.length;

      for (int i = 0; i < questionsNecessaires; i++) {
        int index = (startIndex + i) % paysDisponibles.length;
        paysSelectionnes.add(paysDisponibles[index]);
      }

      paysSelectionnes.shuffle();
    } else {
      paysSelectionnes = List.from(paysDisponibles);

      while (paysSelectionnes.length < questionsNecessaires) {
        int randomIndex = (widget.niveau + paysSelectionnes.length) % paysDisponibles.length;
        paysSelectionnes.add(paysDisponibles[randomIndex]);
      }

      paysSelectionnes = paysSelectionnes.take(5).toList();
    }

    questions = paysSelectionnes.map((pays) {
      List<String> toutesCapitales = paysArabes.map((p) => p.capitale).toList();
      toutesCapitales.remove(pays.capitale);

      toutesCapitales.shuffle();
      List<String> mauvaisesReponses = toutesCapitales.take(3).toList();

      List<String> options = [pays.capitale, ...mauvaisesReponses];
      options.shuffle();

      return {
        'pays': pays.nom,
        'capitaleCorrecte': pays.capitale,
        'options': options,
      };
    }).toList();
  }

  void _verifierReponse(String reponse) {
    bool estCorrecte = reponse == questions[questionActuelle]['capitaleCorrecte'];

    setState(() {
      reponseSelectionnee = true;
      reponseChoisie = reponse;
      if (estCorrecte) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (questionActuelle < 4) {
        setState(() {
          questionActuelle++;
          reponseSelectionnee = null;
          reponseChoisie = null;
        });
      } else {
        widget.onNiveauTermine(score);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Column(
              children: [
                Text(
                  score >= 3 ? '🌟' : '😊',
                  style: const TextStyle(fontSize: 50),
                ),
                const SizedBox(height: 10),
                Text(
                  score >= 3 ? '🎉 أحسنت! 🎉' : 'حاول مرة أخرى',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: score >= 3
                        ? const Color.fromARGB(255, 255, 158, 206) // Color(0xFFFF9ECE)
                        : const Color.fromARGB(255, 255, 167, 38), // Color(0xFFFFA726)
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 249, 230), // Color(0xFFFFF9E6)
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 158, 206), // Color(0xFFFF9ECE)
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        score >= 3
                            ? 'لقد نجحت في المستوى ${widget.niveau}!'
                            : 'لم تحقق النتيجة المطلوبة',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 102, 102, 102), // Color(0xFF666666)
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'النتيجة: $score/5 ⭐',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 158, 206), // Color(0xFFFF9ECE)
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
                    backgroundColor: const Color.fromARGB(255, 255, 158, 206), // Color(0xFFFF9ECE)
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'حسنا',
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
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 249, 230), // Color(0xFFFFF9E6)
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 255, 158, 206), // Color(0xFFFF9ECE)
            ),
          ),
        ),
      );
    }

    final question = questions[questionActuelle];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 230), // Color(0xFFFFF9E6)
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 158, 206), // Color(0xFFFF9ECE)
        title: Text('المستوى ${widget.niveau} - السؤال ${questionActuelle + 1}/5'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 158, 206), // Color(0xFFFF9ECE)
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'النتيجة: $score/5',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 224, 130), // Color(0xFFFFE082)
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'السؤال ${questionActuelle + 1}/5',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            LinearProgressIndicator(
              value: (questionActuelle + 1) / 5,
              backgroundColor: Colors.grey[300],
              color: const Color.fromARGB(255, 255, 158, 206), // Color(0xFFFF9ECE)
              borderRadius: BorderRadius.circular(10),
              minHeight: 8,
            ),

            const SizedBox(height: 40),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(75), // withOpacity(0.3)
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 158, 206), // Color(0xFFFF9ECE)
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'ما هي عاصمة',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      question['pays'],
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 158, 206), // Color(0xFFFF9ECE)
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Text(
                    '؟',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            ...question['options'].map<Widget>((option) {
              bool estCorrecte = option == question['capitaleCorrecte'];
              Color couleurBouton = const Color.fromARGB(255, 255, 158, 206); // Color(0xFFFF9ECE)
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
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: couleurBouton.withAlpha(50),
                        blurRadius: 6,
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
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icone != null) ...[
                          Icon(icone, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}