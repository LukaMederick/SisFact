import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class CashMovementDialog extends StatefulWidget {
  final AppState state;
  final String initialType; // 'Ingreso' or 'Egreso'

  const CashMovementDialog({
    super.key,
    required this.state,
    this.initialType = 'Ingreso',
  });

  @override
  State<CashMovementDialog> createState() => _CashMovementDialogState();
}

class _CashMovementDialogState extends State<CashMovementDialog> {
  late String _movementType;
  final _amountController = TextEditingController(text: '0.00');
  final _descriptionController = TextEditingController();
  String _paymentMethod = 'Efectivo';

  final List<String> _paymentMethods = [
    'Efectivo',
    'Yape',
    'Plin',
    'Tarjeta',
    'Transferencia Bancaria',
  ];

  @override
  void initState() {
    super.initState();
    _movementType = widget.initialType;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final description = _descriptionController.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa la descripción del movimiento')),
      );
      return;
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$_movementType de S/ ${amount.toStringAsFixed(2)} registrado con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isIncome = _movementType == 'Ingreso';

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
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
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
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isIncome ? AppColors.successLight : AppColors.dangerLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isIncome ? Icons.arrow_circle_up_rounded : Icons.arrow_circle_down_rounded,
                          size: 22,
                          color: isIncome ? AppColors.success : AppColors.danger,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isIncome ? 'Registrar Ingreso' : 'Registrar Egreso',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Registra un movimiento manual en tu sesión de caja activa.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
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
                  // Tipo de Movimiento *
                  Row(
                    children: [
                      Text(
                        'Tipo de Movimiento',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const Text(' *', style: TextStyle(fontSize: 13, color: AppColors.danger)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Radio Ingreso
                      InkWell(
                        onTap: () => setState(() => _movementType = 'Ingreso'),
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'Ingreso',
                              groupValue: _movementType,
                              onChanged: (val) => setState(() => _movementType = val!),
                              activeColor: AppColors.primary,
                            ),
                            const Icon(Icons.arrow_circle_up_rounded, size: 18, color: AppColors.success),
                            const SizedBox(width: 6),
                            Text(
                              'Ingreso',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isIncome ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Radio Egreso
                      InkWell(
                        onTap: () => setState(() => _movementType = 'Egreso'),
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'Egreso',
                              groupValue: _movementType,
                              onChanged: (val) => setState(() => _movementType = val!),
                              activeColor: AppColors.primary,
                            ),
                            const Icon(Icons.arrow_circle_down_rounded, size: 18, color: AppColors.danger),
                            const SizedBox(width: 6),
                            Text(
                              'Egreso',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: !isIncome ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Monto *
                  Row(
                    children: [
                      Text(
                        'Monto',
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
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      prefixText: 'S/ ',
                      prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      hintText: '0.00',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Método de Pago
                  const Text(
                    'Método de Pago',
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
                        value: _paymentMethod,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                        items: _paymentMethods.map((m) {
                          final isSelected = _paymentMethod == m;
                          return DropdownMenuItem<String>(
                            value: m,
                            child: Row(
                              children: [
                                const Icon(Icons.credit_card_outlined, size: 17, color: AppColors.textSecondary),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    m,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _paymentMethod = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descripción *
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Descripción',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          const Text(' *', style: TextStyle(fontSize: 13, color: AppColors.danger)),
                        ],
                      ),
                      Text(
                        '${_descriptionController.text.length}/200',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    maxLength: 200,
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) => const SizedBox.shrink(),
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Ej: Ingreso por cambio de billete, depósito inicial...',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Describe el motivo del movimiento',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
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
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        isIncome ? 'Registrar Ingreso' : 'Registrar Egreso',
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
