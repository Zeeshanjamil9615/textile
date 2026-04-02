import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/models/buyer_details_response.dart';
import 'package:textile/models/seller_details_model.dart';
import 'package:textile/api_service/local_storage_service.dart';
import 'package:textile/widgets/custom_snackbar.dart';
import 'package:textile/views/drawer/buyer_profile/buyer_profile_controller.dart';
import 'package:textile/widgets/custom_app_bar.dart';
import 'package:textile/widgets/folder_selection_bottom_sheet.dart';

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
      appBar: const CustomAppBar(
        title: 'DETAIL PAGE',
        showBack: true,
      ),
      backgroundColor: const Color(0xFFF4F6F9),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4A9B9B)),
          );
        }
        final d = controller.details.value;
        final seller = controller.sellerDetails.value;

        if (controller.errorMessage.value.isNotEmpty &&
            d == null &&
            seller == null) {
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

        if (d != null) {
          return RefreshIndicator(
            onRefresh: () => controller.fetchDetails(),
            color: const Color(0xFF4A9B9B),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileSection(profile: d.buyerProfile, worth: d.buyerWorth),
                  const SizedBox(height: 16),
                  _SuppliersSection(suppliers: d.suppliers),
                  const SizedBox(height: 16),
                  _BuyerProductCategoriesSection(categories: d.productCategories),
                  const SizedBox(height: 16),
                  _AddBuyerCard(buyerName: d.buyerProfile.name),
                  const SizedBox(height: 20),
                  _TransactionsSection(transactions: d.transactions),
                ],
              ),
            ),
          );
        }

        if (seller != null) {
          // Extra safety: only allow seller view for users with 8SP permission
          // If user somehow navigated here without permission, show a friendly message
          LocalStorageService.getUserData().then((user) {
            final canViewSellers = user?.hasPermission('8SP') ?? false;
            if (!canViewSellers) {
              CustomSnackbar.warning(
                'Your account does not have access to seller details.',
                title: 'Access restricted',
              );
              Get.back();
            }
          });

          return RefreshIndicator(
            onRefresh: () => controller.fetchDetails(),
            color: const Color(0xFF4A9B9B),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SellerProfileSection(seller: seller),
                  const SizedBox(height: 20),
                  _SellerBuyersSection(buyers: seller.buyersList),
                  const SizedBox(height: 20),
                  _SellerProductCategoriesSection(rows: seller.productCategoryRows),
                  const SizedBox(height: 20),
                  _SellerCountriesSection(countries: seller.sellingCountries),
                  const SizedBox(height: 24),
                  _SellerTransactionsSection(transactions: seller.transactions),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      }),
    );
  }
}

String _sellerWebsiteDisplay(String raw) {
  final w = raw.trim();
  if (w.isEmpty) return 'NA';
  if (w.toLowerCase().startsWith('http://') || w.toLowerCase().startsWith('https://')) {
    return w;
  }
  return 'https://$w';
}

class _SellerProfileSection extends StatelessWidget {
  final SellerDetails seller;

