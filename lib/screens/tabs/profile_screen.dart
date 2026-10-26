import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/screens/profile/edit_profile_screen.dart';
import 'package:smarthome/utils/notification_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _avatarGlowController;

  // Mock Settings State
  bool _aiPredictionsEnabled = true;
  bool _autoSuggestionsEnabled = true;
  int _alertSensitivityIndex = 1; // 0: Low, 1: Med, 2: High

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
    _avatarGlowController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to disconnect your Smart Home session?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Execute logout functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
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

  Widget _buildAvatarHeader() {
    return Column(
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
                  // Use a placeholder network image, or replace with asset if available
                  image: NetworkImage("https://ui-avatars.com/api/?name=Alex+Carter&background=random&size=200"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Icon(Icons.edit, size: 16, color: Color(0xFF2C3E50)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Alex Carter",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Air Quality Monitor User",
            style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return _buildGlassCard(
      child: Column(
        children: [
          _buildInfoRow(Icons.email_outlined, "alex.carter@smarthome.com"),
          const Divider(height: 24, color: Colors.black12),
          _buildInfoRow(Icons.public, "United States"),
          const Divider(height: 24, color: Colors.black12),
          _buildInfoRow(Icons.location_on_outlined, "124 Smart Ave, Silicon Valley"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 22),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Color(0xFF2C3E50), fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildSmartHomeSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Smart Home Summary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSummaryChip("5", "Devices", Icons.router_outlined, Colors.blue),
            _buildSummaryChip("Good", "AQI Status", Icons.air, Colors.green),
            _buildSummaryChip("0", "Alerts", Icons.notifications_active_outlined, Colors.redAccent),
          ],
        ),
        const SizedBox(height: 12),
        _buildGlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Last Sync:", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
              Text("Just Now", style: TextStyle(color: Color(0xFF2C3E50), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryChip(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(180),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(50)),
          boxShadow: [BoxShadow(color: color.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Usage Insights",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildBadge("🏆 Healthy Air Maintainer", "5 consecutive days"),
              const SizedBox(width: 12),
              _buildBadge("🌟 Early Adopter", "Version 1.0"),
              const SizedBox(width: 12),
              _buildBadge("🌿 Eco-Friendly", "Low VOC footprint"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5CCB82), Color(0xFF00B4DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF5CCB82).withAlpha(60), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildAiPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.auto_awesome, color: Color(0xFF7E57C2), size: 22),
            SizedBox(width: 8),
            Text(
              "AI Preferences",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildGlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SwitchListTile(
                value: _aiPredictionsEnabled,
                activeTrackColor: const Color(0xFF7E57C2).withAlpha(100),
                activeThumbColor: const Color(0xFF7E57C2),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                title: const Text("Enable AI Predictions", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text("Allow AI to forecast air quality"),
                onChanged: (val) => setState(() => _aiPredictionsEnabled = val),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20, color: Colors.black12),
              SwitchListTile(
                value: _autoSuggestionsEnabled,
                activeTrackColor: const Color(0xFF7E57C2).withAlpha(100),
                activeThumbColor: const Color(0xFF7E57C2),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                title: const Text("Auto Suggestions", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text("Actionable steps for air maintenance"),
                onChanged: (val) => setState(() => _autoSuggestionsEnabled = val),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20, color: Colors.black12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Alert Sensitivity", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoSegmentedControl<int>(
                        selectedColor: const Color(0xFF7E57C2),
                        borderColor: const Color(0xFF7E57C2),
                        padding: EdgeInsets.zero,
                        groupValue: _alertSensitivityIndex,
                        children: const {
                          0: Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text("Low")),
                          1: Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text("Medium")),
                          2: Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text("High")),
                        },
                        onValueChanged: (val) => setState(() => _alertSensitivityIndex = val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsList() {
    return _buildGlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildSettingsTile(Icons.person_outline, "Edit Profile", onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
            );
          }),
          const Divider(height: 1, indent: 56, color: Colors.black12),
          _buildSettingsTile(Icons.devices_other_outlined, "Manage Devices"),
          const Divider(height: 1, indent: 56, color: Colors.black12),
          _buildSettingsTile(Icons.notifications_outlined, "Notification Settings", onTap: () {
            NotificationHelper.showSettingsPermissionDialog(context);
          }),
          const Divider(height: 1, indent: 56, color: Colors.black12),
          _buildSettingsTile(Icons.privacy_tip_outlined, "Privacy Policy"),
          const Divider(height: 1, indent: 56, color: Colors.black12),
          _buildSettingsTile(Icons.help_outline, "Help & Support"),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3E50).withAlpha(15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF2C3E50)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
      onTap: onTap ?? () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 120),
      children: [
        _buildAvatarHeader(),
        const SizedBox(height: 32),
        _buildUserInfo(),
        const SizedBox(height: 32),
        _buildSmartHomeSummary(),
        const SizedBox(height: 32),
        _buildAchievements(),
        const SizedBox(height: 32),
        _buildAiPreferences(),
        const SizedBox(height: 32),
        _buildSettingsList(),
        const SizedBox(height: 48),
        
        // Logout Button
        ElevatedButton(
          onPressed: _showLogoutDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.redAccent,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 20),
              SizedBox(width: 8),
              Text("Logout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
