import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NewRoleDialog extends StatefulWidget {
  const NewRoleDialog({super.key});

  @override
  State<NewRoleDialog> createState() => _NewRoleDialogState();
}

class _NewRoleDialogState extends State<NewRoleDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _selectedColorIndex = 0;
  String _copyFromRole = 'Sin copiar (empieza sin permisos)';

  final List<Color> _colors = const [
    Color(0xFF10B981), // Teal/Green
    Color(0xFF2563EB), // Blue
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEF4444), // Red
    Color(0xFFF97316), // Orange
    Color(0xFFD97706), // Amber
    Color(0xFF06B6D4), // Cyan
    Color(0xFFBE185D), // Magenta
  ];

  final List<String> _roleOptions = const [
    'Sin copiar (empieza sin permisos)',
    'Administrador',
    'Supervisor',
    'Cajero',
    'Almacenero',
    'Vendedor',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa el nombre del rol')),
      );
      return;
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rol "$name" creado con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: isMobile ? Alignment.center : Alignment.centerRight,
      insetPadding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          : EdgeInsets.zero,
      child: Container(
        width: isMobile ? double.infinity : 460,
        height: isMobile ? null : double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: isMobile
              ? BorderRadius.circular(16)
              : const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
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
            // Header (Screenshot 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nuevo Rol',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Crea un rol personalizado para asignar a tus empleados.\nPodras configurar sus permisos despues.',
                        style: TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.3),
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

            // Form Body
            Expanded(
              flex: isMobile ? 0 : 1,
              child: ListView(
                shrinkWrap: isMobile,
                padding: const EdgeInsets.all(20),
                children: [
                  // Nombre *
                  Row(
                    children: [
                      Text(
                        'Nombre',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const Text(' *', style: TextStyle(fontSize: 13, color: AppColors.danger)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Ej: Mesero, Cajero Senior',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descripcion
                  const Text(
                    'Descripcion',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Descripcion breve del rol',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Color Picker Circles (Screenshot 1)
                  const Text(
                    'Color',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_colors.length, (index) {
                      final isSelected = _selectedColorIndex == index;
                      return InkWell(
                        onTap: () => setState(() => _selectedColorIndex = index),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _colors[index],
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: isDark ? Colors.white : AppColors.textPrimary,
                                    width: 2.5,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Copiar permisos de (Dropdown)
                  const Text(
                    'Copiar permisos de',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkInputBg : AppColors.inputBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _copyFromRole,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                        items: _roleOptions.map((r) {
                          return DropdownMenuItem<String>(
                            value: r,
                            child: Text(
                              r,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _copyFromRole = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'El nuevo rol tendra los mismos permisos que el rol seleccionado. Podras modificarlos despues.',
                    style: TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.3),
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
                      onPressed: _nameController.text.trim().isNotEmpty ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: const Color(0xFF93C5FD),
                        disabledForegroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Crear rol'),
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
