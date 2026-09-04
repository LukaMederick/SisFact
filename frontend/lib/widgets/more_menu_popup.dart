import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class MoreMenuPopup extends StatelessWidget {
  final AppState state;

  const MoreMenuPopup({super.key, required this.state});

  static void showAtButton(BuildContext buttonContext, AppState state) {
    final renderBox = buttonContext.findRenderObject() as RenderBox?;
    double left = 0;
    double top = 64;

    if (renderBox != null) {
      final offset = renderBox.localToGlobal(Offset.zero);
      left = offset.dx - 30;
      top = offset.dy + renderBox.size.height + 4;
    }

    final screenWidth = MediaQuery.of(buttonContext).size.width;
    final clampedLeft = left.clamp(16.0, screenWidth - 250.0);

    showGeneralDialog(
      context: buttonContext,
      barrierDismissible: true,
      barrierLabel: 'MoreMenuPopup',
      barrierColor: Colors.black.withValues(alpha: 0.1),
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (ctx, anim1, anim2) {
        return Stack(
          children: [
            Positioned(
              left: clampedLeft,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: MoreMenuPopup(state: state),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Cajas', 'icon': Icons.inbox_outlined, 'tab': 4},
      {'title': 'Aperturas de caja', 'icon': Icons.history_rounded, 'tab': 5},
      {'title': 'Jornadas', 'icon': Icons.calendar_today_outlined, 'tab': 6},
      {'title': 'Movimientos', 'icon': Icons.sync_alt_rounded, 'tab': 8},
      {'title': 'Compras', 'icon': Icons.shopping_cart_outlined, 'tab': 7},
      {'title': 'Empleados', 'icon': Icons.person_outline_rounded, 'tab': 9},
      {'title': 'Clientes', 'icon': Icons.group_outlined, 'tab': 10},
      {'title': 'Roles y Permisos', 'icon': Icons.shield_outlined, 'tab': 11},
      {'title': 'Reportes', 'icon': Icons.bar_chart_rounded, 'tab': 12},
    ];

    return Container(
      width: 235,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: menuItems.map((item) {
          final tab = item['tab'] as int;
          final isCurrentTab = state.currentTabIndex == tab;

          return InkWell(
            onTap: () {
              Navigator.of(context).pop();
              state.setTab(tab);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: isCurrentTab
                    ? (isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFEFF6FF))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 19,
                    color: isCurrentTab
                        ? AppColors.primary
                        : (isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isCurrentTab ? FontWeight.w600 : FontWeight.w500,
                      color: isCurrentTab
                          ? AppColors.primary
                          : (isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
