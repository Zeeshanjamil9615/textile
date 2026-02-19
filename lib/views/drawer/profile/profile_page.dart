import 'package:flutter/material.dart';
import 'package:textile/api_service/local_storage_service.dart';
import 'package:textile/models/user_model.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder<UserModel?>(
        future: LocalStorageService.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4A9B9B),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'No user data found',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final user = snapshot.data!;
          
          // Build full address from available fields
          String fullAddress = user.address;
          if (fullAddress.isEmpty) {
            final addressParts = <String>[];
            if (user.city.isNotEmpty) addressParts.add(user.city);
            if (user.state.isNotEmpty) addressParts.add(user.state);
            if (user.country.isNotEmpty) addressParts.add(user.country);
            fullAddress = addressParts.join(', ');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with breadcrumb
                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF4A9B9B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Company Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Text(' / ', style: TextStyle(color: Colors.grey)),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A9B9B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Profile Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Name
                      _ProfileField(
                        label: 'Company Name',
                        value: user.company.isNotEmpty ? user.company : 'N/A',
                      ),
                      const SizedBox(height: 20),
                      
                      // Email
                      _ProfileField(
                        label: 'Email',
                        value: user.email.isNotEmpty ? user.email : 'N/A',
                      ),
                      const SizedBox(height: 20),
                      
                      // Phone No
                      _ProfileField(
                        label: 'Phone No',
                        value: user.phone.isNotEmpty ? user.phone : 'N/A',
                      ),
                      const SizedBox(height: 20),
                      
                      // User Name
                      _ProfileField(
                        label: 'User Name',
                        value: user.fullName.isNotEmpty ? user.fullName : 'N/A',
                      ),
                      const SizedBox(height: 20),
                      
                      // Address
                      _ProfileField(
                        label: 'Address',
                        value: fullAddress.isNotEmpty ? fullAddress : 'N/A',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}

