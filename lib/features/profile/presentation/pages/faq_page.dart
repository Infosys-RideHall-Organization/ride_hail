import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("FAQs")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            "Frequently Asked Questions",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const FAQItem(
            number: 1,
            question: "How do I book a buggy?",
            answer:
                "Open the RideHail app, tap 'Book Now', select your pickup and drop locations, then confirm the booking.",
          ),
          const FAQItem(
            number: 2,
            question: "Can I cancel or reschedule a booking?",
            answer:
                "Yes. Go to 'My Bookings', select the booking, and choose to cancel or reschedule based on availability.",
          ),
          const FAQItem(
            number: 3,
            question: "Why is no buggy available right now?",
            answer:
                "Buggy availability depends on demand, weather, and operations. Please try again shortly.",
          ),
          const FAQItem(
            number: 4,
            question: "What if I miss my ride?",
            answer:
                "Missed rides cannot be refunded. Please ensure you're at the pickup point 5 minutes early.",
          ),
          const FAQItem(
            number: 5,
            question: "Is the service available on weekends?",
            answer:
                "Service hours may vary on weekends or holidays. Check the app for the latest schedule.",
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final int number;
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.number,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number. $question",
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppPalette.primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(answer, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
