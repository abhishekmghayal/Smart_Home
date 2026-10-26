import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smarthome/widgets/dashboard/sparkline_graph.dart';

class MetricCard extends StatefulWidget {
  final Widget iconWidget;
  final String title;
  final String valueText;
  final String unit;
  final String statusText;
  final Color statusColor;
  final List<double> sparklineData;

  const MetricCard({
    super.key,
    required this.iconWidget,
    required this.title,
    required this.valueText,
    required this.unit,
    required this.statusText,
    required this.statusColor,
    required this.sparklineData,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onEnter() {
    setState(() => _isHovered = true);
    _animationController.forward();
  }

  void _onExit() {
    setState(() => _isHovered = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTapDown: (_) => _onEnter(),
        onTapUp: (_) => _onExit(),
        onTapCancel: () => _onExit(),
        onTap: () {},
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(160),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered ? widget.statusColor.withAlpha(200) : Colors.white.withAlpha(100),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: [
                    if (_isHovered)
                      BoxShadow(
                        color: widget.statusColor.withAlpha(50),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(150),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: widget.iconWidget,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.more_horiz, size: 18, color: Colors.grey.shade400),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.valueText,
                                style: const TextStyle(
                                  fontSize: 18, // Reduced
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2C3E50),
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Text(
                                  widget.unit,
                                  style: TextStyle(
                                    fontSize: 11, // Reduced
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 6, // Reduced
                                height: 6, // Reduced
                                decoration: BoxDecoration(
                                  color: widget.statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.statusText,
                                style: TextStyle(
                                  fontSize: 11, // Reduced
                                  fontWeight: FontWeight.bold,
                                  color: widget.statusColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SparklineGraph(
                        data: widget.sparklineData,
                        color: widget.statusColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

