import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../widgets/kpi_card.dart';
import '../widgets/date_range_picker_dialog.dart';

class SunatDocumentsScreen extends StatefulWidget {
  final AppState state;

  const SunatDocumentsScreen({super.key, required this.state});

  @override
  State<SunatDocumentsScreen> createState() => _SunatDocumentsScreenState();
}

class _SunatDocumentsScreenState extends State<SunatDocumentsScreen> {
  String _searchQuery = '';
  String _selectedDocType = 'Todos';
  String _selectedDocStatus = 'Todos';

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
          // Header Row with Back Button (Screenshot 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => widget.state.setTab(12), // Return to Reports Hub
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chevron_left_rounded, size: 24),
                        const SizedBox(width: 4),
                        Text(
                          'Documentos Electrónicos SUNAT',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Control de boletas, facturas y notas de crédito/débito emitidas a SUNAT',
                    style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                  ),
                ],
              ),

              // Date range button
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => DateRangePickerPopup(state: widget.state),
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        widget.state.formattedSelectedDate,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4 KPI Cards: Total Documentos, Aceptados, Con Errores, Pendientes (Screenshot 3)
          isMobile
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard('Total Documentos', '0', Icons.description_outlined, AppColors.primary)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Aceptados', '0', Icons.assignment_turned_in_outlined, AppColors.success)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard('Con Errores', '0', Icons.warning_amber_rounded, AppColors.danger)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Pendientes', '0', Icons.access_time_rounded, AppColors.warning)),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildKpiCard('Total Documentos', '0', Icons.description_outlined, AppColors.primary)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildKpiCard('Aceptados', '0', Icons.assignment_turned_in_outlined, AppColors.success)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildKpiCard('Con Errores', '0', Icons.warning_amber_rounded, AppColors.danger)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildKpiCard('Pendientes', '0', Icons.access_time_rounded, AppColors.warning)),
                  ],
                ),

          const SizedBox(height: 24),

          // Main Card: Search, Filters & Empty State (Screenshot 3)
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
                // Top Search and Filter Bar
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: const InputDecoration(
                          hintText: 'Buscar por Nº documento o cliente...',
                          prefixIcon: Icon(Icons.search_rounded, size: 18),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Filter 1 Dropdown
                    PopupMenuButton<String>(
                      initialValue: _selectedDocType,
                      onSelected: (val) => setState(() => _selectedDocType = val),
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'Todos', child: Text('Todos los Tipos')),
                        const PopupMenuItem(value: 'Boleta', child: Text('Boleta de Venta')),
                        const PopupMenuItem(value: 'Factura', child: Text('Factura Electrónica')),
                        const PopupMenuItem(value: 'Nota de Crédito', child: Text('Nota de Crédito')),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkInputBg : AppColors.inputBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Text(_selectedDocType, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(width: 6),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Filter 2 Dropdown
                    PopupMenuButton<String>(
                      initialValue: _selectedDocStatus,
                      onSelected: (val) => setState(() => _selectedDocStatus = val),
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'Todos', child: Text('Todos los Estados')),
                        const PopupMenuItem(value: 'Aceptado', child: Text('Aceptado por SUNAT')),
                        const PopupMenuItem(value: 'Pendiente', child: Text('Pendiente de Envío')),
                        const PopupMenuItem(value: 'Rechazado', child: Text('Rechazado / Con error')),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkInputBg : AppColors.inputBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Text(_selectedDocStatus, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(width: 6),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Export button
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Exportando comprobantes SUNAT a Excel/PDF...')),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('Exportar'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),

                // Empty State (Screenshot 3)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        size: 32,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'No hay documentos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'No se encontraron documentos que coincidan con "$_searchQuery".'
                          : 'No se encontraron documentos electrónicos para el período seleccionado.',
                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
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
