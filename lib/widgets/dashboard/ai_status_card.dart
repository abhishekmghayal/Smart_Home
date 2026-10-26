import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:smarthome/utils/aqi_helper.dart';

class AiStatusCard extends StatelessWidget {
  final AqiDetails details;

  const AiStatusCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(160),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(200), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: details.baseColor.withAlpha(20),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: details.baseColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'AI Insights',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: details.baseColor,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey.shade400),
                ],
              ),
              const SizedBox(height: 16),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF2C3E50),
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                  child: AnimatedTextKit(
                    key: ValueKey<String>(details.insight), // Re-triggers animation on data change
                    isRepeatingAnimation: false,
                    displayFullTextOnTap: true,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Current Status: Air is ${details.title}.\nPrediction: ${details.aiPrediction}\nSuggestion: ${details.insight}',
                        speed: const Duration(milliseconds: 30),
                        cursor: '▋',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

