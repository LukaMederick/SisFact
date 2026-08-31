import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../state/app_state.dart';

class NewProductDialog extends StatefulWidget {
  final AppState state;

  const NewProductDialog({super.key, required this.state});

  @override
  State<NewProductDialog> createState() => _NewProductDialogState();
}

class _NewProductDialogState extends State<NewProductDialog> {
  final _barcodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController(text: '0.00');
  final _costController = TextEditingController(text: '0.00');
  final _stockController = TextEditingController(text: '10');
  final _minStockController = TextEditingController(text: '2');
  final _descriptionController = TextEditingController();
  final _brandController = TextEditingController();
  final _supplierController = TextEditingController();

  String _selectedCategory = 'Bebidas';
  bool _printDescriptionOnTicket = false;
  bool _hasVariants = false;
  bool _trackInventory = true;
  bool _isActive = true;
  bool _isFavorite = false;

  bool _infoExpanded = true;
  bool _detailsExpanded = true;

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _costController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa el nombre del producto')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final cost = double.tryParse(_costController.text.trim()) ?? 0.0;
    final stock = double.tryParse(_stockController.text.trim()) ?? 0.0;
    final minStock = double.tryParse(_minStockController.text.trim()) ?? 0.0;

    final newProduct = Product(
      id: const Uuid().v4(),
      barcode: _barcodeController.text.trim(),
      name: name,
      description: _descriptionController.text.trim(),
      printDescriptionOnTicket: _printDescriptionOnTicket,
      price: price,
      cost: cost,
      category: _selectedCategory,
      brand: _brandController.text.trim().isNotEmpty ? _brandController.text.trim() : null,
      supplier: _supplierController.text.trim().isNotEmpty ? _supplierController.text.trim() : null,
      hasVariants: _hasVariants,
      trackInventory: _trackInventory,
      stock: stock,
      minStock: minStock,
      isActive: _isActive,
      isFavorite: _isFavorite,
    );

    widget.state.addProduct(newProduct);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Producto "${newProduct.name}" creado con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: isMobile ? Alignment.center : Alignment.centerRight,
      insetPadding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          : EdgeInsets.zero,
      child: Container(
        width: isMobile ? double.infinity : 480,
        height: isMobile ? MediaQuery.of(context).size.height * 0.9 : double.infinity,
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
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nuevo Producto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Completa los datos para crear un nuevo producto',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
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

            // Form Body (Scrollable)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Barcode input
                  const Text(
                    'Código de Barras (opcional)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _barcodeController,
                          decoration: const InputDecoration(
                            hintText: 'Escanea o escribe el código',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
                          tooltip: 'Escanear',
                          onPressed: () {
                            setState(() {
                              _barcodeController.text = '775${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Usa el botón de cámara para escanear o escribe manualmente',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),

                  // Section 1: Información del Producto (Accordion)
                  _buildAccordionHeader(
                    title: 'Información del Producto',
                    icon: Icons.all_inbox_outlined,
                    iconColor: AppColors.primary,
                    isExpanded: _infoExpanded,
                    onToggle: () => setState(() => _infoExpanded = !_infoExpanded),
                  ),
                  if (_infoExpanded) ...[
                    const SizedBox(height: 12),
                    // Image upload box
                    const Text('Imágenes (opcional · hasta 5)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      height: 80,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10),
                        color: isDark ? AppColors.darkInputBg : AppColors.inputBg,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_upload_outlined, size: 20, color: AppColors.textMuted),
                          SizedBox(height: 4),
                          Text('Subir\nMáx. 5MB', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Nombre del Producto *
                    const Text('Nombre del Producto *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Ej: Laptop HP 15',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Row: Precio de Venta * & Costo
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Precio de Venta *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _priceController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(hintText: '0.00'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Costo (opcional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _costController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(hintText: '0.00'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Categoría (opcional)
                    const Text('Categoría (opcional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(),
                      items: widget.state.categories.map((c) {
                        return DropdownMenuItem(value: c.name, child: Text(c.name));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Section 2: Variantes
                  _buildToggleCard(
                    title: 'Variantes',
                    icon: Icons.layers_outlined,
                    value: _hasVariants,
                    onChanged: (val) => setState(() => _hasVariants = val),
                  ),
                  const SizedBox(height: 12),

                  // Section 3: Inventario
                  _buildToggleCard(
                    title: 'Inventario',
                    icon: Icons.bar_chart_rounded,
                    value: _trackInventory,
                    onChanged: (val) => setState(() => _trackInventory = val),
                  ),
                  if (_trackInventory) ...[
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Stock Inicial', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: _stockController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(hintText: '0'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Stock Mínimo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: _minStockController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(hintText: '0'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Section 4: Detalles Adicionales
                  _buildAccordionHeader(
                    title: 'Detalles Adicionales',
                    icon: Icons.tune_rounded,
                    iconColor: AppColors.primary,
                    isExpanded: _detailsExpanded,
                    onToggle: () => setState(() => _detailsExpanded = !_detailsExpanded),
                  ),
                  if (_detailsExpanded) ...[
                    const SizedBox(height: 12),
                    const Text('Descripción (opcional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Descripción del producto',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: _printDescriptionOnTicket,
                          onChanged: (val) => setState(() => _printDescriptionOnTicket = val ?? false),
                          activeColor: AppColors.primary,
                        ),
                        const Expanded(
                          child: Text(
                            'Imprimir descripción en el ticket de venta',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Marca
                    const Text('Marca (opcional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _brandController,
                      decoration: const InputDecoration(hintText: 'Buscar o crear marca...'),
                    ),
                    const SizedBox(height: 12),

                    // Proveedor
                    const Text('Proveedor (opcional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _supplierController,
                      decoration: const InputDecoration(hintText: 'Buscar o crear proveedor...'),
                    ),
                    const SizedBox(height: 16),

                    // Estado Switch Card
                    _buildSwitchCard(
                      title: 'Estado',
                      subtitle: _isActive ? 'El producto está activo' : 'El producto está inactivo',
                      value: _isActive,
                      onChanged: (val) => setState(() => _isActive = val),
                    ),
                    const SizedBox(height: 10),

                    // Favorito Switch Card
                    _buildSwitchCard(
                      title: 'Favorito',
                      subtitle: _isFavorite ? 'Producto destacado' : 'Orden normal',
                      value: _isFavorite,
                      onChanged: (val) => setState(() => _isFavorite = val),
                    ),
                  ],
                ],
              ),
            ),

            // Footer Actions
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
                      child: const Text('Crear Producto'),
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

  Widget _buildAccordionHeader({
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onToggle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInputBg : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInputBg : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