  const _SellerProfileSection({required this.seller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final websiteText = seller.website.isEmpty ? 'NA' : _sellerWebsiteDisplay(seller.website);
    final pkrLine = seller.formattedTotalValue.isNotEmpty
        ? seller.formattedTotalValue
        : (seller.totalValuePkr.isNotEmpty ? seller.totalValuePkr : '');
    final pkrDetail = seller.totalValuePkr.isNotEmpty && seller.formattedTotalValue.isNotEmpty
        ? 'PKR ${seller.totalValuePkr}'
        : '';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF2D7373),
            child: Text(
              seller.importer.isEmpty ? 'Seller' : seller.importer,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileRow(
                  label: 'Address',
                  value: seller.address.isEmpty ? 'NA' : seller.address,
                ),
                _ProfileRow(
                  label: 'Email',
                  value: seller.email.trim().isEmpty ? 'NA' : seller.email.trim(),
                ),
                _ProfileRow(
                  label: 'City',
                  value: seller.city.isEmpty ? 'NA' : seller.city,
                ),
                _ProfileRow(
                  label: 'Country',
                  value: seller.country.isEmpty ? 'NA' : seller.country,
                ),
                _ProfileRow(
                  label: 'Contact',
                  value: seller.contactNumber.trim().isEmpty ? 'NA' : seller.contactNumber.trim(),
                ),
                _ProfileRow(
                  label: 'Website',
                  value: websiteText,
                ),
                if (pkrLine.isNotEmpty) ...[
                  const Divider(height: 20),
                  _ProfileRow(
                    label: 'Total value (PKR)',
                    value: pkrLine,
                    valueColor: Colors.green,
                  ),
                  if (pkrDetail.isNotEmpty && pkrDetail != pkrLine)
                    Padding(
                      padding: const EdgeInsets.only(left: 110, bottom: 8),
                      child: Text(
                        pkrDetail,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                ],
                if (seller.latlong.isNotEmpty)
                  _ProfileRow(label: 'Map', value: seller.latlong),
              ],
            ),
          ),
        ],
      ),
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
    final name = profile.name.isEmpty ? 'Buyer' : profile.name;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF2D7373),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Importer profile',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileRow(
                  label: 'Address',
                  value: profile.address.isEmpty ? 'Not available' : profile.address,
                ),
                _ProfileRow(
                  label: 'Email',
                  value: profile.email.isEmpty ? 'Not available' : profile.email,
                ),
                _ProfileRow(
                  label: 'City',
                  value: profile.city.isEmpty ? 'Not available' : profile.city,
                ),
                _ProfileRow(
                  label: 'Country',
                  value: profile.country.isEmpty ? 'Not available' : profile.country,
                ),
                _ProfileRow(
                  label: 'Contact',
                  value: profile.contact.isEmpty ? 'Not available' : profile.contact,
                ),
                const Divider(height: 22),
                _ProfileRow(
                  label: 'Total import value',
                  value: '${worth.currency} ${worth.totalFc.toStringAsFixed(2)}',
                  valueColor: const Color(0xFF1B7F5A),
                ),
                if (profile.latlong.isNotEmpty)
                  _ProfileRow(label: 'Location / map', value: profile.latlong),
              ],
            ),
          ),
        ],
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
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE9EEF2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9B9B).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.local_shipping_outlined, size: 20, color: Color(0xFF2D7373)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suppliers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D7373),
                        ),
                      ),
                      Text(
                        'Exporters linked to this buyer',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (suppliers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No suppliers listed for this buyer.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              )
            else
              ...suppliers.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE9EEF2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${e.key + 1}.',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D7373),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              e.value,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class _BuyerProductCategoriesSection extends StatelessWidget {
  final List<String> categories;

  const _BuyerProductCategoriesSection({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE9EEF2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9B9B).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.category_outlined, size: 20, color: Color(0xFF2D7373)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product categories',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D7373),
                        ),
                      ),
                      Text(
                        'HS / product types this buyer imports',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (categories.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No product categories listed.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              )
            else
              ...categories.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE9EEF2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${e.key + 1}.',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D7373),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              e.value,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

/// Seller API: category name + PCT code (matches web table).
class _SellerProductCategoriesSection extends StatelessWidget {
  final List<SellerProductCategoryRow> rows;

  const _SellerProductCategoriesSection({required this.rows});

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
        if (rows.isEmpty)
          const Text('No categories', style: TextStyle(color: Colors.grey, fontSize: 13))
        else
          ...rows.asMap().entries.map((e) {
            final r = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE9EEF2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${e.key + 1}) ',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D7373),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.categoryName.isEmpty ? '—' : r.categoryName,
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                          if (r.pctCode.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A9B9B).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'PCT ${r.pctCode}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D7373),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _SellerCountriesSection extends StatelessWidget {
  final List<String> countries;

  const _SellerCountriesSection({required this.countries});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selling Countries',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D7373),
          ),
        ),
        const SizedBox(height: 8),
        if (countries.isEmpty)
          const Text('No countries', style: TextStyle(color: Colors.grey, fontSize: 13))
        else
          ...countries.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${e.key + 1}) ${e.value}',
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ),
      ],
    );
  }
}

