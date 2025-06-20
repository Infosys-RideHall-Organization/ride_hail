import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_hail/core/common/widgets/toast.dart';
import 'package:ride_hail/features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toggle_list/toggle_list.dart';

import '../../../../../../core/theme/app_palette.dart';
import '../../../../domain/entities/booking/booking.dart'; // make sure this has VehicleType enum
import '../../../../domain/enums/vehicle_type.dart';
import '../../../bloc/stage/booking_stage_cubit.dart';
import '../outlined_button.dart';

class PassengersWidget extends StatelessWidget {
  const PassengersWidget({super.key});

  void _showAddPassengerDialog(
    BuildContext context,
    List<Passenger> passengers,
  ) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final companyController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Add Passenger'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: AppPalette.primaryColor),
                    ),
                  ),
                  TextField(
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(color: AppPalette.primaryColor),
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: AppPalette.primaryColor),
                    ),
                  ),
                  TextField(
                    controller: companyController,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      labelStyle: TextStyle(color: AppPalette.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newPassenger = Passenger(
                    name: nameController.text,
                    phoneNo: phoneController.text,
                    email: emailController.text,
                    companyName: companyController.text,
                  );
                  final updated = List<Passenger>.from(passengers)
                    ..add(newPassenger);
                  context.read<BookingBloc>().add(UpdatePassengers(updated));
                  Navigator.pop(ctx);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showAddWeightDialog(BuildContext context, List<WeightItem> weights) {
    final itemController = TextEditingController();
    final weightController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Add Weight Item'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: itemController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                  ),
                  TextField(
                    controller: weightController,
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newItem = WeightItem(
                    name: itemController.text,
                    weight: double.tryParse(weightController.text) ?? 0.0,
                  );
                  final updated = List<WeightItem>.from(weights)..add(newItem);
                  context.read<BookingBloc>().add(UpdateWeights(updated));
                  Navigator.pop(ctx);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final passengers = state.passengers;
        final weights = state.weightItems;
        final vehicleTypeEnum = VehicleTypeExtension.fromString(
          state.vehicleType ?? '',
        );
        final isBuggy = vehicleTypeEnum == VehicleType.buggy;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isBuggy) ...[
                  const Text(
                    'No. of Passengers',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (passengers.isNotEmpty) {
                            final updated = List<Passenger>.from(passengers)
                              ..removeLast();
                            context.read<BookingBloc>().add(
                              UpdatePassengers(updated),
                            );
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.minus,
                          color: AppPalette.primaryColor,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_2_outlined,
                            color: AppPalette.whiteColor,
                            size: 32,
                          ),
                          const SizedBox(width: 8),
                          Text(passengers.length.toString()),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          if (passengers.length < 3) {
                            _showAddPassengerDialog(context, passengers);
                          } else {
                            showToast(
                              context: context,
                              type: ToastificationType.error,
                              description:
                                  'The buggy is limited to 3 seats per user booking',
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.add,
                          color: AppPalette.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if (passengers.isNotEmpty)
                    ToggleList(
                      viewPadding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      children:
                          passengers.asMap().entries.map((entry) {
                            final index = entry.key;
                            final p = entry.value;
                            return ToggleListItem(
                              expandedHeaderDecoration: BoxDecoration(
                                color: AppPalette.lightBlackColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              headerDecoration: BoxDecoration(
                                color: AppPalette.lightBlackColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                child: Text(
                                  'Passenger #${index + 1}',
                                  style: const TextStyle(
                                    color: AppPalette.whiteColor,
                                  ),
                                ),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextField(
                                      controller: TextEditingController(
                                        text: p.name,
                                      ),
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 12),

                                    const Text(
                                      'Phone',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      p.phoneNo,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 12),

                                    const Text(
                                      'Email',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      p.email,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 12),

                                    const Text(
                                      'Company',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      p.companyName,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                ],

                if (!isBuggy) ...[
                  const Text('Weights', style: TextStyle(fontSize: 24.0)),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 48),
                      Row(
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            color: AppPalette.whiteColor,
                            size: 32,
                          ),
                          const SizedBox(width: 8),
                          Text(weights.length.toString()),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          if (weights.length < 3) {
                            _showAddWeightDialog(context, weights);
                          } else {
                            showToast(
                              context: context,
                              type: ToastificationType.error,
                              description:
                                  'Maximum 3 weight items allowed per booking',
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.add,
                          color: AppPalette.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if (weights.isNotEmpty)
                    ToggleList(
                      viewPadding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      children:
                          weights.asMap().entries.map((entry) {
                            final index = entry.key;
                            final w = entry.value;
                            return ToggleListItem(
                              expandedHeaderDecoration: BoxDecoration(
                                color: AppPalette.lightBlackColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              headerDecoration: BoxDecoration(
                                color: AppPalette.lightBlackColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                child: Text(
                                  'Item #${index + 1}',
                                  style: const TextStyle(
                                    color: AppPalette.whiteColor,
                                  ),
                                ),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _detailField('Item', w.name),
                                    _detailField(
                                      'Weight (kg)',
                                      w.weight.toStringAsFixed(2),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                ],

                const SizedBox(height: 24.0),
                Center(
                  child: CustomOutlinedButton(
                    onPressed: () {
                      if (isBuggy && passengers.isEmpty) {
                        showToast(
                          context: context,
                          type: ToastificationType.error,
                          description: 'Add at least one passenger',
                        );
                        return;
                      }
                      if (!isBuggy && weights.isEmpty) {
                        showToast(
                          context: context,
                          type: ToastificationType.error,
                          description: 'Add at least one weight item',
                        );
                        return;
                      }
                      context.read<BookingStageCubit>().nextStage();
                    },
                    buttonName: 'Next',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
