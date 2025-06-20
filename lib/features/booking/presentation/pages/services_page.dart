import 'package:flutter/material.dart';
import 'package:ride_hail/features/booking/presentation/widgets/services/services_card.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final services = [
    ServicesCard(
      title: 'Buggy Ride',
      subTitle:
          'You can use our driverless Buggies for all your transport needs within a Campus',
      image: 'assets/images/buggy-ride.png',
    ),
    ServicesCard(
      title: 'Tow Truck',
      subTitle:
          'You can use our driverless tow trucks to transport items weighing upto 25 KGS',
      image: 'assets/images/transport-truck.png',
    ),
    ServicesCard(
      title: 'Bot Delivery',
      subTitle:
          'You can use our driverless tow trucks to transport items weighing upto 12 KGS',
      image: 'assets/images/bot.png',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Services',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Go Anywhere, Get Anything',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Expanded(
                child:
                    isPortrait
                        ? ListView.separated(
                          itemCount: services.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 16.0),
                          itemBuilder: (context, index) => services[index],
                          physics: NeverScrollableScrollPhysics(),
                        )
                        : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16.0,
                                crossAxisSpacing: 16.0,
                                childAspectRatio: 3 / 2,
                              ),
                          itemCount: services.length,
                          itemBuilder: (context, index) => services[index],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
