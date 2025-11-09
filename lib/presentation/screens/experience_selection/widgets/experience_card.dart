// lib/presentation/screens/experience_selection/widgets/experience_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/experience_model.dart';
import 'dart:math' as math;

class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final VoidCallback onToggle;
  final int index; // Add index for wave calculation

  const ExperienceCard({
    Key? key,
    required this.experience,
    required this.onToggle,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate vertical offset for wave effect
    final double waveOffset = math.sin(index * 0.5) * 8; // Adjust wave height

    // Painter tuning (pixel-perfect values used previously)
    const double stampWidth = 100;
    const double stampHeight = 110;
    const double cornerRadius = 12.0;
    const double borderWidth = 6.0;
    const double perfRadius = 3.5;
    const double perfSpacing = 13.5;
    const Color borderColor = Colors.white;

    return GestureDetector(
      onTap: onToggle,
      child: Transform.translate(
        offset: Offset(0, waveOffset), // Apply vertical wave offset
        child: Transform.rotate(
          angle: (index % 2 == 0 ? -0.05 : 0.05), // Slight rotation alternating
          child: SizedBox(
            width: stampWidth,
            height: stampHeight,
            child: Stack(
              children: [
                // CustomPaint draws the white perforated border band.
                // We place the inner content (image + overlay + label) as the child,
                // padded by borderWidth so it sits inside the border band.
                CustomPaint(
                  size: const Size(stampWidth, stampHeight),
                  painter: StampBorderPainter(
                    cornerRadius: cornerRadius,
                    borderWidth: borderWidth,
                    perfRadius: perfRadius,
                    perfSpacing: perfSpacing,
                    borderColor: borderColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(borderWidth),
                    child: ClipRRect(
                      // inner radius slightly smaller than outer to fit visually
                      borderRadius: BorderRadius.circular((cornerRadius - borderWidth).clamp(0.0, cornerRadius)),
                      child: ColorFiltered(
                        colorFilter: experience.isSelected
                            ? const ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.multiply,
                              )
                            : const ColorFilter.matrix([
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0, 0, 0, 1, 0,
                              ]),
                        child: Stack(
                          children: [
                            // Background Image
                            Positioned.fill(
                              child: CachedNetworkImage(
                                imageUrl: experience.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: experience.isSelected ? Colors.grey[300] : const Color(0xFF2A2A2A),
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: experience.isSelected ? Colors.grey[300] : const Color(0xFF2A2A2A),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image_outlined,
                                        size: 32,
                                        color: Colors.grey[600],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Dark overlay gradient
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Experience Name Label
                            Positioned(
                              bottom: 6,
                              left: 4,
                              right: 4,
                              child: Text(
                                experience.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: experience.isSelected ? Colors.white : Colors.grey[500],
                                  letterSpacing: 0.8,
                                  height: 1.1,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Optional selected indicator: a faint inner border glow when selected
                if (experience.isSelected)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(cornerRadius - borderWidth),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.12),
                              blurRadius: 6,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Stamp Border Painter with perforated edges and rounded corners
class StampBorderPainter extends CustomPainter {
  final double cornerRadius;
  final double borderWidth;
  final double perfRadius;
  final double perfSpacing;
  final Color borderColor;

  StampBorderPainter({
    this.cornerRadius = 12.0,
    this.borderWidth = 6.0,
    this.perfRadius = 3.5,
    this.perfSpacing = 13.5,
    this.borderColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Outer rounded rect
    final outerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(cornerRadius),
    );

    // Ensure inner rect fits (clamp to avoid negative width/height)
    final innerRadius = (cornerRadius - borderWidth).clamp(0.0, cornerRadius);
    final innerRect = Rect.fromLTWH(
      borderWidth,
      borderWidth,
      (size.width - 2 * borderWidth).clamp(0.0, size.width),
      (size.height - 2 * borderWidth).clamp(0.0, size.height),
    );

    final innerRRect = RRect.fromRectAndRadius(innerRect, Radius.circular(innerRadius));

    // Create the border band by subtracting innerRRect from outerRRect
    final outerPath = Path()..addRRect(outerRRect);
    final innerPath = Path()..addRRect(innerRRect);
    final borderPath = Path.combine(PathOperation.difference, outerPath, innerPath);

    // Build perforations path (circles) inside the band.
    final perforPath = Path();

    // Helper to add circle (hole) at cx, cy
    void addHole(double cx, double cy) {
      perforPath.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: perfRadius));
    }

    // We'll place holes along each straight edge but stop them before the rounded corners.
    final double startX = cornerRadius + perfSpacing / 2;
    final double endX = size.width - cornerRadius - perfSpacing / 2;
    final double startY = cornerRadius + perfSpacing / 2;
    final double endY = size.height - cornerRadius - perfSpacing / 2;
    final double holeInset = borderWidth / 2; // place hole centers halfway through the band

    if (endX > startX) {
      // Top edge (left -> right)
      for (double x = startX; x <= endX; x += perfSpacing) {
        addHole(x, holeInset);
      }

      // Bottom edge (right -> left)
      for (double x = endX; x >= startX; x -= perfSpacing) {
        addHole(x, size.height - holeInset);
      }
    }

    if (endY > startY) {
      // Right edge (top -> bottom)
      for (double y = startY; y <= endY; y += perfSpacing) {
        addHole(size.width - holeInset, y);
      }

      // Left edge (bottom -> top)
      for (double y = endY; y >= startY; y -= perfSpacing) {
        addHole(holeInset, y);
      }
    }

    // Subtract perforations (holes) from border band
    final finalPath = Path.combine(PathOperation.difference, borderPath, perforPath);

    // Draw final border
    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant StampBorderPainter oldDelegate) {
    return oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.perfRadius != perfRadius ||
        oldDelegate.perfSpacing != perfSpacing ||
        oldDelegate.borderColor != borderColor;
  }
}
