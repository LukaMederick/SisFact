import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../widgets/date_range_picker_dialog.dart';
import '../widgets/kpi_card.dart';

class PurchasesScreen extends StatefulWidget {
  final AppState state;

  const PurchasesScreen({super.key, required this.state});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  String _activeTab = 'Nueva Compra';
  final _searchController = TextEditingController();
  String _historySearchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isMobile = screenWidth < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sub-navbar: Compras / Nueva Compra / Historial
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.card,
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Compras',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(width: 1, height: 18, color: isDark ? AppColors.darkBorder : AppColors.border),
              const SizedBox(width: 16),
              _buildSubTab('Nueva Compra', isDark),
              const SizedBox(width: 20),
              _buildSubTab('Historial', isDark),
            ],
          ),
        ),

        // Content Area (Scrollable)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _activeTab == 'Historial'
                ? _buildHistoryView(isDark, isDesktop, isMobile)
                : _buildNewPurchaseView(isDark, isDesktop),
          ),
        ),
      ],
    );
  }

  Widget _buildSubTab(String title, bool isDark) {
    final isSelected = _activeTab == title;

    return InkWell(
      onTap: () => setState(() => _activeTab = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  // --- HISTORIAL VIEW ---
  Widget _buildHistoryView(bool isDark, bool isDesktop, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header: Historial de Compras + Date Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Historial de Compras',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Consulta todas las compras registradas a tus proveedores',
                  style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                ),
              ],
            ),
            // Date Picker Button
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
                  color: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      widget.state.formattedSelectedDate,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 4 KPI Cards: Total Compras (0), Monto Total (S/ 0.00), Productos (0), Promedio (S/ 0.00)
        isMobile
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildKpiCard('Total Compras', '0', Icons.shopping_bag_outlined, AppColors.primary)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildKpiCard('Monto Total', 'S/ 0.00', Icons.attach_money_rounded, AppColors.success)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildKpiCard('Productos', '0', Icons.all_inbox_outlined, AppColors.purple)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildKpiCard('Promedio', 'S/ 0.00', Icons.calculate_outlined, AppColors.warning)),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildKpiCard('Total Compras', '0', Icons.shopping_bag_outlined, AppColors.primary)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildKpiCard('Monto Total', 'S/ 0.00', Icons.attach_money_rounded, AppColors.success)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildKpiCard('Productos', '0', Icons.all_inbox_outlined, AppColors.purple)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildKpiCard('Promedio', 'S/ 0.00', Icons.calculate_outlined, AppColors.warning)),
                ],
              ),
        const SizedBox(height: 24),

        // Main Container: Search & Empty State
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Input
              Container(
                height: 42,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search_rounded, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _historySearchQuery = val),
                        style: TextStyle(
                          fontSize: 13.5,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Buscar compra por proveedor, factura o producto...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Empty State
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long_outlined,
                        size: 30,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay compras registradas',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _historySearchQuery.isEmpty
                          ? 'Las compras que registres aparecerán aquí'
                          : 'No se encontraron resultados para "$_historySearchQuery"',
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ],
    );
  }

  // --- NUEVA COMPRA VIEW ---
  Widget _buildNewPurchaseView(bool isDark, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nueva Compra',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Registra una nueva compra de productos para tu inventario',
              style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 20),

        isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSearchAndAiBar(isDark),
                        const SizedBox(height: 16),
                        _buildEmptyCartCard(isDark),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  SizedBox(
                    width: 380,
                    child: _buildPurchaseSummaryCard(isDark),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildSearchAndAiBar(isDark),
                  const SizedBox(height: 16),
                  _buildEmptyCartCard(isDark),
                  const SizedBox(height: 20),
                  _buildPurchaseSummaryCard(isDark),
                ],
              ),
      ],
    );
  }

  Widget _buildSearchAndAiBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar producto por nombre o código...',
                    prefixIcon: Icon(Icons.search_rounded, size: 20),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lector de boleta/factura con IA listo')),
                  );
                },
                icon: const Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.primary),
                label: const Text('Cargar con IA', style: TextStyle(color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartCard(bool isDark) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Carrito vacío',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Busca y selecciona productos para agregar a la compra',
            style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseSummaryCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Resumen de Compra',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Productos:', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
              Text('0', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Unidades:', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
              Text('0', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              Text(
                'S/ 0.00',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.save_outlined, size: 16),
            label: const Text('Guardar Compra'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF93C5FD),
              disabledBackgroundColor: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.4) : const Color(0xFF93C5FD),
              disabledForegroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Agrega al menos un producto para guardar la compra',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
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
