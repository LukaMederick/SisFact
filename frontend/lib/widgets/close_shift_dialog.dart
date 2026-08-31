import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class CloseShiftDialog extends StatefulWidget {
  final AppState state;

  const CloseShiftDialog({super.key, required this.state});

  @override
  State<CloseShiftDialog> createState() => _CloseShiftDialogState();
}

class _CloseShiftDialogState extends State<CloseShiftDialog> {
  final _cashController = TextEditingController(text: '0.00');
  final _plinController = TextEditingController(text: '0.00');
  final _yapeController = TextEditingController(text: '0.00');
  final _closingNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cashController.text = widget.state.todayCashRevenue.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _cashController.dispose();
    _plinController.dispose();
    _yapeController.dispose();
    _closingNoteController.dispose();
    super.dispose();
  }

  void _submit() {
    final finalAmount = double.tryParse(_cashController.text.trim()) ?? 0.0;
    final notes = _closingNoteController.text.trim().isNotEmpty
        ? _closingNoteController.text.trim()
        : 'Cierre normal, sin novedades';

    widget.state.closeShift(finalAmount, notes);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jornada cerrada correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final initialAmount = widget.state.currentShift?.initialAmount ?? 0.0;
    final totalSales = widget.state.todayTotalRevenue;
    final salesCount = widget.state.filteredTotalSales;
    final averageTicket = widget.state.filteredAverageTicket;
    final costTotal = 0.0;
    final netProfit = totalSales - costTotal;

    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: isMobile ? Alignment.center : Alignment.centerRight,
      insetPadding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          : EdgeInsets.zero,
      child: Container(
        width: isMobile ? double.infinity : 480,
        height: isMobile ? MediaQuery.of(context).size.height * 0.95 : double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: isMobile
              ? BorderRadius.circular(16)
              : const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(-5, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.point_of_sale_rounded, size: 20, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Cerrar Jornada',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),

            // Form Body (Scrollable)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Yellow Warning Alert Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF78350F).withOpacity(0.2) : const Color(0xFFFEFCE8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF92400E) : const Color(0xFFFEF08A),
                      ),
                    ),
                    child: Text(
                      'Se cerrarán todas las cajas abiertas.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF854D0E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section 1: Resumen de la Jornada
                  _buildSectionCard(
                    isDark: isDark,
                    icon: Icons.bar_chart_rounded,
                    title: 'Resumen de la Jornada',
                    child: Column(
                      children: [
                        _buildSummaryRow('Total Ventas', 'S/ ${totalSales.toStringAsFixed(2)}', 'Ventas Realizadas', '$salesCount', isDark),
                        const SizedBox(height: 12),
                        _buildSummaryRow('Ticket Promedio', 'S/ ${averageTicket.toStringAsFixed(2)}', 'Costo Total', 'S/ ${costTotal.toStringAsFixed(2)}', isDark),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Ganancia Neta', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                  const SizedBox(height: 2),
                                  Text(
                                    '+S/ ${netProfit.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.success),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section 2: Efectivo en Caja
                  _buildSectionCard(
                    isDark: isDark,
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Efectivo en Caja',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Monto Inicial', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        const SizedBox(height: 2),
                        Text(
                          'S/ ${initialAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section 3: Arqueo de Caja (Screenshot 1)
                  _buildSectionCard(
                    isDark: isDark,
                    icon: Icons.credit_card_outlined,
                    title: 'Arqueo de Caja',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ingresa los montos contados físicamente. Deja vacío los métodos que no aplican.',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 16),

                        // Efectivo row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Efectivo', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('Esperado: S/ ${widget.state.todayCashRevenue.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _cashController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(hintText: '0.00'),
                        ),
                        const SizedBox(height: 14),

                        // Plin row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Plin', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            const Text('Esperado: S/ 0.00', style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _plinController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(hintText: '0.00'),
                        ),
                        const SizedBox(height: 14),

                        // Yape row (Screenshot 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Yape', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            const Text('Esperado: S/ 0.00', style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _yapeController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(hintText: '0.00'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section 4: Movimientos (Screenshot 1)
                  _buildSectionCard(
                    isDark: isDark,
                    icon: Icons.add_circle_outline_rounded,
                    title: 'Movimientos',
                    child: Column(
                      children: [
                        _buildSummaryRow('Ventas Anuladas', '0', 'Devoluciones', 'S/ 0.00', isDark),
                        const SizedBox(height: 12),
                        _buildSummaryRow('Ingresos Caja', 'S/ 0.00', 'Egresos Caja', 'S/ 0.00', isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nota de cierre (opcional) (Screenshot 1)
                  const Text(
                    'Nota de cierre (opcional)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _closingNoteController,
                    decoration: const InputDecoration(
                      hintText: 'Ej: Cierre normal, sin novedades',
                    ),
                  ),
                ],
              ),
            ),

            // Footer Buttons
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cerrar Jornada'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label1, String value1, String label2, String value2, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 2),
              Text(
                value1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label2, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 2),
              Text(
                value2,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
