import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/milestone_model.dart';

class LifeGrid extends StatelessWidget {
  final int currentMonthIndex;
  final List<MilestoneModel> milestones;

  const LifeGrid({
    super.key,
    required this.currentMonthIndex,
    required this.milestones,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 36;
        const rows = 30;
        final dotSize = (constraints.maxWidth - (columns - 1) * 4) / columns;

        return Column(
          children: List.generate(rows, (rowIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(columns, (colIndex) {
                  final monthIndex = rowIndex * columns + colIndex;
                  return _buildDot(monthIndex, dotSize);
                }),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildDot(int monthIndex, double size) {
    final isPast = monthIndex < currentMonthIndex;
    final isCurrent = monthIndex == currentMonthIndex;
    final milestone = milestones.where((m) => m.monthIndex == monthIndex).firstOrNull;

    Color dotColor;
    bool filled;

    if (milestone != null) {
      dotColor = Color(int.parse(milestone.color.replaceFirst('#', '0xFF')));
      filled = true;
    } else if (isCurrent) {
      dotColor = const Color(0xFF10B981);
      filled = true;
    } else if (isPast) {
      dotColor = const Color(0xFFFF6B35);
      filled = true;
    } else {
      dotColor = const Color(0xFF404040);
      filled = false;
    }

    Widget dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? dotColor : Colors.transparent,
        border: filled ? null : Border.all(color: dotColor, width: 1),
        shape: BoxShape.circle,
      ),
    );

    if (isCurrent) {
      dot = dot
          .animate(onPlay: (controller) => controller.repeat())
          .scale(
            duration: 1000.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.3, 1.3),
            curve: Curves.easeInOut,
          )
          .then()
          .scale(
            duration: 1000.ms,
            begin: const Offset(1.3, 1.3),
            end: const Offset(1.0, 1.0),
            curve: Curves.easeInOut,
          );
    }

    return dot;
  }
}
