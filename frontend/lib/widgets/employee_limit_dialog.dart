import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EmployeeLimitDialog extends StatelessWidget {
  const EmployeeLimitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 480,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Close Button top right
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // Amber/Yellow Avatar Circle (Screenshot 2)
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_alt_outlined,
                size: 32,
                color: Color(0xFFD97706),
              ),
            ),
            const SizedBox(height: 18),

            // Title
            Text(
              'Límite de empleados alcanzado',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Has alcanzado el número máximo de empleados permitidos en tu plan actual.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 22),

            // Usage Card Box (Screenshot 2)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Uso actual', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      Text('1 / 1 empleados', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.danger)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: Color(0xFFFEE2E2),
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.danger),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Text('Plan actual: ', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      Text('Gratis', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Benefits List
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mejora tu plan para obtener:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _buildBenefitRow('Más empleados permitidos'),
                const SizedBox(height: 6),
                _buildBenefitRow('Roles personalizados'),
                const SizedBox(height: 6),
                _buildBenefitRow('Control de acceso avanzado'),
              ],
            ),
            const SizedBox(height: 24),

            // Blue Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Planes y Suscripciones de SisFact')),
                  );
                },
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: const Text('Mejorar plan →', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Text button below
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Entendido, continuar más tarde',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Row(
      children: [
        const Icon(Icons.workspace_premium_outlined, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
      ],
    );
  }
}
