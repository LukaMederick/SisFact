import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../widgets/kpi_card.dart';
import '../widgets/new_customer_dialog.dart';

class CustomersScreen extends StatelessWidget {
  final AppState state;

  const CustomersScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Title "Clientes" + Button "+ Nuevo Cliente" (Screenshot 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Clientes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => NewCustomerDialog(state: state),
                  );
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nuevo Cliente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4 KPI Cards: Total de Clientes, Nuevos este Mes, Clientes con Deuda, Clientes Recurrentes (Screenshot 3)
          isMobile
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard('Total de Clientes', '0', Icons.people_outline_rounded, AppColors.primary)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Nuevos este Mes', '0', Icons.person_add_alt_outlined, AppColors.success)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard('Clientes con Deuda', '0', Icons.credit_card_outlined, AppColors.warning)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Clientes Recurrentes', '0', Icons.sync_rounded, AppColors.purple)),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildKpiCard('Total de Clientes', '0', Icons.people_outline_rounded, AppColors.primary)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildKpiCard('Nuevos este Mes', '0', Icons.person_add_alt_outlined, AppColors.success)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildKpiCard('Clientes con Deuda', '0', Icons.credit_card_outlined, AppColors.warning)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildKpiCard('Clientes Recurrentes', '0', Icons.sync_rounded, AppColors.purple)),
                  ],
                ),

          const SizedBox(height: 24),

          // Main Empty State Container (Screenshot 3)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Users Circle Icon
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.people_outline_rounded,
                    size: 32,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'No hay clientes registrados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Comienza agregando tu primer cliente para gestionar mejor tu negocio',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => NewCustomerDialog(state: state),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text('Crear Primer Cliente'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return KpiCard(
      title: title,
      value: value,
      icon: Icon(icon, size: 20, color: color),
    );
  }
}
