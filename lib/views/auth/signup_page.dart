import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/auth/signup_controller.dart';
import 'package:textile/widgets/colors.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final isWide = maxWidth > 800;

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 980),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 74,
                            child: Image.asset(
                              'assets/logos/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Textile Analytics',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.3,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create your account to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Shared white card (same style as login)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.96),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x24000000),
                                  blurRadius: 26,
                                  offset: Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Sign up',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColors.primaryDark,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        ),
                                        child: const Text(
                                          'Sign in',
                                          style: TextStyle(fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                                  child: isWide
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: _PersonalDetailsForm(controller: controller)),
                                            const SizedBox(width: 24),
                                            Expanded(child: _CompanyDetailsForm(controller: controller)),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _PersonalDetailsForm(controller: controller),
                                            const SizedBox(height: 24),
                                            _CompanyDetailsForm(controller: controller),
                                          ],
                                        ),
                                ),
                                const Divider(height: 0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  child: Obx(
                                    () => SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: controller.isSubmitting.value ? null : controller.submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryDark,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: controller.isSubmitting.value
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                'Create account',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PersonalDetailsForm extends StatelessWidget {
  final SignupController controller;
  const _PersonalDetailsForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal details',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _LabeledField(
          label: 'First Name*',
          hintText: '3 to 12 Characters',
          controller: controller.firstNameController,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'Last Name*',
          hintText: '3 to 12 Characters',
          controller: controller.lastNameController,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'Email*',
          hintText: 'Your Valid Email',
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'Cell No.*',
          hintText: 'for example 03XXXXXXXXX',
          controller: controller.cellController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'Designation',
          hintText: 'Optional',
          controller: controller.designationController,
        ),
      ],
    );
  }
}

class _CompanyDetailsForm extends StatelessWidget {
  final SignupController controller;
  const _CompanyDetailsForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Company Details',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _LabeledField(
          label: 'Company name*',
          hintText: 'Company Name',
          controller: controller.companyNameController,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'NTN No.',
          hintText: 'Optional',
          controller: controller.ntnController,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'Office Address',
          hintText: 'Optional',
          controller: controller.officeAddressController,
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'City*',
          hintText: 'Your City',
          controller: controller.cityController,
        ),
        const SizedBox(height: 12),
        const Text(
          'Country*',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.selectedCountry.value.isEmpty
                ? null
                : controller.selectedCountry.value,
            decoration: InputDecoration(
              hintText: 'Select Country',
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE9EEF2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE9EEF2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: controller.countries
                .map(
                  (country) => DropdownMenuItem<String>(
                    value: country,
                    child: Text(
                      country,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedCountry.value = value;
              }
            },
            icon: controller.isLoadingCountries.value
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  const _LabeledField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE9EEF2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE9EEF2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}

