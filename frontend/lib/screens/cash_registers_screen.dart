import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/kpi_card.dart';
import '../widgets/new_cash_register_dialog.dart';
import '../widgets/open_box_session_dialog.dart';

class CashRegistersScreen extends StatefulWidget {
  final AppState state;

  const CashRegistersScreen({super.key, required this.state});

  @override
  State<CashRegistersScreen> createState() => _CashRegistersScreenState();
}

class _CashRegistersScreenState extends State<CashRegistersScreen> {
  String _searchQuery = '';

  void _showAddCashRegisterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => NewCashRegisterDialog(state: widget.state),
    );
  }

  void _showEditDialog(CashRegisterItem item) {
    final nameCtrl = TextEditingController(text: item.name);
    final branchCtrl = TextEditingController(text: item.branchName);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Editar Caja', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nombre de la caja', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Ej: Caja 1')),
            const SizedBox(height: 12),
            const Text('Sucursal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            TextField(controller: branchCtrl, decoration: const InputDecoration(hintText: 'Ej: Prueba - Principal')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item.name = nameCtrl.text.trim();
                item.branchName = branchCtrl.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Caja actualizada con éxito')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(CashRegisterItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar Caja', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('¿Estás seguro de que deseas eliminar la caja "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.state.cashRegisters.removeWhere((cr) => cr.id == item.id);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Caja "${item.name}" eliminada')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final filteredList = widget.state.cashRegisters.where((cr) {
      return cr.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          cr.branchName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sub-tabs: Cajas Registradoras, Movimientos
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
              _buildSubTab('Cajas Registradoras', isDark),
              const SizedBox(width: 24),
              _buildSubTab('Movimientos', isDark),
            ],
          ),
        ),

        // Scrollable Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header: Title + Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cajas Registradoras',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddCashRegisterDialog,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Agregar Caja'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 4 KPI Cards: Cajas Totales, Aperturas Totales, Efectivo Hoy, Efectivo del Mes
                isMobile
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildKpiCard('Cajas Totales', '${widget.state.cashRegisters.length}', Icons.credit_card_outlined, AppColors.primary)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildKpiCard('Aperturas Totales', widget.state.currentShift != null ? '1' : '0', Icons.calculate_outlined, AppColors.success)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildKpiCard('Efectivo Hoy', 'S/ ${widget.state.todayCashRevenue.toStringAsFixed(2)}', Icons.attach_money_rounded, AppColors.success)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildKpiCard('Efectivo del Mes', 'S/ ${widget.state.monthlyCashRevenue.toStringAsFixed(2)}', Icons.trending_up_rounded, AppColors.purple)),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: _buildKpiCard('Cajas Totales', '${widget.state.cashRegisters.length}', Icons.credit_card_outlined, AppColors.primary)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildKpiCard('Aperturas Totales', widget.state.currentShift != null ? '1' : '0', Icons.calculate_outlined, AppColors.success)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildKpiCard('Efectivo Hoy', 'S/ ${widget.state.todayCashRevenue.toStringAsFixed(2)}', Icons.attach_money_rounded, AppColors.success)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildKpiCard('Efectivo del Mes', 'S/ ${widget.state.monthlyCashRevenue.toStringAsFixed(2)}', Icons.trending_up_rounded, AppColors.purple)),
                        ],
                      ),

                const SizedBox(height: 24),

                // Search Bar + Table Container
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
                      // Search input
                      SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: const InputDecoration(
                            hintText: 'Buscar cajas...',
                            prefixIcon: Icon(Icons.search_rounded, size: 18),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Table Header & Rows
                      _buildTable(filteredList, isDark, isMobile),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubTab(String title, bool isDark) {
    final isSelected = widget.state.currentTabIndex == 4 && title == 'Cajas Registradoras';
    return InkWell(
      onTap: () {
        if (title == 'Movimientos') {
          widget.state.setTab(8);
        } else {
          widget.state.setTab(4);
        }
      },
      child: Container(
        height: 48,
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
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary) : AppColors.textSecondary,
          ),
        ),
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

  Widget _buildTable(List<CashRegisterItem> list, bool isDark, bool isMobile) {
    return Column(
      children: [
        // Table Columns Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Expanded(flex: 3, child: Text('NOMBRE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
              Expanded(flex: 3, child: Text('SUCURSAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Text('ESTADO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Text('SESIÓN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Text('CREADA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
              Expanded(flex: 2, child: Text('ACCIONES', textAlign: TextAlign.right, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Rows
        ...list.map((item) {
          final isOpen = widget.state.currentShift?.isOpen ?? false;
          final session = isOpen ? 'Abierta' : 'Cerrada';

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderLight)),
            ),
            child: Row(
              children: [
                // Nombre
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      const Text('\$', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                      const SizedBox(width: 8),
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Sucursal
                Expanded(
                  flex: 3,
                  child: Text(
                    item.branchName,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ),

                // Estado Switch
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.scale(
                      scale: 0.75,
                      child: Switch(
                        value: item.isActive,
                        onChanged: (val) => setState(() => item.isActive = val),
                        activeTrackColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                // Sesión (🔒 Cerrada / 🔓 Abierta)
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(
                        isOpen ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                        size: 14,
                        color: isOpen ? AppColors.success : AppColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        session,
                        style: TextStyle(
                          fontSize: 13,
                          color: isOpen ? AppColors.success : AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Creada
                Expanded(
                  flex: 2,
                  child: const Text(
                    'hace 26 días',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ),

                // Acciones (Play button / dots)
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: isOpen ? 'Ir al POS' : 'Abrir Caja',
                          icon: Icon(
                            isOpen ? Icons.point_of_sale_rounded : Icons.play_arrow_outlined,
                            size: 16,
                            color: AppColors.success,
                          ),
                          onPressed: () {
                            if (isOpen) {
                              widget.state.setTab(2);
                            } else {
                              showDialog(
                                context: context,
                                builder: (ctx) => OpenBoxSessionDialog(
                                  state: widget.state,
                                  initialRegisterId: item.id,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      PopupMenuButton<String>(
                        onSelected: (choice) {
                          if (choice == 'edit') {
                            _showEditDialog(item);
                          } else if (choice == 'delete') {
                            _showDeleteDialog(item);
                          }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                                SizedBox(width: 8),
                                Text('Editar', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.danger),
                                SizedBox(width: 8),
                                Text('Eliminar', style: TextStyle(fontSize: 13, color: AppColors.danger)),
                              ],
                            ),
                          ),
                        ],
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.more_horiz_rounded, size: 18, color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
