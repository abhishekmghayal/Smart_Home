import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../devices/add_device_flow.dart';
import '../devices/device_control_screen.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  // Global shared styles
  final Color _bgCardColor = Colors.white;
  final BorderRadius _cardRadius = BorderRadius.circular(32);
  final List<BoxShadow> _cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04), 
      blurRadius: 24,
      offset: const Offset(0, 10),
    )
  ];
  
  final Color actionBlue = const Color(0xFF387CFF);

  // Device States
  bool _fanState = true;
  final String _fanSpeed = 'Medium';
  
  bool _bulbState = true;
  double _bulbOpacity = 0.9;
  
  bool _purifierState = true;
  final String _purifierMode = 'Auto';
  
  bool _acState = false;
  final String _acMode = 'Cool';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Inherits global HomeScreen gradient if present
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT COLUMN
                  Expanded(
                    child: Column(
                      children: [
                        _buildAddDeviceButton(),
                        const SizedBox(height: 16),
                        _buildAirQualityCard(),
                        const SizedBox(height: 16),
                        _buildWifiRouterCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Gap between columns
                  // RIGHT COLUMN
                  Expanded(
                    child: Column(
                      children: [
                        _buildSmartFanCard(),
                        const SizedBox(height: 16),
                        _buildSmartLedBulbCard(),
                        const SizedBox(height: 16),
                        _buildACCard(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // BOTTOM SPANNER
              _buildAirPurifierCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddDeviceButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDeviceFlow()),
          );
        },
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36),
          decoration: BoxDecoration(
            color: actionBlue,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: actionBlue.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: actionBlue, size: 28),
              ),
              const SizedBox(height: 12),
              const Text(
                "Add New\nDevice",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAirQualityCard() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceControlScreen(deviceName: "Air Quality Monitor", location: "Living Room", type: DeviceType.airQuality))),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: _cardRadius,
          border: Border.all(color: const Color(0xFF86EFAC).withValues(alpha: 0.4), width: 1.5),
          boxShadow: _cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 24, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Air Quality\nMonitor", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.2)),
                  const SizedBox(height: 6),
                  Text("Living Room", style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("92", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF166534), height: 1.0)),
                      const SizedBox(width: 4),
                      const Text("AQI", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF166534))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text("Good", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF15803D))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 90,
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32))),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Icon(Icons.analytics_outlined, size: 80, color: const Color(0xFF22C55E).withValues(alpha: 0.15)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWifiRouterCard() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceControlScreen(deviceName: "WIFI Router", location: "Hallway", type: DeviceType.router))),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: _bgCardColor, borderRadius: _cardRadius, boxShadow: _cardShadow),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 24, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("WIFI Router", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text("TP-Link", style: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.wifi, color: Colors.green, size: 16),
                      const SizedBox(width: 6),
                      Text("Connected", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 100,
              padding: const EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Icon(Icons.router_outlined, size: 70, color: Colors.grey.shade200),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSmartFanCard() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceControlScreen(deviceName: "Smart Fan", location: "Living Room", type: DeviceType.fan))),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: _bgCardColor, borderRadius: _cardRadius, boxShadow: _cardShadow),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Smart\nFan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.2)),
                  const SizedBox(height: 60), 
                  Row(
                    children: [
                      Text("Speed: ", style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                      Text(_fanSpeed, style: TextStyle(fontSize: 13, color: actionBlue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: Text("Living Room", style: TextStyle(fontSize: 13, color: Colors.grey.shade400, fontWeight: FontWeight.w500))),
                      SizedBox(
                        height: 26,
                        child: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: _fanState,
                            activeTrackColor: actionBlue,
                            onChanged: (v) => setState(() => _fanState = v),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: -10,
              top: 40,
              child: Icon(Icons.mode_fan_off_outlined, size: 90, color: Colors.grey.shade200),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartLedBulbCard() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceControlScreen(deviceName: "Smart LED Bulb", location: "Living Room", type: DeviceType.bulb))),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: _bgCardColor, borderRadius: _cardRadius, boxShadow: _cardShadow),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 24, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Smart LED\nBulb", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.2)),
                      const SizedBox(height: 6),
                      Text("Living Room", style: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _bulbState,
                        activeTrackColor: actionBlue,
                        onChanged: (v) => setState(() => _bulbState = v),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Icon(
                Icons.lightbulb, 
                size: 90, 
                color: _bulbState ? Colors.amber.withValues(alpha: _bulbOpacity) : Colors.grey.shade300
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Brightness: ${(_bulbOpacity * 100).toInt()}%", style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 12,
                  activeTrackColor: actionBlue,
                  inactiveTrackColor: actionBlue.withValues(alpha: 0.15),
                  thumbColor: Colors.white,
                  overlayColor: actionBlue.withValues(alpha: 0.2),
                  trackShape: const RoundedRectSliderTrackShape(),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 2),
                ),
                child: Slider(
                  value: _bulbOpacity,
                  onChanged: _bulbState ? (v) => setState(() => _bulbOpacity = v) : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildACCard() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceControlScreen(deviceName: "Air Conditioner", location: "Bedroom", type: DeviceType.ac))),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: _bgCardColor, borderRadius: _cardRadius, boxShadow: _cardShadow),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Air\nConditioner", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.2)),
                  Icon(Icons.ac_unit, color: _acState ? Colors.blue : Colors.grey.shade300, size: 30),
                ],
              ),
              const SizedBox(height: 6),
              Text("Bedroom", style: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("24°C", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text("Mode: $_acMode", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                  SizedBox(
                    height: 26,
                    child: Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: _acState,
                        activeTrackColor: Colors.blue,
                        onChanged: (v) => setState(() => _acState = v),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAirPurifierCard() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceControlScreen(deviceName: "Air Purifier", location: "Bedroom", type: DeviceType.purifier))),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: _bgCardColor, borderRadius: _cardRadius, boxShadow: _cardShadow),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Air Purifier", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87)),
                        const SizedBox(height: 6),
                        Text("Bedroom", style: TextStyle(fontSize: 15, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 20), 
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _purifierState ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, size: 14, color: _purifierState ? Colors.green : Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    _purifierState ? "Filtering Air" : "Standby",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _purifierState ? Colors.green : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text("Mode: $_purifierMode", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(_purifierState ? "ON" : "OFF", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 20,
                              child: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: _purifierState,
                                  activeTrackColor: actionBlue,
                                  onChanged: (v) => setState(() => _purifierState = v),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: Icon(Icons.mode_fan_off, size: 90, color: Colors.grey.shade200),
            )
          ],
        ),
      ),
    );
  }
}
