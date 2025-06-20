import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

Future<bool?> showTermsAndConditionsDialog({
  required BuildContext context,
  required VoidCallback onAgreed,
}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final width = MediaQuery.sizeOf(context).width;
      final height = MediaQuery.sizeOf(context).height;
      final isPortrait =
          MediaQuery.orientationOf(context) == Orientation.portrait;
      return AlertDialog(
        title: const Text(
          "Booking Terms & Conditions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          height: height * 0.6,
          width: width,
          child: ListView(
            children: [
              TermTile(
                number: "1",
                title: "Valid Booking",
                description:
                    "Buggy rides must be booked through the RideHall app only.",
              ),
              TermTile(
                number: "2",
                title: "Timely Arrival",
                description:
                    "Please arrive at the pickup point 5 minutes before your scheduled ride.",
              ),
              TermTile(
                number: "3",
                title: "Cancellations",
                description:
                    "Frequent last-minute cancellations may affect your future booking privileges.",
              ),
              TermTile(
                number: "4",
                title: "Safety Rules",
                description:
                    "Seatbelts must be worn (if available). Follow all driver instructions for safety.",
              ),
              TermTile(
                number: "5",
                title: "Liability",
                description:
                    "RideHall and Infosys are not responsible for personal belongings lost during the ride.",
              ),
              TermTile(
                number: "6",
                title: "Respectful Conduct",
                description:
                    "Any misconduct towards drivers or co-passengers may result in service suspension.",
              ),
              TermTile(
                number: "7",
                title: "Service Availability",
                description:
                    "Ride availability is subject to demand, weather, and operational conditions.",
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.012),
                child: Text(
                  "By clicking 'Agree' you confirm that you have read and accepted these booking terms.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: isPortrait ? width * 0.04 : width * 0.02,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: onAgreed,
            child: const Text(
              "Agree",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

// Helper widget for each term
class TermTile extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const TermTile({
    super.key,
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppPalette.primaryColor.withAlpha(200),
        child: Text(number, style: const TextStyle(color: Colors.white)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isPortrait ? width * 0.04 : width * 0.02,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: height * 0.01),
        child: Text(
          description,
          style: TextStyle(fontSize: isPortrait ? width * 0.04 : width * 0.02),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: height * 0.01),
    );
  }
}
