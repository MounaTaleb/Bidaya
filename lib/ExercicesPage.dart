import 'package:flutter/material.dart';

class ExercicesPage extends StatelessWidget {
  const ExercicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFDE7), Color(0xFFE3F2FD), Color(0xFFFFF5F9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'التمارين اليومية 💪',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildExerciceCard(
                      '✍️',
                      'تمرين الكتابة',
                      'تعلم كتابة الحروف',
                      Colors.blue,
                      '15 دقيقة',
                    ),
                    const SizedBox(height: 15),
                    _buildExerciceCard(
                      '🧮',
                      'تمرين الحساب',
                      'حل مسائل الرياضيات',
                      Colors.green,
                      '20 دقيقة',
                    ),
                    const SizedBox(height: 15),
                    _buildExerciceCard(
                      '🗣️',
                      'تمرين النطق',
                      'تحسين مهارات النطق',
                      Colors.orange,
                      '10 دقائق',
                    ),
                    const SizedBox(height: 15),
                    _buildExerciceCard(
                      '🧠',
                      'تمرين الذاكرة',
                      'ألعاب تقوية الذاكرة',
                      Colors.purple,
                      '25 دقيقة',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciceCard(
    String emoji,
    String title,
    String subtitle,
    Color color,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 35)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.access_time, size: 14, color: color),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
