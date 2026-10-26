import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  // Predefined Alerts Mock Data
  final List<Map<String, dynamic>> _alerts = [
    {
      "id": "1",
      "type": "critical",
      "title": "High CO2 Detected",
      "desc": "Air quality is dangerous in Living Room",
      "time": "2 min ago",
      "icon": Icons.warning_amber_rounded,
      "color": const Color(0xFFEF4444), // Red
    },
    {
      "id": "2",
      "type": "warning",
      "title": "Temperature Rising",
      "desc": "Room temperature is climbing above normal parameters",
      "time": "15 min ago",
      "icon": Icons.thermostat,
      "color": const Color(0xFFF59E0B), // Yellow/Orange
    },
    {
      "id": "3",
      "type": "success",
      "title": "Smart Fan Connected",
      "desc": "Smart Fan connected successfully",
      "time": "1 hr ago",
      "icon": Icons.check_circle_outline,
      "color": const Color(0xFF10B981), // Green
    },
    {
      "id": "4",
      "type": "info",
      "title": "System Update",
      "desc": "Device firmware settings updated successfully.",
      "time": "3 hrs ago",
      "icon": Icons.info_outline,
      "color": const Color(0xFF3B82F6), // Blue
    },
    {
      "id": "5",
      "type": "warning",
      "title": "Network Instability",
      "desc": "WIFI Router signal dropped momentarily.",
      "time": "Yesterday",
      "icon": Icons.wifi_off,
      "color": const Color(0xFFF59E0B), // Yellow/Orange
    },
  ];

  void _removeAlert(String id) {
    setState(() {
      _alerts.removeWhere((alert) => alert["id"] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ultra-minimal Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Text(
                "Alerts",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            
            // List / Empty State
            Expanded(
              child: _alerts.isEmpty ? _buildEmptyState() : _buildAlertList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAlertList() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
      itemCount: _alerts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final alert = _alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  // ==========================================
  // SINGLE ALERT CARD UI W/ SWIPE
  // ==========================================
  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final Color baseColor = alert["color"] as Color;
    final bool isCritical = alert["type"] == "critical";

    return Dismissible(
      key: Key(alert["id"] as String),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _removeAlert(alert["id"] as String);
      },
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2), // Very soft red for delete background
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(CupertinoIcons.trash, color: Color(0xFFEF4444)),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isCritical ? Border.all(color: baseColor.withValues(alpha: 0.5), width: 1.5) : null,
          boxShadow: [
            BoxShadow(
              color: isCritical ? baseColor.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.04),
              blurRadius: isCritical ? 24 : 16,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Details handler
            },
            borderRadius: BorderRadius.circular(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isCritical ? 18.5 : 20),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left accent border logic
                    Container(
                      width: isCritical ? 6 : 4,
                      decoration: BoxDecoration(
                        color: baseColor,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(isCritical ? 24 : 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon mapping
                            Container(
                              padding: EdgeInsets.all(isCritical ? 14 : 12),
                              decoration: BoxDecoration(
                                color: baseColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                alert["icon"] as IconData,
                                color: baseColor,
                                size: isCritical ? 28 : 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Body 
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          alert["title"] as String,
                                          style: TextStyle(
                                            fontSize: isCritical ? 18 : 16,
                                            fontWeight: isCritical ? FontWeight.w900 : FontWeight.w700,
                                            color: Colors.black87,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        alert["time"] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    alert["desc"] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      height: 1.4,
                                      fontWeight: isCritical ? FontWeight.w500 : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // EMPTY STATE
  // ==========================================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                 BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 40)
              ]
            ),
            child: Icon(CupertinoIcons.bell_slash, size: 60, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 24),
          const Text(
            "No alerts",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
