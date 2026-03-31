import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/models/filtered_denim_list_response.dart';
import 'package:textile/views/drawer/textile_importers/buyer_model.dart';
import 'package:textile/widgets/folder_selection_bottom_sheet.dart';
import 'package:textile/views/drawer/add_folder/add_folder_controller.dart';

class BuyerCard extends StatelessWidget {
  final BuyerModel buyer;
  final ScrollController? scrollController;
  final int? index;
  
  const BuyerCard({
    Key? key, 
    required this.buyer,
    this.scrollController,
    this.index,
  }) : super(key: key);

  void _scrollToCard(BuildContext context) {
    if (scrollController != null && index != null) {
      // Use Scrollable.ensureVisible to scroll the card into view
      final RenderObject? renderObject = context.findRenderObject();
      if (renderObject != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.1, // Position card near top (10% from top)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _scrollToCard(context),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A9B9B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(buyer.id, 
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4A9B9B))),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(buyer.importerName, 
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _DetailRow(icon: Icons.category, label: 'Importer', value: buyer.importerName),
              const SizedBox(height: 8),
              _DetailRow(icon: Icons.flag, label: 'Country', value: buyer.country),
              
              
              
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!Get.isRegistered<AddFolderController>()) {
                      Get.put(AddFolderController());
                    }
                    showFolderSelectionBottomSheet(
                      context,
                      importerName: buyer.importerName,
                      product: buyer.productCategory,
                      buyerType: 'DenimList',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D7373),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Add Buyer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
  
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          label + ': ',
          style: const TextStyle(
              fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// Card for Search Denim list (FilteredDenimListItem).
class DenimCard extends StatelessWidget {
  final FilteredDenimListItem item;
  final int index;

  const DenimCard({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9B9B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A9B9B)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.importer,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _DetailRow(
                icon: Icons.business,
                label: 'Importer',
                value: item.importer),
            const SizedBox(height: 8),
            _DetailRow(
                icon: Icons.flag, label: 'Country', value: item.country),
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              _DetailRow(
                  icon: Icons.description,
                  label: 'Product Name',
                  value: item.description),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (Get.isRegistered<AddFolderController>()) {
                    Get.find<AddFolderController>();
                  } else {
                    Get.put(AddFolderController());
                  }
                  showFolderSelectionBottomSheet(
                    context,
                    importerName: item.importer,
                    product: item.description,
                    buyerType: 'DenimMadeup',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D7373),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                    'Add Buyer',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}