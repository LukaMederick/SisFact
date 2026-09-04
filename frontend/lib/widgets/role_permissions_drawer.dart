import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RolePermissionsDrawer extends StatefulWidget {
  final Map<String, dynamic> role;
  final VoidCallback? onSave;

  const RolePermissionsDrawer({super.key, required this.role, this.onSave});

  static void show(BuildContext context, Map<String, dynamic> role, {VoidCallback? onSave}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'RolePermissionsDrawer',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: RolePermissionsDrawer(role: role, onSave: onSave),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }

  @override
  State<RolePermissionsDrawer> createState() => _RolePermissionsDrawerState();
}

class _RolePermissionsDrawerState extends State<RolePermissionsDrawer> {
  late final Set<String> _enabledPermissions;
  late final bool _isAdmin;

  // Master definition of all permissions by category
  static const Map<String, List<Map<String, String>>> _allPermissions = {
    'Ventas': [
      {'id': 'ventas.anular', 'title': 'Anular ventas', 'desc': 'Permite anular ventas existentes'},
      {'id': 'ventas.crear', 'title': 'Crear ventas', 'desc': 'Permite realizar nuevas ventas (acceso al POS)'},
      {'id': 'ventas.comprobantes_directos', 'title': 'Emitir comprobantes directos', 'desc': 'Permite emitir boletas/facturas a SUNAT sin registrar venta'},
      {'id': 'ventas.crear_cotizaciones', 'title': 'Crear cotizaciones', 'desc': 'Permite crear y compartir cotizaciones'},
      {'id': 'ventas.anular_cotizaciones', 'title': 'Anular cotizaciones', 'desc': 'Permite anular cotizaciones'},
      {'id': 'ventas.descuentos', 'title': 'Aplicar descuentos', 'desc': 'Permite aplicar descuentos en ventas y comandas'},
      {'id': 'ventas.editar_cotizaciones', 'title': 'Editar cotizaciones', 'desc': 'Permite editar cotizaciones vigentes y convertirlas en venta'},
      {'id': 'ventas.devoluciones', 'title': 'Devoluciones', 'desc': 'Permite procesar devoluciones'},
      {'id': 'ventas.estadisticas', 'title': 'Estadísticas de ventas', 'desc': 'Permite ver estadísticas y métricas de ventas'},
      {'id': 'ventas.ver', 'title': 'Ver ventas', 'desc': 'Permite visualizar el historial de ventas'},
      {'id': 'ventas.ver_comprobantes', 'title': 'Ver comprobantes directos', 'desc': 'Permite ver el historial de comprobantes emitidos sin venta'},
      {'id': 'ventas.ver_cotizaciones', 'title': 'Ver cotizaciones', 'desc': 'Permite ver el historial y detalle de cotizaciones'},
    ],
    'Caja': [
      {'id': 'caja.cerrar', 'title': 'Cerrar caja', 'desc': 'Permite cerrar un turno de caja'},
      {'id': 'caja.cerrar_jornada', 'title': 'Cerrar jornada', 'desc': 'Permite cerrar la jornada del negocio (cierre del día). Independiente de cashbox.close, que cierra turnos de caja.'},
      {'id': 'caja.historial', 'title': 'Historial de caja', 'desc': 'Permite ver el historial de sesiones de caja'},
      {'id': 'caja.movimientos', 'title': 'Movimientos de caja', 'desc': 'Permite registrar ingresos y egresos de caja'},
      {'id': 'caja.abrir', 'title': 'Abrir caja', 'desc': 'Permite abrir un turno de caja'},
      {'id': 'caja.iniciar_jornada', 'title': 'Iniciar jornada', 'desc': 'Permite iniciar la jornada del negocio, directamente o en cascada al abrir una caja. Sin él, el cajero espera a que un administrador inicie el día.'},
      {'id': 'caja.estado', 'title': 'Estado de cajas', 'desc': 'Permite ver el estado de las cajas'},
    ],
    'Inventario': [
      {'id': 'inv.ajustes', 'title': 'Ajustes de stock', 'desc': 'Permite realizar ajustes de stock'},
      {'id': 'inv.marcas', 'title': 'Gestionar marcas', 'desc': 'Permite gestionar marcas'},
      {'id': 'inv.categorias', 'title': 'Gestionar categorías', 'desc': 'Permite gestionar categorías de productos'},
      {'id': 'inv.crear', 'title': 'Crear productos', 'desc': 'Permite crear nuevos productos'},
      {'id': 'inv.eliminar', 'title': 'Eliminar productos', 'desc': 'Permite eliminar productos'},
      {'id': 'inv.editar', 'title': 'Editar productos', 'desc': 'Permite editar productos existentes'},
      {'id': 'inv.compras', 'title': 'Registrar compras', 'desc': 'Permite registrar compras/entradas'},
      {'id': 'inv.proveedores', 'title': 'Gestionar proveedores', 'desc': 'Permite gestionar proveedores'},
      {'id': 'inv.transferencias', 'title': 'Transferencias', 'desc': 'Permite transferir stock entre sucursales'},
      {'id': 'inv.ver', 'title': 'Ver inventario', 'desc': 'Permite ver productos y stock'},
    ],
    'Empleados': [
      {'id': 'emp.registrar', 'title': 'Registrar empleados', 'desc': 'Permite registrar nuevos empleados'},
      {'id': 'emp.desactivar', 'title': 'Desactivar/eliminar empleados', 'desc': 'Permite desactivar/eliminar empleados'},
      {'id': 'emp.editar', 'title': 'Editar empleados', 'desc': 'Permite editar datos de empleados'},
      {'id': 'emp.roles', 'title': 'Administrar roles y permisos', 'desc': 'Permite administrar roles y permisos'},
      {'id': 'emp.ver', 'title': 'Ver empleados', 'desc': 'Permite ver la lista de empleados'},
    ],
    'Clientes': [
      {'id': 'cli.registrar', 'title': 'Registrar clientes', 'desc': 'Permite registrar nuevos clientes'},
      {'id': 'cli.creditos', 'title': 'Administrar créditos', 'desc': 'Permite administrar créditos de clientes'},
      {'id': 'cli.eliminar', 'title': 'Eliminar clientes', 'desc': 'Permite eliminar clientes'},
      {'id': 'cli.editar', 'title': 'Editar clientes', 'desc': 'Permite editar datos de clientes'},
      {'id': 'cli.ver', 'title': 'Ver clientes', 'desc': 'Permite ver la lista de clientes'},
    ],
    'Reportes': [
      {'id': 'rep.caja', 'title': 'Reportes de caja', 'desc': 'Permite ver reportes de caja'},
      {'id': 'rep.empleados', 'title': 'Reportes de empleados', 'desc': 'Permite ver reportes de empleados'},
      {'id': 'rep.exportar', 'title': 'Exportar reportes', 'desc': 'Permite exportar reportes a Excel/PDF'},
      {'id': 'rep.inventario', 'title': 'Reportes de inventario', 'desc': 'Permite ver reportes de inventario'},
      {'id': 'rep.ventas', 'title': 'Reportes de ventas', 'desc': 'Permite ver reportes de ventas'},
    ],
    'Configuración': [
      {'id': 'cfg.sucursales', 'title': 'Gestionar sucursales', 'desc': 'Permite gestionar sucursales'},
      {'id': 'cfg.datos', 'title': 'Datos generales', 'desc': 'Permite editar datos generales del negocio'},
      {'id': 'cfg.pagos', 'title': 'Métodos de pago', 'desc': 'Permite configurar métodos de pago'},
      {'id': 'cfg.plan', 'title': 'Plan de suscripción', 'desc': 'Permite gestionar plan de suscripción'},
      {'id': 'cfg.impuestos', 'title': 'Configurar impuestos', 'desc': 'Permite configurar impuestos'},
      {'id': 'cfg.series', 'title': 'Series documentales', 'desc': 'Permite configurar series documentales'},
    ],
  };

