import 'dart:ui';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // State
  bool _isSaving = false;
  bool _isPasswordVisible = false;
  bool _hasUnsavedChanges = false;

  // Controllers
  final _nameController = TextEditingController(text: "Alex Carter");
  final _emailController = TextEditingController(text: "alex.carter@smarthome.com");
  final _passwordController = TextEditingController(text: "12345678");
  final _addressController = TextEditingController(text: "124 Smart Ave");
  final _cityController = TextEditingController(text: "Silicon Valley");
  final _stateController = TextEditingController(text: "CA");
  final _zipController = TextEditingController(text: "94000");

  late AnimationController _avatarGlowController;

  @override
  void initState() {
    super.initState();
    _avatarGlowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _avatarGlowController.dispose();
    super.dispose();
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _hasUnsavedChanges = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile successfully updated"),
          backgroundColor: Color(0xFF5CCB82),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    bool? discard = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Matches ProfileScreen dialog radius
          title: const Text("Discard Changes?"),
          content: const Text("You have unsaved edits. Do you want to discard them?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Discard", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
    return discard ?? false;
  }

  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    // Exact match for the Glassmorphism used in ProfileScreen
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(160),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(200), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    bool isPassword = false,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        onChanged: (_) => _markAsChanged(),
        validator: isRequired
            ? (val) => (val == null || val.trim().isEmpty) ? "This field is required" : null
            : null,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2C3E50), fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.normal),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF2C3E50).withAlpha(150), size: 22),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.shade500,
                    size: 22,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                )
              : null,
          filled: true,
          fillColor: Colors.white.withAlpha(150),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withAlpha(200), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withAlpha(200), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF5CCB82), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.redAccent.withAlpha(150), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: const TextStyle(height: 0.8),
        ),
      ),
    );
  }

  Widget _buildAvatarHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _avatarGlowController,
                builder: (context, child) {
                  return Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5CCB82).withAlpha((_avatarGlowController.value * 60 + 20).toInt()),
                          blurRadius: _avatarGlowController.value * 20 + 10,
                          spreadRadius: _avatarGlowController.value * 10,
                        )
                      ],
                    ),
                  );
                },
              ),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5CCB82), Color(0xFF00B4DB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white, width: 4),
                  image: const DecorationImage(
                    image: NetworkImage("https://ui-avatars.com/api/?name=Alex+Carter&background=random&size=200"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 15,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8), // matching edit icon size and style
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: const Icon(Icons.camera_alt, size: 16, color: Color(0xFF2C3E50)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Change Picture",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1976D2)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft background aligning with the Profile Screen contrast
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2C3E50), fontSize: 18)),
        backgroundColor: Colors.white.withAlpha(200),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        leading: BackButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (await _onWillPop()) {
              if (context.mounted) Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: PopScope(
        canPop: !_hasUnsavedChanges,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final bool shouldPop = await _onWillPop();
          if (!context.mounted) return;
          if (shouldPop) {
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            children: [
              _buildAvatarHeader(),
              const SizedBox(height: 40),

              // Glassmorphism Form Match
              _buildGlassCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personal Details",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        controller: _nameController,
                        label: "Full Name",
                        prefixIcon: Icons.person_outline,
                        isRequired: true,
                      ),
                      _buildTextField(
                        controller: _emailController,
                        label: "Email Address",
                        prefixIcon: Icons.email_outlined,
                        isRequired: true,
                      ),
                      _buildTextField(
                        controller: _passwordController,
                        label: "Password",
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        isRequired: true,
                      ),
                      
                      const Divider(height: 32, color: Colors.black12),
                      
                      const Text(
                        "Home Address",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        controller: _addressController,
                        label: "Address Line 1",
                        prefixIcon: Icons.home_outlined,
                        isRequired: true,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _cityController,
                              label: "City",
                              prefixIcon: Icons.location_city_outlined,
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _stateController,
                              label: "State",
                              prefixIcon: Icons.map_outlined,
                              isRequired: true,
                            ),
                          ),
                        ],
                      ),
                      _buildTextField(
                        controller: _zipController,
                        label: "Postal Code",
                        prefixIcon: Icons.local_post_office_outlined,
                        isRequired: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Match Profile Save button style
              ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5CCB82),
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shadowColor: const Color(0xFF5CCB82).withAlpha(100),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
