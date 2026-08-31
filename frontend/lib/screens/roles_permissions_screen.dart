import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../widgets/new_role_dialog.dart';

class RolesPermissionsScreen extends StatelessWidget {
  final AppState state;

  const RolesPermissionsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    final roles = [
      {
        'title': 'Administrador',
        'isSystem': true,
        'icon': Icons.shield_outlined,
        'iconColor': const Color(0xFF6366F1),
        'iconBg': const Color(0xFFEEF2FF),
        'description': 'Control total del sistema. Acceso a todas las funciones.',
        'employeesCount': 1,
        'permissionsCount': 64,
        'isViewOnly': true,
      },
      {
        'title': 'Supervisor',
        'isSystem': true,
        'icon': Icons.shield_outlined,
        'iconColor': const Color(0xFF8B5CF6),
        'iconBg': const Color(0xFFF5F3FF),
        'description': 'Supervisa operaciones, puede ver reportes y gestionar empleados.',
        'employeesCount': 0,
        'permissionsCount': 34,
        'isViewOnly': false,
      },
      {
        'title': 'Cajero',
        'isSystem': true,
        'icon': Icons.shield_outlined,
        'iconColor': const Color(0xFF06B6D4),
        'iconBg': const Color(0xFFECFEFF),
        'description': 'Realiza ventas y maneja la caja registradora.',
        'employeesCount': 0,
        'permissionsCount': 34,
        'isViewOnly': false,
      },
      {
        'title': 'Almacenero',
        'isSystem': true,
        'icon': Icons.shield_outlined,
        'iconColor': const Color(0xFFF59E0B),
        'iconBg': const Color(0xFFFEF3C7),
        'description': 'Gestiona el inventario y stock de productos.',
        'employeesCount': 0,
        'permissionsCount': 10,
        'isViewOnly': false,
      },
      {
        'title': 'Vendedor',
        'isSystem': true,
        'icon': Icons.shield_outlined,
        'iconColor': const Color(0xFF10B981),
        'iconBg': const Color(0xFFECFDF5),
        'description': 'Realiza ventas y atiende clientes.',
        'employeesCount': 0,
        'permissionsCount': 5,
        'isViewOnly': false,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row (Screenshot 5)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Roles y Permisos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Configura los accesos y permisos de cada rol',
                    style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => const NewRoleDialog(),
                  );
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nuevo Rol'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 2-Column Grid of Role Cards (Screenshot 5)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 2 : 1,
              mainAxisExtent: 160,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return _buildRoleCard(context, role, isDark);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, Map<String, dynamic> role, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Icon + Title + System Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDark ? (role['iconColor'] as Color).withOpacity(0.2) : role['iconBg'] as Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  role['icon'] as IconData,
                  size: 20,
                  color: role['iconColor'] as Color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          role['title'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (role['isSystem'] as bool)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_outline_rounded, size: 10, color: AppColors.textSecondary),
                                SizedBox(width: 3),
                                Text(
                                  'Sistema',
                                  style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role['description'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bottom Row: Employees count + Permissions count + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people_outline_rounded, size: 15, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    '${role['employeesCount']} empleado${role['employeesCount'] == 1 ? '' : 's'}  ·  ${role['permissionsCount']} permisos',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_outlined, size: 16, color: AppColors.textMuted),
                    tooltip: 'Duplicar rol',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Permisos de ${role['title']}')),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          role['isViewOnly'] as bool ? Icons.verified_user_outlined : Icons.edit_outlined,
                          size: 14,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          role['isViewOnly'] as bool ? 'Ver permisos' : 'Editar permisos',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
