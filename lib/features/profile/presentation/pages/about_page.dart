import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About RideHail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "RideHail – Your Smart Campus Buggy Companion",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "RideHail is the official buggy booking app designed exclusively for Infosys employees and visitors to simplify transportation within the Infosys campus. Whether you're commuting between buildings, heading to your training center, or moving across the expansive campus, RideHail ensures a smooth, convenient, and eco-friendly ride experience.\n\n"
              "With a user-friendly interface and real-time tracking, the app allows you to easily book, manage, and monitor your buggy rides right from your mobile device. Say goodbye to long waits and manual booking systems — RideHail brings modern mobility to your fingertips.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              "Key Features",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const FeatureItem(
              emoji: "🛺",
              text:
                  "Instant & Scheduled Bookings – Book rides instantly or reserve them for later.",
            ),
            const FeatureItem(
              emoji: "📍",
              text: "Live Tracking – Track your assigned buggy in real time.",
            ),
            const FeatureItem(
              emoji: "📅",
              text:
                  "Ride History – Access all your past rides and booking details.",
            ),
            const FeatureItem(
              emoji: "🔔",
              text:
                  "Smart Notifications – Stay updated on ride status and arrival alerts.",
            ),
            const FeatureItem(
              emoji: "🌱",
              text:
                  "Eco-Friendly Travel – Promote sustainable commuting within the campus.",
            ),
            const SizedBox(height: 24),
            Text(
              "RideHail is built with Infosys' values of efficiency, innovation, and user-centric design. Make your campus commute smarter — one buggy ride at a time.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String emoji;
  final String text;

  const FeatureItem({super.key, required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
