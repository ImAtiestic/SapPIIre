import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // The total height of the bar area including the "pop out" QR icon
    return Container(
      height: 110, 
      color: Colors.transparent, // Background of the screen shows through
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // The actual Dark Blue Bar
          Container(
            height: 85,
            decoration: const BoxDecoration(
              color: Color(0xFF0A1E5E), // The specific dark navy in your image
              border: Border(
                top: BorderSide(color: Color.fromARGB(188, 255, 255, 255), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Index 0: Manage Info
                Expanded(
                  child: _navItem(0, HugeIcons.strokeRoundedUser, "Manage Information"),
                ),
                // Space for the QR code in the middle
                const Expanded(
                  child: SizedBox(),
                ),
                // Index 2: Fill History
                Expanded(
                  child: _navItem(2, HugeIcons.strokeRoundedClock01, "Fill History"),
                ),
              ],
            ),
          ),
          
          // The QR Code Button (Positioned to pop out)
          Positioned(
            top: 0, // Moves it up relative to the dark bar
            child: _qrNavItem(1),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, List<List<dynamic>> icon, String label) {
    bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              // The "pill" shape for active state
              color: isActive ? const Color(0xFF4A69D4) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: HugeIcon(
              icon: icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _qrNavItem(int index) {
    bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF4A69D4) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedQrCode,
              color: isActive ? Colors.white : const Color(0xFF1A358F),
              size: 35,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "AutoFill QR",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}