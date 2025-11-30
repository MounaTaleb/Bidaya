import 'package:flutter/material.dart';
import '../../models/math_model.dart';

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

  @override
  void initState() {
    super.initState();
    _genererQuestions();
  }

  void _genererQuestions() {
    // Prendre 5 questions pour le niveau actuel
    int startIndex = (widget.niveau - 1) * 5;
    int endIndex = startIndex + 5;

    if (endIndex > problemesMath.length) {
      endIndex = problemesMath.length;
    }

    questions = problemesMath.sublist(startIndex, endIndex);
  }

  void _verifierReponse(int reponse) {
    final bool estCorrecte = reponse == questions[questionActuelle].reponseCorrecte;

    setState(() {
      reponseSelectionnee = true;
      reponseChoisie = reponse;

      if (estCorrecte) {
        score++;
        messageFeedback = '🎉 أحسنت! الإجابة صحيحة 🎉';
        couleurMessage = Colors.green;
      } else {
        messageFeedback = '❌ الإجابة خاطئة. الإجابة الصحيحة هي: ${questions[questionActuelle].reponseCorrecte}';
        couleurMessage = Colors.red;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (questionActuelle < questions.length - 1) {
        setState(() {
          questionActuelle++;
          reponseSelectionnee = null;
          reponseChoisie = null;
          messageFeedback = null;
        });
      } else {
        widget.onNiveauTermine(score);
        Navigator.pop(context);

        showDialog(
          context: context,
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
                color: score >= 3 ? Colors.green : Colors.orange,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  score >= 3
                      ? 'لقد نجحت في هذا المستوى!'
                      : 'لم تحقق النتيجة المطلوبة',
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
                    color: const Color(0xFFE8F5E8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF4CAF50)),
                  ),
                  child: Text(
                    'النتيجة: $score/5',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
                if (score < 3)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'يجب أن تحصل على 3/5 على الأقل للانتقال للمستوى التالي',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text(
                    'حسنا',
                    style: TextStyle(fontSize: 16),
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
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          ),
        ),
      );
    }

    final question = questions[questionActuelle];

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E8),
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

            LinearProgressIndicator(
              value: (questionActuelle + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(10),
              minHeight: 12,
            ),

            const SizedBox(height: 30),

            if (messageFeedback != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: couleurMessage.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: couleurMessage.withOpacity(0.3),
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

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
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

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: question.options.map<Widget>((option) {
                  bool estCorrecte = option == question.reponseCorrecte;
                  Color couleurBouton = const Color(0xFF4CAF50);
                  Color couleurTexte = Colors.white;

                  if (reponseSelectionnee != null) {
                    if (estCorrecte) {
                      couleurBouton = Colors.green;
                    } else if (option == reponseChoisie) {
                      couleurBouton = Colors.red;
                    } else {
                      couleurBouton = Colors.grey;
                      couleurTexte = Colors.black54;
                    }
                  }

                  return ElevatedButton(
                    onPressed: reponseSelectionnee == null
                        ? () => _verifierReponse(option)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: couleurBouton,
                      foregroundColor: couleurTexte,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: couleurBouton.withOpacity(0.5),
                    ),
                    child: Text(
                      '$option',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: couleurTexte,
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