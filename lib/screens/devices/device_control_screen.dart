import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum DeviceType { airQuality, purifier, ac, fan, bulb, router }

class DeviceControlScreen extends StatefulWidget {
  final String deviceName;
  final String location;
  final DeviceType type;

  const DeviceControlScreen({
    super.key,
    required this.deviceName,
    required this.location,
    required this.type,
  });

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  // Global Device Status
  bool _isPowerOn = true;
  final Color actionBlue = const Color(0xFF387CFF);

  // Sub-metrics specific to devices
  double _bulbBrightness = 90;
  String _fanSpeed = "Medium";
  String _purifierMode = "Auto";
  int _acTemp = 24;
  String _acMode = "Cool";
  String _acFan = "Low";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              _buildHeader(),
              const SizedBox(height: 32),

              // 2. Main Connectivity Switch (Except for Monitor, usually always on)
              if (widget.type != DeviceType.airQuality) _buildPowerModule(),
              if (widget.type == DeviceType.airQuality) _buildMonitorConnectivity(),
              const SizedBox(height: 24),

              // 3. Dynamic Hardware Controls
              _buildDynamicControls(),
              const SizedBox(height: 24),

              // 4. Standardized Usage Stats
              _buildUsageStats(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.deviceName,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              widget.location,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPowerModule() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Power Status",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isPowerOn ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isPowerOn ? "ON (Connected)" : "OFF (Offline)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _isPowerOn ? Colors.green.shade700 : Colors.grey.shade600,
                    ),
                  ),
                ],
              )
            ],
          ),
          Transform.scale(
            scale: 0.9,
            child: CupertinoSwitch(
              value: _isPowerOn,
              activeTrackColor: actionBlue,
              onChanged: (v) => setState(() => _isPowerOn = v),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMonitorConnectivity() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.wifi, color: Colors.green, size: 16),
              const SizedBox(width: 6),
              const Text("Online", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUsageStats() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt, color: Colors.orange.shade400),
              const SizedBox(width: 8),
              const Text(
                "Usage Today",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.type == DeviceType.router ? "24h 00m running today" : "3h 20m used today",
            style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: widget.type == DeviceType.router ? 10 : 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: actionBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Expanded(flex: widget.type == DeviceType.router ? 0 : 7, child: const SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- DYNAMIC RENDERING CONTROLLER ---- //
  Widget _buildDynamicControls() {
    switch (widget.type) {
      case DeviceType.airQuality:
        return _buildAirQualityEngine();
      case DeviceType.purifier:
        return _buildPurifierEngine();
      case DeviceType.ac:
        return _buildACEngine();
      case DeviceType.fan:
        return _buildFanEngine();
      case DeviceType.bulb:
        return _buildBulbEngine();
      case DeviceType.router:
        return _buildRouterEngine();
    }
  }

  // 1. Air Quality Module
  Widget _buildAirQualityEngine() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green.shade200, width: 2),
      ),
      child: Column(
        children: [
          const Text("Live AQI Reading", style: TextStyle(color: Colors.green)),
          const SizedBox(height: 10),
          Text("92", style: TextStyle(fontSize: 70, fontWeight: FontWeight.w900, color: Colors.green.shade800, height: 1)),
          const Text("Status: Good", style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          // Generic placeholder for a chart
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16)
            ),
            child: const Center(child: Icon(Icons.analytics, size: 50, color: Colors.green)),
          )
        ],
      ),
    );
  }

  // 2. Air Purifier
  Widget _buildPurifierEngine() {
    return Column(
      children: [
        AbsorbPointer(
          absorbing: !_isPowerOn,
          child: Opacity(
            opacity: _isPowerOn ? 1.0 : 0.5,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Device Mode", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ["Auto", "Eco", "Turbo"].map((m) {
                      final active = _purifierMode == m;
                      return GestureDetector(
                        onTap: () => setState(() => _purifierMode = m),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: active ? actionBlue : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(m, style: TextStyle(color: active ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Row(
            children: [
              Icon(Icons.air, color: Colors.green.shade400),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Air Quality Output", style: TextStyle(fontSize: 14)),
                  Text("Good / Filtering Base", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  // 3. Air Conditioner (AC)
  Widget _buildACEngine() {
    return AbsorbPointer(
      absorbing: !_isPowerOn,
      child: Opacity(
        opacity: _isPowerOn ? 1.0 : 0.4,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text("Target Temperature", style: TextStyle(fontSize: 15, color: Colors.grey)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _acTemp--),
                        icon: const Icon(Icons.remove_circle_outline, size: 40, color: Colors.grey),
                      ),
                      const SizedBox(width: 24),
                      Text("$_acTemp°", style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w900)),
                      const SizedBox(width: 24),
                      IconButton(
                        onPressed: () => setState(() => _acTemp++),
                        icon: Icon(Icons.add_circle_outline, size: 40, color: actionBlue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Mode", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => setState(() => _acMode = _acMode == "Cool" ? "Auto" : "Cool"),
                          child: Text(_acMode, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: actionBlue)),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Fan", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => setState(() => _acFan = _acFan == "Low" ? "High" : "Low"),
                          child: Text(_acFan, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: actionBlue)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 4. Smart Fan
  Widget _buildFanEngine() {
    return AbsorbPointer(
      absorbing: !_isPowerOn,
      child: Opacity(
        opacity: _isPowerOn ? 1.0 : 0.4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Fan Speed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["Low", "Medium", "High"].map((s) {
                  final active = _fanSpeed == s;
                  return GestureDetector(
                    onTap: () => setState(() => _fanSpeed = s),
                    child: Container(
                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                       decoration: BoxDecoration(
                         color: active ? actionBlue : Colors.grey.shade100,
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Text(s, style: TextStyle(color: active ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 5. LED Bulb
  Widget _buildBulbEngine() {
    return AbsorbPointer(
      absorbing: !_isPowerOn,
      child: Opacity(
        opacity: _isPowerOn ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Brightness", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("${_bulbBrightness.toInt()}%", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: actionBlue)),
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 8,
                  activeTrackColor: actionBlue,
                  inactiveTrackColor: Colors.grey.shade200,
                  thumbColor: actionBlue,
                ),
                child: Slider(
                  value: _bulbBrightness,
                  min: 0,
                  max: 100,
                  onChanged: (v) => setState(() => _bulbBrightness = v),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 6. WIFI Router
  Widget _buildRouterEngine() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Signal Strength", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.signal_wifi_4_bar, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text("Excellent", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {}, // Simulated restart
              icon: const Icon(Icons.restart_alt, color: Colors.redAccent),
              label: const Text("Restart Router", style: TextStyle(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
