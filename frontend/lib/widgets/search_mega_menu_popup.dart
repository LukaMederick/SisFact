import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class SearchMegaMenuPopup extends StatefulWidget {
  final AppState state;

  const SearchMegaMenuPopup({super.key, required this.state});

  @override
  State<SearchMegaMenuPopup> createState() => _SearchMegaMenuPopupState();
}

class _SearchMegaMenuPopupState extends State<SearchMegaMenuPopup> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define all navigation items categorized as in Image 4
    final generalItems = [
      {'title': 'Inicio', 'subtitle': 'Panel principal', 'icon': Icons.home_outlined, 'tab': 0},
    ];

    final inventoryItems = [
      {'title': 'Inventario', 'subtitle': 'Lista de productos', 'icon': Icons.all_inbox_outlined, 'tab': 1},
    ];

    final salesItems = [
      {'title': 'Vender', 'subtitle': 'Realizar ventas', 'icon': Icons.shopping_basket_outlined, 'tab': 2},
      {'title': 'Ventas', 'subtitle': 'Ver ventas realizadas', 'icon': Icons.attach_money_rounded, 'tab': 3},
    ];

    final managementItems = [
      {'title': 'Cajas', 'subtitle': 'Gestionar cajas registradoras', 'icon': Icons.inventory_2_outlined, 'tab': 4},
      {'title': 'Aperturas de caja', 'subtitle': 'Ver aperturas y cierres de caja', 'icon': Icons.history_rounded, 'tab': 5},
      {'title': 'Movimientos', 'subtitle': 'Ir a Movimientos', 'icon': Icons.sync_alt_rounded, 'tab': 8},
      {'title': 'Empleados', 'subtitle': 'Gestionar empleados', 'icon': Icons.group_outlined, 'tab': 9},
      {'title': 'Clientes', 'subtitle': 'Gestionar clientes', 'icon': Icons.person_outline_rounded, 'tab': 10},
    ];

    final moreOptionItems = [
      {'title': 'Jornadas', 'subtitle': 'Ir a Jornadas', 'icon': Icons.calendar_today_outlined, 'tab': 6},
      {'title': 'Compras', 'subtitle': 'Ir a Compras', 'icon': Icons.shopping_cart_outlined, 'tab': 7},
      {'title': 'Roles y Permisos', 'subtitle': 'Ir a Roles y Permisos', 'icon': Icons.security_outlined, 'tab': 11},
      {'title': 'Reportes', 'subtitle': 'Ir a Reportes', 'icon': Icons.bar_chart_rounded, 'tab': 12},
    ];

    bool matches(Map<String, dynamic> item) {
      if (_query.isEmpty) return true;
      final t = (item['title'] as String).toLowerCase();
      final s = (item['subtitle'] as String).toLowerCase();
      return t.contains(_query.toLowerCase()) || s.contains(_query.toLowerCase());
    }

    final filteredGeneral = generalItems.where(matches).toList();
    final filteredInventory = inventoryItems.where(matches).toList();
    final filteredSales = salesItems.where(matches).toList();
    final filteredManagement = managementItems.where(matches).toList();
    final filteredMore = moreOptionItems.where(matches).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.only(top: 12),
      child: Container(
        width: 780,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Search Input Box
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        autofocus: true,
                        onChanged: (val) => setState(() => _query = val),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Buscar páginas, funciones...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),

            // 3-Column / Multi-column Layout matching Image 4
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column 1: GENERAL & INVENTARIO & VENTAS
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (filteredGeneral.isNotEmpty) ...[
                            _buildCategoryHeader('GENERAL', isDark),
                            const SizedBox(height: 8),
                            ...filteredGeneral.map((it) => _buildMenuItem(it, isDark)),
                            const SizedBox(height: 16),
                          ],
                          if (filteredInventory.isNotEmpty) ...[
                            _buildCategoryHeader('INVENTARIO', isDark),
                            const SizedBox(height: 8),
                            ...filteredInventory.map((it) => _buildMenuItem(it, isDark)),
                            const SizedBox(height: 16),
                          ],
                          if (filteredSales.isNotEmpty) ...[
                            _buildCategoryHeader('VENTAS', isDark),
                            const SizedBox(height: 8),
                            ...filteredSales.map((it) => _buildMenuItem(it, isDark)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Column 2: GESTIÓN
                    if (filteredManagement.isNotEmpty)
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategoryHeader('GESTIÓN', isDark),
                            const SizedBox(height: 8),
                            ...filteredManagement.map((it) => _buildMenuItem(it, isDark)),
                          ],
                        ),
                      ),
                    const SizedBox(width: 20),

                    // Column 3: MÁS OPCIONES
                    if (filteredMore.isNotEmpty)
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategoryHeader('MÁS OPCIONES', isDark),
                            const SizedBox(height: 8),
                            ...filteredMore.map((it) => _buildMenuItem(it, isDark)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item, bool isDark) {
    final title = item['title'] as String;
    final subtitle = item['subtitle'] as String;
    final icon = item['icon'] as IconData;
    final tab = item['tab'] as int;

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        widget.state.setTab(tab);
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF94A3B8),
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
}
