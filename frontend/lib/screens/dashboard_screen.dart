import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../widgets/date_range_picker_dialog.dart';
import '../widgets/open_shift_drawer.dart';
import '../widgets/close_shift_dialog.dart';
import '../widgets/cash_movement_dialog.dart';

class DashboardScreen extends StatelessWidget {
  final AppState state;

  const DashboardScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 950;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Profile Card & Shift Card (width: 280)
                SizedBox(
                  width: 280,
                  child: Column(
                    children: [
                      _buildProfileCard(context, isDark),
                      const SizedBox(height: 16),
                      _buildShiftCard(context, isDark),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // Center Column: Greeting, Stats, Sales Trend, Widgets
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildGreetingBanner(context, isDark),
                      const SizedBox(height: 16),
                      _buildQuickActions(context, isDark),
                      const SizedBox(height: 16),
                      _buildMetricPills(context, isDark),
                      const SizedBox(height: 16),
                      _buildSalesTrendCard(context, isDark),
                      const SizedBox(height: 16),
                      _buildTopProductsCard(context, isDark),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // Right Column: Payment info & Restock (width: 260)
                SizedBox(
                  width: 260,
                  child: Column(
                    children: [
                      _buildPaymentMethodWidget(context, isDark),
                      const SizedBox(height: 16),
                      _buildRestockWidget(context, isDark),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileCard(context, isDark),
                const SizedBox(height: 16),
                _buildShiftCard(context, isDark),
                const SizedBox(height: 16),
                _buildGreetingBanner(context, isDark),
                const SizedBox(height: 16),
                _buildQuickActions(context, isDark),
                const SizedBox(height: 16),
                _buildMetricPills(context, isDark),
                const SizedBox(height: 16),
                _buildSalesTrendCard(context, isDark),
                const SizedBox(height: 16),
                _buildPaymentMethodWidget(context, isDark),
                const SizedBox(height: 16),
                _buildRestockWidget(context, isDark),
                const SizedBox(height: 16),
                _buildTopProductsCard(context, isDark),
              ],
            ),
    );
  }

  // Left: Store Profile Card
  Widget _buildProfileCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Blue Gradient Banner
          Container(
            height: 70,
            decoration: const BoxDecoration(
              gradient: AppColors.storeHeaderGradient,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -32),
            child: Column(
              children: [
                // "P" Avatar
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'P',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.store.businessName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  state.store.businessType,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      _buildStoreInfoRow('Sucursal', state.store.branchName, isDark),
                      const SizedBox(height: 8),
                      _buildStoreInfoRow('Sucursales', '${state.store.branchCount}', isDark),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Plan', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              state.store.planName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // Left: Shift Card (Jornada del día) - Matches Images 2 & 3
  Widget _buildShiftCard(BuildContext context, bool isDark) {
    final isOpen = state.currentShift?.isOpen ?? false;

    // Calculate elapsed time if open
    String elapsedTime = '0m';
    if (isOpen && state.currentShift != null) {
      final diff = DateTime.now().difference(state.currentShift!.openedAt);
      final minutes = diff.inMinutes;
      if (minutes < 60) {
        elapsedTime = '${minutes}m';
      } else {
        elapsedTime = '${diff.inHours}h ${minutes % 60}m';
      }
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Jornada del día',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isOpen ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (!isOpen) ...[
            // SHIFT CLOSED VIEW (Image 2)
            Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.nightlight_round_outlined,
                  size: 24,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Sin jornada abierta',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                'Ábrela para empezar a registrar ventas del día.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                OpenShiftDrawer.show(context, state);
              },
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text('Abrir jornada', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ] else ...[
            // SHIFT OPEN VIEW (Image 3)
            _buildShiftInfoRow('Sucursal', state.store.branchName, isDark, isBold: true),
            const SizedBox(height: 8),
            _buildShiftInfoRow('Abierta por', '—', isDark),
            const SizedBox(height: 8),
            _buildShiftInfoRow('Tiempo', elapsedTime, isDark, isBold: true),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => CloseShiftDialog(state: state),
                );
              },
              icon: const Icon(Icons.calendar_today_outlined, size: 15, color: Color(0xFFEF4444)),
              label: const Text(
                'Cerrar jornada',
                style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFCA5A5)),
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShiftInfoRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  // Center: Greeting Banner with VENDIDO · HOY
  Widget _buildGreetingBanner(BuildContext context, bool isDark) {
    final hour = DateTime.now().hour;
    String greeting = 'Buenas noches';
    if (hour >= 6 && hour < 12) {
      greeting = 'Buenos días';
    } else if (hour >= 12 && hour < 19) {
      greeting = 'Buenas tardes';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    state.formattedSelectedDate,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => DateRangePickerPopup(state: state),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        state.formattedSelectedDate,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VENDIDO · HOY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'S/ ${state.todayTotalRevenue.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.payments_outlined,
                  size: 22,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Quick Actions Card (Matching Images 2 & 3)
  Widget _buildQuickActions(BuildContext context, bool isDark) {
    final isOpen = state.currentShift?.isOpen ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones rápidas',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        if (!isOpen)
          // CLOSED STATE: Single Large "Abrir jornada" Card (Image 2)
          InkWell(
            onTap: () {
              OpenShiftDrawer.show(context, state);
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.play_arrow_outlined, color: Color(0xFF10B981), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Abrir jornada',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const Text(
                          'Inicia las operaciones del día',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          )
        else
          // OPEN STATE: 2x2 Grid with Ingreso, Egreso, Nueva venta, Cerrar jornada (Image 3)
          Column(
            children: [
              Row(
                children: [
                  // Ingreso
                  Expanded(
                    child: _buildActionTile(
                      context,
                      isDark: isDark,
                      icon: Icons.add_circle_outline_rounded,
                      iconBgColor: const Color(0xFFECFDF5),
                      iconColor: const Color(0xFF10B981),
                      title: 'Ingreso',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => CashMovementDialog(state: state, initialType: 'Ingreso'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Egreso
                  Expanded(
                    child: _buildActionTile(
                      context,
                      isDark: isDark,
                      icon: Icons.remove_circle_outline_rounded,
                      iconBgColor: const Color(0xFFFEF2F2),
                      iconColor: const Color(0xFFEF4444),
                      title: 'Egreso',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => CashMovementDialog(state: state, initialType: 'Egreso'),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Nueva venta
                  Expanded(
                    child: _buildActionTile(
                      context,
                      isDark: isDark,
                      icon: Icons.shopping_cart_outlined,
                      iconBgColor: const Color(0xFFEFF6FF),
                      iconColor: AppColors.primary,
                      title: 'Nueva venta',
                      onTap: () => state.setTab(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Cerrar jornada
                  Expanded(
                    child: _buildActionTile(
                      context,
                      isDark: isDark,
                      icon: Icons.calendar_today_outlined,
                      iconBgColor: const Color(0xFFFEF2F2),
                      iconColor: const Color(0xFFEF4444),
                      title: 'Cerrar jornada',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => CloseShiftDialog(state: state),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark ? iconColor.withValues(alpha: 0.15) : iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // Metric pills: 0 Sin stock, 0 Clientes nuevos
  Widget _buildMetricPills(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.all_inbox_outlined, size: 18, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.outOfStockCount}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    const Text('Sin stock', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person_add_alt_outlined, size: 18, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    const Text('Clientes nuevos', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Sales Trend 7 days Chart Card
  Widget _buildSalesTrendCard(BuildContext context, bool isDark) {
    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'Tendencia de ventas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL 7 DÍAS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                  const SizedBox(height: 2),
                  Text(
                    'S/ ${state.filteredTotalRevenue.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('PROMEDIO', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                  const SizedBox(height: 2),
                  Text(
                    'S/ ${state.filteredAverageTicket.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Days row with baseline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.map((day) {
              return Column(
                children: [
                  const Text('—', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    width: 34,
                    height: 2,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: day == 'D' ? FontWeight.w700 : FontWeight.w500,
                      color: day == 'D'
                          ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Top Products Card
  Widget _buildTopProductsCard(BuildContext context, bool isDark) {
    final topProducts = state.topSoldProducts;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'Top productos',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (topProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Aún no hay ventas en este periodo.',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            )
          else
            ...topProducts.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('${e.value} vendidos', style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // Right Widget: Cómo te pagan hoy
  Widget _buildPaymentMethodWidget(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined, size: 17, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'Cómo te pagan hoy',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (state.todayTotalRevenue == 0)
            const Text(
              'Aún no hay cobros registrados en este periodo.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            )
          else
            Text(
              'Efectivo: S/ ${state.todayCashRevenue.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }

  // Right Widget: Reponer pronto
  Widget _buildRestockWidget(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.all_inbox_outlined, size: 17, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'Reponer pronto',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Todo el stock está por encima del mínimo. 👏',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
