import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellary/Profile%20Section/User%20Address/user_address_controller.dart';

import '../../Component/show_pop_up.dart';
import '../Add Address/add_address.dart';

class ListOfAddress extends StatefulWidget {
  const ListOfAddress({super.key});

  @override
  State<ListOfAddress> createState() => _ListOfAddressState();
}

class _ListOfAddressState extends State<ListOfAddress> {
  final UserAddressController userAddressController = Get.put(UserAddressController());
  int? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    userAddressController.loadAddresses(); // Load addresses from the controller
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (userAddressController.isLoading.value) {
            return const CircularProgressIndicator();
          }

          final addresses = userAddressController.addresses;

          if (addresses.isEmpty) {
            return const Text(
              "No address available",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            );
          }

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select Address",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),

                  // Dropdown for Address Selection
                  DropdownButton<int>(
                    value: _selectedAddressId,
                    hint: const Text("Select Address"),
                    onChanged: (int? value) {
                      setState(() {
                        _selectedAddressId = value;
                      });
                    },
                    items: addresses.map((address) {
                      final fullAddress = [
                        address['address1'],
                        address['address2'],
                        address['city'],
                        address['state'],
                        address['postal_code'],
                        address['country'],
                      ]
                          .where((element) => element != null && element.isNotEmpty)
                          .join(", ");

                      // Adjusting the text size based on the address length
                      double fontSize = fullAddress.length > 80
                          ? 12.0
                          : fullAddress.length > 60
                          ? 14.0
                          : 16.0;

                      return DropdownMenuItem<int>(
                        value: address['address_id'],
                        child: Text(
                          "Address: $fullAddress",
                          style: TextStyle(fontSize: fontSize),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Ensure text stays on one line
                        ),
                      );
                    }).toList(),
                  ),

                  // Button to add a new address
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the popup
                      PopupDialog(
                        parentContext: context,
                        childWidget: AddAddress(),
                      ).show();
                    },
                    child: const Text("Add New Address"),
                  ),
                  const SizedBox(height: 20.0),

                  // Continue button if an address is selected
                  if (_selectedAddressId != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            if (kDebugMode) {
                              print("Selected Address ID: $_selectedAddressId");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: const Text(
                            "Continue",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
