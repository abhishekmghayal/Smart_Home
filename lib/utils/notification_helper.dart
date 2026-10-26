import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {
  static const String _firstLaunchKey = 'has_seen_notification_prompt';

  // ---------------------------------------------------------------------------
  // APP START (FIRST LAUNCH) FLOW
  // ---------------------------------------------------------------------------
  static Future<void> checkInitialLaunchPermission(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenPrompt = prefs.getBool(_firstLaunchKey) ?? false;

    if (!hasSeenPrompt) {
      // It's the first time so we mark it as seen immediately.
      await prefs.setBool(_firstLaunchKey, true);
      
      // Delay slightly to ensure UI is ready and feels organic
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (context.mounted) {
        _showInitialPermissionDialog(context);
      }
    }
  }

  static void _showInitialPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Force them to interact
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
          title: const Column(
            children: [
              Icon(Icons.notifications_active, color: Color(0xFF5CCB82), size: 40),
              SizedBox(height: 16),
              Text(
                "Enable Notifications",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: const Text(
            "Allow notifications to receive important air quality alerts and smart home updates.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87, fontSize: 15, height: 1.4),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20, top: 10),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Permission.notification.request();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5CCB82),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Allow", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Not Now", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // PROFILE -> NOTIFICATION SETTINGS FLOW
  // ---------------------------------------------------------------------------
  static Future<void> showSettingsPermissionDialog(BuildContext context) async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Notifications are already enabled!"),
          backgroundColor: Color(0xFF5CCB82),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!context.mounted) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
          title: const Column(
            children: [
              Icon(Icons.notifications_outlined, color: Color(0xFF5CCB82), size: 40),
              SizedBox(height: 16),
              Text(
                "Notification Permission",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: const Text(
            "Would you like to enable notifications for air quality alerts and smart home updates?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87, fontSize: 15, height: 1.4),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20, top: 10),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    
                    if (status.isPermanentlyDenied) {
                      // OS has blocked further requests; route to native Settings
                      await openAppSettings();
                    } else {
                      // Trigger System Prompt
                      final result = await Permission.notification.request();
                      if (result.isPermanentlyDenied && context.mounted) {
                        _showManualSettingsPrompt(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5CCB82),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Allow Notifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Notifications disabled"),
                        backgroundColor: Colors.grey.shade800,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Deny", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static void _showManualSettingsPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Permission Blocked"),
          content: const Text("You have previously denied notifications. Please enable them directly via your device Settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5CCB82),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }
}
