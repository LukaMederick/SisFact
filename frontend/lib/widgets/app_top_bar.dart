import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import 'user_menu_popup.dart';
import 'more_menu_popup.dart';
import 'global_search_dialog.dart';

class AppTopBar extends StatelessWidget {
  final AppState state;

  const AppTopBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 850;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Left: Store Profile Selector
          _buildStoreSelector(context, isDark),

          const SizedBox(width: 12),

          // Search Bar
          if (!isMobile)
            Expanded(
              flex: 2,
              child: _buildSearchBar(context, isDark),
            ),

          if (!isMobile) const Spacer(flex: 1),

          // Center Tabs (Desktop / Tablet)
          if (!isMobile)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavTab(
                  context,
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Inicio',
                ),
                _buildNavTab(
                  context,
                  index: 1,
                  icon: Icons.all_inbox_outlined,
                  activeIcon: Icons.all_inbox_rounded,
                  label: 'Inventario',
                ),
                _buildNavTab(
                  context,
                  index: 2,
                  icon: Icons.shopping_basket_outlined,
                  activeIcon: Icons.shopping_basket_rounded,
                  label: 'Vender',
                ),
                _buildNavTab(
                  context,
                  index: 3,
                  icon: Icons.attach_money_rounded,
                  activeIcon: Icons.attach_money_rounded,
                  label: 'Ventas',
                ),
                _buildMoreTab(context, isDark),
              ],
            ),

          if (isMobile) const Spacer(),

          if (isMobile)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => GlobalSearchDialog(state: state),
                );
              },
            ),

          const SizedBox(width: 8),

          // Right: Fullscreen Button
          IconButton(
            icon: const Icon(Icons.fullscreen_rounded, size: 22),
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            tooltip: 'Pantalla completa',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Modo pantalla completa'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),

          const SizedBox(width: 4),

          // Right: User Profile Avatar
          _buildUserAvatar(context, isDark),
        ],
      ),
    );
  }

  Widget _buildStoreSelector(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sucursal: ${state.store.branchName}')),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.store.businessName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                Text(
                  state.store.branchName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => GlobalSearchDialog(state: state),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: 18,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Buscar páginas, funciones...',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = state.currentTabIndex == index;

    return InkWell(
      onTap: () => state.setTab(index),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreTab(BuildContext context, bool isDark) {
    final isSelected = state.currentTabIndex == 4;

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => MoreMenuPopup(state: state),
        );
      },
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.grid_view_rounded,
                  size: 19,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Más',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 14,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => UserMenuPopup(state: state),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'U',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