class _AddBuyerCard extends StatelessWidget {
  final String buyerName;

  const _AddBuyerCard({required this.buyerName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE9EEF2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9B9B).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.folder_special_outlined, size: 20, color: Color(0xFF2D7373)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Save to folder',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D7373),
                        ),
                      ),
                      Text(
                        'Add this importer to a folder to track them later.',
                        style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showFolderSelectionBottomSheet(
                    context,
                    importerName: buyerName,
                  );
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add buyer to folder', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D7373),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4A9B9B).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.history_edu_outlined, size: 20, color: Color(0xFF2D7373)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D7373),
                    ),
                  ),
                  Text(
                    '${transactions.length} import record${transactions.length == 1 ? '' : 's'}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9EEF2)),
            ),
            child: const Text(
              'No transactions on file for this buyer.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          )
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Color(0xFFE9EEF2)),
                ),
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
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D7373),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t.date,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F4F4),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF4A9B9B).withOpacity(0.35),
                                ),
                              ),
                              child: _TxMini(
                                    label: 'Quantity',
                                    value: t.qty.isEmpty ? '—' : t.qty,
                                    alignEnd: true,
                                  ),
                            ),
                          ],
                        
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Supplier',
                        style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        t.exporter.isEmpty ? '—' : t.exporter,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      if (t.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Product',
                          style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.35),
                        ),
                      ],
                      const SizedBox(height: 10),
                      
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

class _SellerBuyersSection extends StatelessWidget {
  final List<SellerBuyerItem> buyers;

  const _SellerBuyersSection({required this.buyers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Buyer(s)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D7373),
          ),
        ),
        const SizedBox(height: 8),
        if (buyers.isEmpty)
          const Text('No buyers', style: TextStyle(color: Colors.grey, fontSize: 13))
        else
          ...buyers.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A9B9B).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${e.key + 1}) ${e.value.importer}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D7373),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4A9B9B).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      e.value.country.trim(),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2D7373),
                                      ),
                                    ),
                                  ),
                                  if (e.value.productCategory.isNotEmpty)
                                    Text(
                                      e.value.productCategory,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  if (e.value.pctCode.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F4F4),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFF4A9B9B).withOpacity(0.35),
                                        ),
                                      ),
                                      child: Text(
                                        'PCT ${e.value.pctCode}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D7373),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            showFolderSelectionBottomSheet(
                              context,
                              importerName: e.value.importer,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D7373),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Add Buyer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class _TxMini extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;
  final Color? valueColor;
  final FontWeight? valueWeight;

  const _TxMini({
    required this.label,
    required this.value,
    this.alignEnd = false,
    this.valueColor,
    this.valueWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: valueWeight ?? FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }
}

class _SellerTransactionsSection extends StatelessWidget {
  final List<SellerTransactionItem> transactions;

  const _SellerTransactionsSection({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'History',
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D7373),
                ),
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
              final currencyLabel = t.currencyName.isNotEmpty
                  ? t.currencyName
                  : (t.currencyCode.isNotEmpty ? t.currencyCode : '');
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFFE9EEF2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A9B9B).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '#${t.id}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D7373),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.importer,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (t.country.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Country: ${t.country.trim()}',
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                      if (t.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Product: ${t.description}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            height: 1.35,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _TxMini(
                                    label: 'Currency',
                                    value: currencyLabel.isEmpty ? '—' : currencyLabel,
                                  ),
                                ),
                                Expanded(
                                  child: _TxMini(
                                    label: 'Unit price',
                                    value: t.unitPrice.isEmpty ? '—' : t.unitPrice,
                                    alignEnd: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _TxMini(
                                    label: 'Quantity',
                                    value: t.quantity.isEmpty ? '—' : t.quantity,
                                  ),
                                ),
                                Expanded(
                                  child: _TxMini(
                                    label: 'Total FC',
                                    value: t.valueFc.isEmpty ? '—' : t.valueFc,
                                    alignEnd: true,
                                    valueColor: Colors.green,
                                    valueWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (t.pctCode.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'PCT ${t.pctCode}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D7373),
                          ),
                        ),
                      ],
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
