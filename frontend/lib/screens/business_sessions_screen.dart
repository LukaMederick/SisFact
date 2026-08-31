import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../widgets/close_shift_dialog.dart';

class BusinessSessionsScreen extends StatefulWidget {
  final AppState state;

  const BusinessSessionsScreen({super.key, required this.state});

  @override
  State<BusinessSessionsScreen> createState() => _BusinessSessionsScreenState();
}

class _BusinessSessionsScreenState extends State<BusinessSessionsScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'Cualquier estado';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOpen = widget.state.currentShift?.isOpen ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Title "Jornadas" + Buttons "Cerrar Jornada" & "Actualizar"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jornadas',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  if (isOpen)
                    OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => CloseShiftDialog(state: widget.state),
                        );
                      },
                      icon: const Icon(Icons.crop_square_rounded, size: 16, color: AppColors.danger),
                      label: const Text('Cerrar Jornada', style: TextStyle(color: AppColors.danger)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.danger),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  if (isOpen) const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Jornadas actualizadas')),
                      );
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Actualizar'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search & Filter Card Container (Screenshot 4)
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Search & Status Filter Row
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: const InputDecoration(
                          hintText: 'Buscar por sucursal o empleado...',
                          prefixIcon: Icon(Icons.search_rounded, size: 18),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkInputBg : AppColors.inputBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_list_rounded, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(
                            _selectedStatus,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Table Header (Screenshot 4)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 3, child: Text('SUCURSAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: Text('ABIERTO POR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: Text('CERRADO POR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: Text('VENTAS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: Text('TOTAL VENTAS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: Text('DURACIÓN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: Text('ESTADO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: Text('APERTURA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Table Row (Screenshot 4)
                if (isOpen)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderLight)),
                    ),
                    child: Row(
                      children: [
                        // Sucursal
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.storefront_outlined, size: 14, color: AppColors.textSecondary),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.state.store.branchName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Abierto por
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.textMuted),
                            ],
                          ),
                        ),

                        // Cerrado por
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              const Text('-', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                            ],
                          ),
                        ),

                        // Ventas
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              const Icon(Icons.shopping_cart_outlined, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.state.filteredTotalSales}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                        // Total Ventas
                        Expanded(
                          flex: 2,
                          child: Text(
                            '\$ S/ ${widget.state.todayTotalRevenue.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                        ),

                        // Duración
                        const Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 14, color: AppColors.textMuted),
                              SizedBox(width: 6),
                              Text('6 min', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                            ],
                          ),
                        ),

                        // Estado
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow_rounded, size: 14, color: AppColors.success),
                                SizedBox(width: 2),
                                Text(
                                  'Abierta',
                                  style: TextStyle(fontSize: 11.5, color: AppColors.success, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Apertura
                        const Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textMuted),
                              SizedBox(width: 6),
                              Text('hace 6 min', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No hay jornadas abiertas actualmente',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // Table Footer (Screenshot 4)
                Row(
                  children: [
                    Text(
                      'Mostrando ',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Text('20', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          SizedBox(width: 2),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 14),
                        ],
                      ),
                    ),
                    Text(
                      ' de ${isOpen ? '1' : '0'} jornadas',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
