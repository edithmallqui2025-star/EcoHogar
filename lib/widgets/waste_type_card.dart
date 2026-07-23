import 'package:flutter/material.dart';
import 'package:eco_hogar/models/recycling_model.dart';

/// Tarjeta para seleccionar tipo de residuo
class WasteTypeCard extends StatefulWidget {
  final WasteType wasteType;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;

  const WasteTypeCard({
    Key? key,
    required this.wasteType,
    required this.isSelected,
    required this.onTap,
    this.size = 80,
  }) : super(key: key);

  @override
  State<WasteTypeCard> createState() => _WasteTypeCardState();
}

class _WasteTypeCardState extends State<WasteTypeCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isSelected
                ? const Color(0xFF2ECC71)
                : const Color(0xFFECF0F1),
            width: widget.isSelected ? 3 : 2,
          ),
          color: widget.isSelected
              ? const Color(0xFF2ECC71).withOpacity(0.1)
              : const Color(0xFFFFFFFF),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF2ECC71).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.wasteType.icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              widget.wasteType.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: widget.isSelected
                    ? const Color(0xFF2ECC71)
                    : const Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
