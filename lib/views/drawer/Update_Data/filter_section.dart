import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Email_Importers_City_Wise/Email_Importers_City_Wise_controller.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmailImportersCityWiseController>();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          const Text('Filter by Country: ', style: TextStyle(fontSize: 14)),
          Obx(() => DropdownButton<String>(
            value: controller.selectedCountry.value,
            items: controller.countries.map((country) {
              return DropdownMenuItem(
                value: country,
                child: Text(country),
              );
            }).toList(),
            onChanged: controller.updateCountryFilter,
          )),
          const SizedBox(width: 16),
          const Text('Search City: ', style: TextStyle(fontSize: 14)),
          
          Expanded(
            child: TextField(
              onChanged: controller.updateCityFilter,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFF4A9B9B), width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}