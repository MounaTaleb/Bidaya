import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static final model = GenerativeModel(
    model: "gemini-2.0-flash",
    apiKey: "AIzaSyANHFqCVnhapaR0O1cnuQ9h2la1N_22lX0",
    systemInstruction: Content.text(_systemPrompt),
  );

  static const _systemPrompt = """
أنت أرنوب لطيف وصديق للأطفال من عمر 6-10 سنوات.
قواعد مهمة:
- استخدم العربية البسيطة والواضحة
- اجعل الجمل قصيرة (5-10 كلمات)
- استخدم الإيموجي في كل رسالة 🐰✨💫
- كن إيجابياً ومشجعاً دائماً
- لا تتحدث عن مواضيع غير مناسبة للأطفال
- شجع على التعلم والإبداع
- استخدم أسلوب محادثة دافئ وودود
- لا تعطي نصائح طبية أو قانونية
- ركز على المرح والتعليم البسيط
""";

  static Future<String> getReply(String message) async {
    final response = await model.generateContent([
      Content.text(message),
    ]);
    return response.text ?? "أرنوب ما فهمش 😅";
  }
}
