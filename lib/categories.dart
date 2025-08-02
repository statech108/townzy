import 'package:flutter/material.dart';
import 'package:townzy/tailoring.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Temporary category data
    final List<Map<String, dynamic>> categories = [
      {"icon": Icons.content_cut, "label": "Tailoring", "color": Colors.purple},
      {"icon": Icons.local_pharmacy, "label": "Pharmacy", "color": Colors.green},
      {"icon": Icons.shopping_basket, "label": "Groceries", "color": Colors.orange},
      {"icon": Icons.local_laundry_service, "label": "Laundry", "color": Colors.blue},
      {"icon": Icons.restaurant, "label": "Food", "color": Colors.red},
      {"icon": Icons.medical_services, "label": "Medical", "color": Colors.teal},
      {"icon": Icons.home_repair_service, "label": "Services", "color": Colors.brown},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryButton(
              icon: category["icon"],
              label: category["label"],
              color: category["color"],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(
            icon,
            color: color,
            size: 36,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Colors.grey[800]),
        ),
      ],
    );
  }
}
