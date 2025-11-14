import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepSeekService {
  static const String _apiUrl = 'https://api.deepseek.com/v1/chat/completions';

  Future<String> getEducationalResponse(
    String userQuestion, {
    List<Map<String, dynamic>>? conversationHistory,
  }) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': '''أنت معلم لطيف على شكل أرنب تساعد الأطفال في التعلم.
قواعد مهمة:
- استخدم لغة عربية بسيطة وواضحة للأطفال (4-10 سنوات)
- اجعل الإجابات قصيرة جدًا (2-3 جمل كحد أقصى)
- استخدم الإيموجي في كل إجابة لجعل التعلم ممتعًا
- ركز على المواضيع التعليمية: الألوان، الأرقام، الحيوانات، الحروف، الأشكال
- كن إيجابيًا ومشجعًا دائمًا
- لا تستخدم محتوى غير مناسب للأطفال أبدًا''',
        },
      ];

      // Ajouter l'historique de conversation
      if (conversationHistory != null && conversationHistory.isNotEmpty) {
        messages.addAll(conversationHistory as Iterable<Map<String, String>>);
      }

      // Ajouter la question actuelle
      messages.add({'role': 'user', 'content': userQuestion});

      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'model': 'deepseek-chat',
              'messages': messages,
              'max_tokens': 150,
              'temperature': 0.7,
              'stream': false,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content']
            .toString()
            .trim();
        return reply;
      } else {
        // En cas d'erreur API, utiliser les réponses locales
        print('DeepSeek API Error: ${response.statusCode} - ${response.body}');
        return _getLocalResponse(userQuestion);
      }
    } catch (e) {
      // En cas d'exception, utiliser les réponses locales
      print('DeepSeek Exception: $e');
      return _getLocalResponse(userQuestion);
    }
  }

  String _getLocalResponse(String userQuestion) {
    final String lowerQuestion = userQuestion.toLowerCase();

    if (lowerQuestion.contains('لون') ||
        lowerQuestion.contains('ألوان') ||
        lowerQuestion.contains('الوان')) {
      return 'الألوان رائعة! 🌈\nهناك الأحمر مثل التفاحة 🍎\nوالأزرق مثل السماء 🌤️\nوالأخضر مثل الشجرة 🌳\nما هو لونك المفضل؟ 🎨';
    } else if (lowerQuestion.contains('رقم') ||
        lowerQuestion.contains('أرقام') ||
        lowerQuestion.contains('ارقام')) {
      return 'هيا نعد معًا! 🔢\n١ واحد 🐰\n٢ اثنان 🎈\n٣ ثلاثة 🍎\n٤ أربعة 🚗\n٥ خمسة ⭐\nهل تريد أن تعد أكثر؟';
    } else if (lowerQuestion.contains('حيوان') ||
        lowerQuestion.contains('حيوانات')) {
      return 'أحب الحيوانات! 🦁\nالأسد ملك الغابة 🦁\nالفيل كبير وذكي 🐘\nالأرنب سريع وألطفهم 🐰\nوالزرافة طويلة الرقبة 🦒\nأي حيوان تحب؟';
    } else if (lowerQuestion.contains('حرف') ||
        lowerQuestion.contains('أحرف') ||
        lowerQuestion.contains('احرف')) {
      return 'هيا نتعلم الحروف! 🔤\nأ - أرنب 🐰\nب - بطة 🦆\nت - تفاحة 🍎\nث - ثعبان 🐍\nهذا ممتع، أليس كذلك؟ ✨';
    } else if (lowerQuestion.contains('مرحبا') ||
        lowerQuestion.contains('اهلا') ||
        lowerQuestion.contains('السلام')) {
      return 'مرحبا بك! 👋🐰\nأنا سعيد جدًا لرؤيتك!\nماذا تريد أن تتعلم اليوم؟\nيمكنني تعليمك الألوان، الأرقام، الحيوانات والحروف! 🌟';
    } else if (lowerQuestion.contains('اسمك') ||
        lowerQuestion.contains('من أنت')) {
      return 'أنا الأرنب المعلم! 🐰\nأحب مساعدة الأطفال في التعلم.\nأسألني عن أي شيء تريد معرفته! 📚';
    } else if (lowerQuestion.contains('شكر') ||
        lowerQuestion.contains('تمام')) {
      return 'العفو! 😊🐰\nأنت طفل رائع ومتفهم!\nهل تريد تعلم شيء آخر؟ 🌈';
    } else {
      return 'سؤال جميل! 🤔🐰\nدعنا نتعلم معًا:\n• الألوان 🌈\n• الأرقام ١٢٣🔢\n• الحيوانات 🦁🐘\n• الحروف العربية 🔤\nاختر ما ت veut تعلمه! 💫';
    }
  }
}
