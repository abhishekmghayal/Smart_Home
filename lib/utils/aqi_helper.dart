import 'package:flutter/material.dart';

class AqiDetails {
  final String label;
  final String title;
  final String insight;
  final String aiPrediction;
  final Color baseColor;
  final Color bgColor;

  const AqiDetails({
    required this.label,
    required this.title,
    required this.insight,
    required this.aiPrediction,
    required this.baseColor,
    required this.bgColor,
  });
}

class AqiHelper {
  static AqiDetails resolveAqi(double aqi) {
    if (aqi <= 50) {
      // Good
      return const AqiDetails(
        label: "GOOD",
        title: "Excellent",
        insight: "Air quality is excellent. Safe to keep windows open.",
        aiPrediction: "Stability expected for 6+ hours.",
        baseColor: Color(0xFF5CCB82), // Green
        bgColor: Color(0xFFE8F5E9),
      );
    } else if (aqi <= 100) {
      // Moderate
      return const AqiDetails(
        label: "MODERATE",
        title: "Fair",
        insight: "Air quality is acceptable. Consider keeping windows closed during rush hour.",
        aiPrediction: "Slight decrease in quality expected by evening.",
        baseColor: Color(0xFFFFCA28), // Yellow/Light Green
        bgColor: Color(0xFFFFF8E1),
      );
    } else if (aqi <= 150) {
      // Unhealthy for Sensitive
      return const AqiDetails(
        label: "POOR",
        title: "Unhealthy",
        insight: "Poor air quality detected. Limit outdoor activities for sensitive groups.",
        aiPrediction: "Pollution levels rising. Expected to persist for hours.",
        baseColor: Color(0xFFFFA726), // Orange
        bgColor: Color(0xFFFFF3E0),
      );
    } else if (aqi <= 200) {
      // Unhealthy
      return const AqiDetails(
        label: "WARNING",
        title: "Dangerous",
        insight: "Air is dangerous. Keep windows closed and start air purifiers immediately.",
        aiPrediction: "High risk zone. Unhealthy conditions overnight.",
        baseColor: Color(0xFFEF5350), // Red
        bgColor: Color(0xFFFFEBEE),
      );
    } else {
      // Hazardous
      return const AqiDetails(
        label: "CRITICAL",
        title: "Hazardous",
        insight: "Hazardous air detected! Evacuate or wear an N95 mask indoors. High CO2 & PM2.5 alarm.",
        aiPrediction: "Severe health warning. Expected to clear slowly.",
        baseColor: Color(0xFFB71C1C), // Dark Red
        bgColor: Color(0xFFFFCDD2), // Soft dark red tint
      );
    }
  }
}
