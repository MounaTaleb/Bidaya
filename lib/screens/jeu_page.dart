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

  @override
  void initState() {
    super.initState();
    _genererQuestions();
  }

  void _genererQuestions() {
    List<Pays> paysMelanges = List.from(paysArabes)..shuffle();

    questions = paysMelanges.take(5).map((pays) {
      List<String> mauvaisesReponses = [];
      List<Pays> autresPays = List.from(paysArabes)
        ..removeWhere((p) => p.nom == pays.nom);
      autresPays.shuffle();

      mauvaisesReponses = autresPays.take(3).map((p) => p.capitale).toList();

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
    setState(() {
      reponseSelectionnee = reponse == questions[questionActuelle]['capitaleCorrecte'];
      if (reponseSelectionnee!) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (questionActuelle < 4) {
        setState(() {
          questionActuelle++;
          reponseSelectionnee = null;
        });
      } else {
        widget.onNiveauTermine(score);
        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(score >= 3 ? '🎉 أحسنت! 🎉' : '😊 حاول مرة أخرى'),
            content: Text(
              score >= 3
                  ? 'لقد نجحت في هذا المستوى! \nالنتيجة: $score/5'
                  : 'النتيجة: $score/5\nيجب أن تحصل على 3/5 على الأقل للانتقال للمستوى التالي',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('حسنا'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final question = questions[questionActuelle];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9ECE),
        title: Text('المستوى ${widget.niveau} - السؤال ${questionActuelle + 1}/5'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                Text('النتيجة: $score/5'),
                Text('السؤال ${questionActuelle + 1}/5'),
              ],
            ),
            const SizedBox(height: 20),

            LinearProgressIndicator(
              value: (questionActuelle + 1) / 5,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFFFF9ECE),
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
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'ما هي عاصمة',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    question['pays'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9ECE),
                    ),
                    textAlign: TextAlign.center,
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
              Color couleurBouton = const Color(0xFFFF9ECE);

              if (reponseSelectionnee != null) {
                if (estCorrecte) {
                  couleurBouton = Colors.green;
                } else if (option == reponseSelectionnee) {
                  couleurBouton = Colors.red;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
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
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 18),
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