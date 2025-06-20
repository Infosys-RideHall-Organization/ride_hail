import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_hail/core/theme/app_palette.dart';

import '../../../bloc/stage/booking_stage_cubit.dart';

class BookingConfirmedWidget extends StatefulWidget {
  const BookingConfirmedWidget({super.key});

  @override
  State<BookingConfirmedWidget> createState() => _BookingConfirmedWidgetState();
}

class _BookingConfirmedWidgetState extends State<BookingConfirmedWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<BookingStageCubit>().nextStage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16.0,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Center(
              child: Image.asset(
                'assets/images/booking-confirmed.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            'Booking Confirmed',

            style: TextStyle(
              color: AppPalette.primaryColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
