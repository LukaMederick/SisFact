import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../widgets/kpi_card.dart';
import '../widgets/new_product_dialog.dart';

class InventoryScreen extends StatelessWidget {
  final AppState state;

  const InventoryScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final subTabs = [
      'Productos',
      'Categorías',
      'Marcas',
      'Variantes',
      'SKUs',
      'Proveedores',
      'Movimientos',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sub-navbar
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.all_inbox_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Inventario',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Container(
                  width: 1,
                  height: 18,
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
                const SizedBox(width: 16),
                ...subTabs.map((tab) {
                  final isSelected = state.inventorySubTab == tab;
                  return InkWell(
                    onTap: () => state.setInventorySubTab(tab),
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tab,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Content Area (Scrollable)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Row: Title "Productos" + Button "+ Nuevo Producto"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.inventorySubTab,
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
                          builder: (ctx) => NewProductDialog(state: state),
                        );
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Nuevo Producto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 4 KPI Cards: Total, Activos, Críticos, Sin stock
                isMobile
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildKpiCard(context, 'Total', '${state.totalProductsCount}', Icons.all_inbox_outlined, AppColors.primary)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildKpiCard(context, 'Activos', '${state.activeProductsCount}', Icons.check_circle_outline_rounded, AppColors.success)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildKpiCard(context, 'Críticos', '${state.criticalProductsCount}', Icons.trending_down_rounded, AppColors.warning)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildKpiCard(context, 'Sin stock', '${state.outOfStockCount}', Icons.highlight_off_rounded, AppColors.danger)),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: _buildKpiCard(context, 'Total', '${state.totalProductsCount}', Icons.all_inbox_outlined, AppColors.primary)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildKpiCard(context, 'Activos', '${state.activeProductsCount}', Icons.check_circle_outline_rounded, AppColors.success)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildKpiCard(context, 'Críticos', '${state.criticalProductsCount}', Icons.trending_down_rounded, AppColors.warning)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildKpiCard(context, 'Sin stock', '${state.outOfStockCount}', Icons.highlight_off_rounded, AppColors.danger)),
                        ],
                      ),

                const SizedBox(height: 24),

                // Main Container (Empty state or Products list)
                state.products.isEmpty
                    ? _buildEmptyState(context, isDark)
                    : _buildProductsList(context, isDark),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return KpiCard(
      title: title,
      value: value,
      icon: Icon(icon, size: 20, color: color),
    );
  }

  // Empty State matching screenshot 2
  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.all_inbox_outlined,
              size: 32,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No hay productos registrados',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Comienza agregando tu primer producto al inventario',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => NewProductDialog(state: state),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: const Text('Crear Primer Producto'),
          ),
        ],
      ),
    );
  }

  // Populated Products List
  Widget _buildProductsList(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.products.length,
        separatorBuilder: (_, __) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
        itemBuilder: (context, index) {
          final product = state.products[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 22),
            ),
            title: Text(
              product.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            subtitle: Row(
              children: [
                Text(
                  'S/ ${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Stock: ${product.stock.toInt()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: product.stock <= 0 ? AppColors.danger : AppColors.textMuted,
                  ),
                ),
                if (product.category.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 20, color: AppColors.primary),
                  tooltip: 'Vender',
                  onPressed: () {
                    state.addToCart(product);
                    state.setTab(2); // Go to POS
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.danger),
                  tooltip: 'Eliminar',
                  onPressed: () => state.deleteProduct(product.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
