import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class GlobalSearchDialog extends StatefulWidget {
  final AppState state;

  const GlobalSearchDialog({super.key, required this.state});

  @override
  State<GlobalSearchDialog> createState() => _GlobalSearchDialogState();
}

class _GlobalSearchDialogState extends State<GlobalSearchDialog> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navigationPages = [
      {'title': 'Inicio / Dashboard', 'subtitle': 'Métricas, resumen diario y estado', 'tab': 0, 'icon': Icons.home_outlined},
      {'title': 'Inventario y Productos', 'subtitle': 'Gestión de catálogo, stock y categorías', 'tab': 1, 'icon': Icons.all_inbox_outlined},
      {'title': 'Vender / Terminal POS', 'subtitle': 'Abrir jornada y emitir tickets de venta', 'tab': 2, 'icon': Icons.shopping_basket_outlined},
      {'title': 'Historial de Ventas', 'subtitle': 'Reportes de ingresos y comprobantes', 'tab': 3, 'icon': Icons.attach_money_rounded},
      {'title': 'Cajas Registradoras', 'subtitle': 'Control de cajas y movimientos', 'tab': 4, 'icon': Icons.inventory_2_outlined},
    ];

    final matchedPages = navigationPages.where((p) {
      final t = (p['title'] as String).toLowerCase();
      final s = (p['subtitle'] as String).toLowerCase();
      return t.contains(_query.toLowerCase()) || s.contains(_query.toLowerCase());
    }).toList();

    final matchedProducts = widget.state.products.where((p) {
      return p.name.toLowerCase().contains(_query.toLowerCase()) ||
          p.barcode.contains(_query);
    }).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      alignment: Alignment.topCenter,
      child: Container(
        width: 580,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Input Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: (val) => setState(() => _query = val),
                      decoration: const InputDecoration(
                        hintText: 'Buscar páginas, funciones, productos o códigos...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),

            // Search Results List
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 380),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  if (matchedPages.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Text(
                        'PÁGINAS Y MÓDULOS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    ...matchedPages.map((page) {
                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(
                          page['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          page['subtitle'] as String,
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.state.setTab(page['tab'] as int);
                        },
                      );
                    }),
                  ],
                  if (matchedProducts.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Text(
                        'PRODUCTOS EN INVENTARIO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    ...matchedProducts.map((prod) {
                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.inventory_2_outlined, size: 18, color: AppColors.primary),
                        ),
                        title: Text(
                          prod.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          'Stock: ${prod.stock.toInt()} · ${prod.category}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        trailing: Text(
                          'S/ ${prod.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.state.setTab(1); // Go to inventory
                        },
                      );
                    }),
                  ],
                  if (matchedPages.isEmpty && matchedProducts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'No se encontraron resultados',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                        ),
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