  @override
  void initState() {
    super.initState();
    final roleTitle = widget.role['title'] as String;
    _isAdmin = roleTitle == 'Administrador';
    _enabledPermissions = <String>{};

    // Pre-populate permissions based on the role specification
    if (_isAdmin) {
      for (final cat in _allPermissions.values) {
        for (final p in cat) {
          _enabledPermissions.add(p['id']!);
        }
      }
    } else if (roleTitle == 'Cajero') {
      _enabledPermissions.addAll([
        'ventas.anular', 'ventas.crear', 'ventas.comprobantes_directos', 'ventas.descuentos', 'ventas.devoluciones', 'ventas.estadisticas',
        'caja.cerrar', 'caja.cerrar_jornada', 'caja.historial', 'caja.movimientos', 'caja.abrir', 'caja.iniciar_jornada', 'caja.estado',
        'inv.compras', 'inv.transferencias', 'inv.ver',
        'cli.registrar', 'cli.eliminar', 'cli.editar', 'cli.ver',
        'rep.caja', 'rep.ventas',
      ]);
    } else if (roleTitle == 'Vendedor') {
      _enabledPermissions.addAll([
        'ventas.crear', 'ventas.ver',
        'inv.ver',
        'cli.registrar', 'cli.ver',
      ]);
    } else if (roleTitle == 'Supervisor') {
      _enabledPermissions.addAll([
        'ventas.anular', 'ventas.crear', 'ventas.comprobantes_directos', 'ventas.descuentos', 'ventas.devoluciones', 'ventas.estadisticas',
        'caja.cerrar', 'caja.cerrar_jornada', 'caja.historial', 'caja.movimientos', 'caja.abrir', 'caja.iniciar_jornada', 'caja.estado',
        'inv.ajustes', 'inv.marcas', 'inv.categorias', 'inv.crear', 'inv.editar', 'inv.compras', 'inv.proveedores', 'inv.transferencias', 'inv.ver',
        'emp.registrar', 'emp.editar', 'emp.ver',
        'cli.registrar', 'cli.creditos', 'cli.editar', 'cli.ver',
        'rep.caja', 'rep.empleados', 'rep.exportar', 'rep.inventario', 'rep.ventas',
      ]);
    } else if (roleTitle == 'Almacenero') {
      _enabledPermissions.addAll([
        'inv.ajustes', 'inv.marcas', 'inv.categorias', 'inv.crear', 'inv.editar', 'inv.compras', 'inv.proveedores', 'inv.transferencias', 'inv.ver',
        'rep.exportar',
      ]);
    }
  }

