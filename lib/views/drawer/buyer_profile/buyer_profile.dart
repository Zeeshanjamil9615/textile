import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/models/buyer_details_response.dart';
import 'package:textile/views/drawer/buyer_profile/buyer_profile_controller.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class BuyerProfilePage extends StatefulWidget {
  const BuyerProfilePage({Key? key}) : super(key: key);

  static const String routeName = '/buyer-profile';

  @override
  State<BuyerProfilePage> createState() => _BuyerProfilePageState();
}

class _BuyerProfilePageState extends State<BuyerProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final buyerName = Get.arguments as String? ?? '';
    if (!Get.isRegistered<BuyerProfileController>(tag: buyerName)) {
      Get.put(BuyerProfileController(buyerName: buyerName), tag: buyerName);
    }
    final controller = Get.find<BuyerProfileController>(tag: buyerName);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4A9B9B)),
          );
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchDetails(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A9B9B),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        final d = controller.details.value;
        if (d == null) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: () => controller.fetchDetails(),
          color: const Color(0xFF4A9B9B),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileSection(profile: d.buyerProfile, worth: d.buyerWorth),
                const SizedBox(height: 20),
                _SuppliersSection(suppliers: d.suppliers),
                const SizedBox(height: 20),
                _ProductCategoriesSection(categories: d.productCategories),
                const SizedBox(height: 20),
                _AddBuyerButton(),
                const SizedBox(height: 24),
                _TransactionsSection(transactions: d.transactions),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final BuyerProfile profile;
  final BuyerWorth worth;

  const _ProfileSection({required this.profile, required this.worth});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D7373),
              ),
            ),
            const SizedBox(height: 12),
            _ProfileRow(label: 'Address', value: profile.address.isEmpty ? 'NA' : profile.address),
            _ProfileRow(label: 'Email', value: profile.email.isEmpty ? 'NA' : profile.email),
            _ProfileRow(label: 'City', value: profile.city.isEmpty ? 'NA' : profile.city),
            _ProfileRow(label: 'Country', value: profile.country),
            _ProfileRow(label: 'Contact', value: profile.contact.isEmpty ? 'NA' : profile.contact),
            const Divider(height: 24),
            _ProfileRow(
              label: 'Buyer\'s Worth',
              value: '${worth.currency} ${worth.totalFc.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),
            if (profile.latlong.isNotEmpty)
              _ProfileRow(label: 'Map', value: profile.latlong),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ProfileRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuppliersSection extends StatelessWidget {
  final List<String> suppliers;

  const _SuppliersSection({required this.suppliers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Supplier(s)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D7373),
          ),
        ),
        const SizedBox(height: 8),
        if (suppliers.isEmpty)
          const Text('No suppliers', style: TextStyle(color: Colors.grey, fontSize: 13))
        else
          ...suppliers.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9B9B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${e.key + 1}) ${e.value}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D7373),
                    ),
                  ),
                ),
              )),
      ],
    );
  }
}

class _ProductCategoriesSection extends StatelessWidget {
  final List<String> categories;

  const _ProductCategoriesSection({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D7373),
          ),
        ),
        const SizedBox(height: 8),
        if (categories.isEmpty)
          const Text('No categories', style: TextStyle(color: Colors.grey, fontSize: 13))
        else
          ...categories.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${e.key + 1}) ${e.value}',
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              )),
      ],
    );
  }
}

class _AddBuyerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Add to folder flow if needed
        },
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Add Buyer', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D7373),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _TransactionsSection extends StatelessWidget {
  final List<BuyerTransactionItem> transactions;

  const _TransactionsSection({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D7373),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4A9B9B).withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${transactions.length} records',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D7373)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          const Text('No transactions', style: TextStyle(color: Colors.grey, fontSize: 13))
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final t = transactions[index];
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A9B9B).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '#${t.id}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2D7373)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t.date,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.exporter,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      if (t.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          t.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text('Qty: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(t.qty, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 16),
                          const Text('Value: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            t.valueFc,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
