import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:smarthome/utils/aqi_helper.dart';
import 'package:smarthome/widgets/animations/particle_background.dart';
import 'package:smarthome/widgets/dashboard/main_aqi_card.dart';
import 'package:smarthome/widgets/dashboard/metric_card.dart';
import 'package:smarthome/widgets/dashboard/ai_status_card.dart';
import 'package:smarthome/widgets/dashboard/risk_alert_banner.dart';
import 'package:smarthome/widgets/dashboard/floating_bottom_nav.dart';

import 'package:smarthome/screens/tabs/analytics_screen.dart';
import 'package:smarthome/screens/tabs/devices_screen.dart';
import 'package:smarthome/screens/tabs/alerts_screen.dart';
import 'package:smarthome/screens/tabs/profile_screen.dart';
import 'package:smarthome/utils/notification_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;

  double _currentAqi = 30; // Starts in GOOD state

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeController.forward();
    
    // Check Notification Perms silently after layout builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        NotificationHelper.checkInitialLaunchPermission(context);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _simulateAqiChange() {
    setState(() {
      if (_currentAqi <= 50) {
        _currentAqi = 85;
      } else if (_currentAqi <= 100) {
        _currentAqi = 145;
      } else if (_currentAqi <= 150) {
        _currentAqi = 180;
      } else if (_currentAqi <= 200) {
        _currentAqi = 250;
      } else {
        _currentAqi = 30;
      }
    });
  }

  // Generate plausible looking trend arrays
  List<double> _generateTrend(double baseVal, double volatility, int items) {
    final Random rg = Random();
    return List.generate(items, (index) => baseVal + (rg.nextDouble() - 0.5) * volatility);
  }

  Widget _buildDashboard(AqiDetails details) {
    return FadeTransition(
      opacity: _fadeController,
      child: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
        physics: const BouncingScrollPhysics(),
        children: [
          MainAqiCard(aqiValue: _currentAqi),
          const SizedBox(height: 24),

          // Show Risk Alert dynamically
          if (_currentAqi > 100) ...[
            RiskAlertBanner(
              label: _currentAqi > 200 ? 'Hazardous Carbon Monoxide' : 'High PM2.5 / CO2',
              insight: details.insight,
            ),
            const SizedBox(height: 24),
          ],

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.95, // Shorter cards
            children: [
              MetricCard(
                iconWidget: FaIcon(FontAwesomeIcons.wind, size: 16, color: details.baseColor),
                title: 'PM2.5',
                valueText: _currentAqi <= 50 ? '12' : (_currentAqi * 0.4).toStringAsFixed(0),
                unit: 'µg/m³',
                statusText: details.label,
                statusColor: details.baseColor,
                sparklineData: _generateTrend(_currentAqi <= 50 ? 12 : _currentAqi * 0.4, 5, 20),
              ),
              MetricCard(
                iconWidget: FaIcon(FontAwesomeIcons.cloudMeatball, size: 16, color: details.baseColor),
                title: 'CO2',
                valueText: _currentAqi <= 50 ? '540' : (500 + _currentAqi * 3).toStringAsFixed(0),
                unit: 'ppm',
                statusText: details.label,
                statusColor: details.baseColor,
                sparklineData: _generateTrend(_currentAqi <= 50 ? 540 : 500 + _currentAqi * 3, 50, 20),
              ),
              MetricCard(
                iconWidget: FaIcon(FontAwesomeIcons.flask, size: 16, color: details.baseColor),
                title: 'VOCs',
                valueText: _currentAqi <= 50 ? '0.1' : (0.1 + (_currentAqi / 200)).toStringAsFixed(2),
                unit: 'mg/m³',
                statusText: details.label,
                statusColor: details.baseColor,
                sparklineData: _generateTrend(_currentAqi <= 50 ? 0.1 : 0.1 + (_currentAqi / 200), 0.05, 20),
              ),
              MetricCard(
                iconWidget: const Icon(Icons.water_drop_outlined, size: 16, color: Color(0xFF5CCB82)),
                title: 'Humidity',
                valueText: '45',
                unit: '%',
                statusText: 'Ideal',
                statusColor: const Color(0xFF5CCB82),
                sparklineData: _generateTrend(45, 3, 20),
              ),
              MetricCard(
                iconWidget: const Icon(Icons.thermostat_outlined, size: 16, color: Color(0xFFFFA726)),
                title: 'Temp',
                valueText: '22',
                unit: '°C',
                statusText: 'Normal',
                statusColor: const Color(0xFFFFA726),
                sparklineData: _generateTrend(22, 1, 20),
              ),
              MetricCard(
                iconWidget: FaIcon(FontAwesomeIcons.smog, size: 16, color: details.baseColor),
                title: 'PM10',
                valueText: _currentAqi <= 50 ? '18' : (_currentAqi * 0.5).toStringAsFixed(0),
                unit: 'µg/m³',
                statusText: details.label,
                statusColor: details.baseColor,
                sparklineData: _generateTrend(_currentAqi <= 50 ? 18 : _currentAqi * 0.5, 6, 20),
              ),
            ],
          ),
          const SizedBox(height: 10),

          AiStatusCard(details: details),
        ],
      ),
    );
  }

  List<Color> _getBackgroundGradient(AqiDetails details) {
    if (_currentIndex == 0) return [details.bgColor, Colors.white]; // Dashboard
    if (_currentIndex == 1) return [const Color(0xFFE3F2FD), const Color(0xFFF3E5F5)]; // Analytics
    if (_currentIndex == 2) return [const Color(0xFFF5F7FA), const Color(0xFFE1E8ED)]; // Devices
    if (_currentIndex == 3) return [const Color(0xFFFFCDD2), const Color(0xFFFFE0B2)]; // Alerts
    if (_currentIndex == 4) return [const Color(0xFFFAFAFA), const Color(0xFFEEEEEE)]; // Profile
    return [Colors.white, Colors.white];
  }

  Color _getNavBarActiveColor(AqiDetails details) {
    if (_currentIndex == 1) return const Color(0xFF7E57C2);
    if (_currentIndex == 2) return const Color(0xFF455A64);
    if (_currentIndex == 3) return const Color(0xFFD32F2F);
    if (_currentIndex == 4) return const Color(0xFF757575);
    return details.baseColor;
  }

  @override
  Widget build(BuildContext context) {
    final AqiDetails details = AqiHelper.resolveAqi(_currentAqi);

    final List<Widget> screens = [
      _buildDashboard(details),
      const AnalyticsScreen(),
      const DevicesScreen(),
      const AlertsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // 1. Dynamic Gradient Base
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getBackgroundGradient(details),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // 2. Futuristic Particles Layer (Only on Dashboard)
          if (_currentIndex == 0)
            ParticleBackground(
              particleColor: details.baseColor,
              count: 40,
            ),
            
          // 3. Foreground Tab Logic
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Minimal Header
                if (_currentIndex == 0 || _currentIndex == 4)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Smart Home Air',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _currentIndex == 1 || _currentIndex == 3 ? Colors.black87 : const Color(0xFF2C3E50),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Screen Content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: screens[_currentIndex],
                  ),
                ),
              ],
            ),
          ),
          
          // Debug AQI Simulator Toggle
          if (_currentIndex == 0)
            Positioned(
              left: 20,
              bottom: 110,
              child: FloatingActionButton.extended(
                onPressed: _simulateAqiChange,
                backgroundColor: details.baseColor,
                icon: const Icon(Icons.air, color: Colors.white),
                label: const Text('Simulate AI', style: TextStyle(color: Colors.white)),
              ),
            ),
            
          // Floating Bottom Nav Layer
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingBottomNav(
              currentIndex: _currentIndex,
              onTap: _onBottomNavTapped,
              activeColor: _getNavBarActiveColor(details),
            ),
          ),
        ],
      ),
    );
  }
}
