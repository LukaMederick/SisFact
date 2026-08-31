import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class MoreMenuPopup extends StatelessWidget {
  final AppState state;

  const MoreMenuPopup({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Cajas', 'icon': Icons.all_inbox_outlined, 'action': () => state.setTab(4)},
      {'title': 'Aperturas de caja', 'icon': Icons.history_rounded, 'action': () => state.setTab(5)},
      {'title': 'Jornadas', 'icon': Icons.calendar_today_outlined, 'action': () => state.setTab(6)},
      {'title': 'Movimientos', 'icon': Icons.swap_horiz_rounded, 'action': () => state.setTab(8)},
      {'title': 'Compras', 'icon': Icons.shopping_cart_outlined, 'action': () => state.setTab(7)},
      {'title': 'Empleados', 'icon': Icons.person_outline_rounded, 'action': () => state.setTab(9)},
      {'title': 'Clientes', 'icon': Icons.people_outline_rounded, 'action': () => state.setTab(10)},
      {'title': 'Roles y Permisos', 'icon': Icons.security_outlined, 'action': () => state.setTab(11)},
      {'title': 'Reportes', 'icon': Icons.bar_chart_rounded, 'action': () => state.setTab(12)},
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.topRight,
      insetPadding: const EdgeInsets.only(top: 60, right: 100),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: menuItems.map((item) {
            final isCajas = item['title'] == 'Cajas' || item['title'] == 'Movimientos';
            return InkWell(
              onTap: () {
                Navigator.of(context).pop();
                (item['action'] as VoidCallback)();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isCajas && state.currentTabIndex == 4
                      ? (isDark ? const Color(0xFF1E3A8A).withOpacity(0.3) : const Color(0xFFEFF6FF))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 19,
                      color: isCajas && state.currentTabIndex == 4
                          ? AppColors.primary
                          : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: isCajas && state.currentTabIndex == 4
                            ? AppColors.primary
                            : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
