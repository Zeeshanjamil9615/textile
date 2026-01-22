import 'package:flutter/material.dart';
import 'package:textile/views/drawer/textile_importers/buyer_model.dart';

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
              _DetailRow(icon: Icons.flag, label: 'Country', value: buyer.country),
              const SizedBox(height: 8),
              _DetailRow(icon: Icons.category, label: 'Product Category', value: buyer.productCategory),
              const SizedBox(height: 8),
              _DetailRow(icon: Icons.attach_money, label: 'Total Value', 
                value: '\$${buyer.buyersWorth.toStringAsFixed(2)}', valueColor: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getRankingColor(String ranking) {
    switch (ranking.toLowerCase()) {
      case 'high': return Colors.green;
      case 'medium': return Colors.orange;
      case 'low': return Colors.red;
      default: return Colors.grey;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  
  const _DetailRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label + ': ', style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 13, color: valueColor ?? Colors.black87, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}