  void _toggleCategory(String categoryName, bool selectAll) {
    if (_isAdmin) return;
    final list = _allPermissions[categoryName] ?? [];
    setState(() {
      for (final item in list) {
        if (selectAll) {
          _enabledPermissions.add(item['id']!);
        } else {
          _enabledPermissions.remove(item['id']!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final roleTitle = widget.role['title'] as String;

    return Container(
      width: isMobile ? screenWidth : 480,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: isMobile
            ? BorderRadius.zero
            : const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
        border: Border(
          left: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(-8, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: widget.role['iconColor'] as Color? ?? AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          roleTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_isAdmin)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.lock_outline_rounded, size: 11, color: AppColors.textSecondary),
                                SizedBox(width: 3),
                                Text(
                                  'Solo agregar',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                if (_isAdmin) ...[
                  const SizedBox(height: 6),
                  const Text(
                    'El Administrador no puede perder permisos: solo puedes activar los nuevos que vayan apareciendo.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),

          // Permissions Categories List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: _allPermissions.entries.map((entry) {
                final catName = entry.key;
                final items = entry.value;
                final activeCount = items.where((p) => _enabledPermissions.contains(p['id'])).length;
                final totalCount = items.length;
                final isAllActive = activeCount == totalCount;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Category Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                catName,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$activeCount/$totalCount',
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          if (!_isAdmin)
                            InkWell(
                              onTap: () => _toggleCategory(catName, !isAllActive),
                              child: Text(
                                isAllActive ? 'Desmarcar' : 'Marcar todos',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Permission Items Cards (Matching Screenshots 3 & 4)
                      ...items.map((perm) {
                        final id = perm['id']!;
                        final isEnabled = _enabledPermissions.contains(id);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? (isEnabled ? const Color(0xFF1E3A8A).withValues(alpha: 0.15) : const Color(0xFF0F172A))
                                : (isEnabled ? const Color(0xFFF0F7FF) : const Color(0xFFF8FAFC)),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isEnabled
                                  ? (isDark ? const Color(0xFF3B82F6).withValues(alpha: 0.4) : const Color(0xFFBFDBFE))
                                  : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                            ),
                          ),
                          child: InkWell(
                            onTap: _isAdmin
                                ? null
                                : () {
                                    setState(() {
                                      if (isEnabled) {
                                        _enabledPermissions.remove(id);
                                      } else {
                                        _enabledPermissions.add(id);
                                      }
                                    });
                                  },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Checkbox icon
                                  Container(
                                    width: 18,
                                    height: 18,
                                    margin: const EdgeInsets.only(top: 2),
                                    decoration: BoxDecoration(
                                      color: isEnabled ? AppColors.primary : Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isEnabled ? AppColors.primary : const Color(0xFF94A3B8),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isEnabled
                                        ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          perm['title']!,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          perm['desc']!,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Footer (Cancelar & Guardar cambios)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppColors.darkTextPrimary : const Color(0xFF334155),
                      side: BorderSide(color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onSave?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Permisos de $roleTitle actualizados')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Guardar cambios', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
