import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../state/app_state.dart';

class PosScreen extends StatefulWidget {
  final AppState state;

  const PosScreen({super.key, required this.state});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  // Shift opening controllers
  final _initialAmountController = TextEditingController(text: '0.00');
  final _openingNotesController = TextEditingController();

  // POS Search & Category Filter
  String _posSearchQuery = '';
  String _selectedCategory = 'Todos';

  // Checkout modal state
  String _selectedPaymentMethod = 'Efectivo';
  final _amountPaidController = TextEditingController();
  final _customerNameController = TextEditingController(text: 'Cliente Varios');
  String _receiptType = 'Ticket';

  @override
  void dispose() {
    _initialAmountController.dispose();
    _openingNotesController.dispose();
    _amountPaidController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  void _openShift() {
    final amount = double.tryParse(_initialAmountController.text.trim()) ?? 0.0;
    final notes = _openingNotesController.text.trim().isNotEmpty
        ? _openingNotesController.text.trim()
        : 'Apertura normal';

    widget.state.openShift(amount, notes);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jornada abierta correctamente')),
    );
  }

  void _showCloseShiftDialog() {
    final finalAmountCtrl = TextEditingController(text: widget.state.todayCashRevenue.toStringAsFixed(2));
    final closingNotesCtrl = TextEditingController(text: 'Cierre normal');

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Cerrar Jornada', style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ingresa el monto final en caja para el arqueo:', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              TextField(
                controller: finalAmountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Monto final en caja (S/)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: closingNotesCtrl,
                decoration: const InputDecoration(labelText: 'Notas de cierre'),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final amt = double.tryParse(finalAmountCtrl.text.trim()) ?? 0.0;
                widget.state.closeShift(amt, closingNotesCtrl.text.trim());
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jornada cerrada correctamente')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              child: const Text('Cerrar Jornada'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutDialog() {
    if (widget.state.cart.isEmpty) return;

    _amountPaidController.text = widget.state.cartTotal.toStringAsFixed(2);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final amountPaid = double.tryParse(_amountPaidController.text) ?? widget.state.cartTotal;
            final change = (amountPaid - widget.state.cartTotal) > 0 ? (amountPaid - widget.state.cartTotal) : 0.0;

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Container(
                width: 480,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Completar Venta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Total display
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E3A8A).withOpacity(0.3) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL A COBRAR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          Text(
                            'S/ ${widget.state.cartTotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Method selector
                    const Text('Método de Pago', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Efectivo', 'Tarjeta', 'Yape', 'Plin'].map((method) {
                        final isSel = _selectedPaymentMethod == method;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: InkWell(
                              onTap: () => setModalState(() => _selectedPaymentMethod = method),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.primary : (isDark ? AppColors.darkInputBg : AppColors.inputBg),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: isSel ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.border)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  method,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Amount paid & change
                    if (_selectedPaymentMethod == 'Efectivo') ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Monto Recibido', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: _amountPaidController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onChanged: (_) => setModalState(() {}),
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
                                const Text('Vuelto / Cambio', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Container(
                                  height: 48,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkInputBg : AppColors.inputBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                                  ),
                                  child: Text(
                                    'S/ ${change.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.success),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Customer Name & Receipt Type
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Cliente', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _customerNameController,
                                decoration: const InputDecoration(hintText: 'Nombre o RUC/DNI'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Comprobante', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: _receiptType,
                                decoration: const InputDecoration(),
                                items: ['Ticket', 'Boleta', 'Factura'].map((t) {
                                  return DropdownMenuItem(value: t, child: Text(t));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setModalState(() => _receiptType = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () async {
                        final sale = await widget.state.completeSale(
                          paymentMethod: _selectedPaymentMethod,
                          amountPaid: amountPaid,
                          customerName: _customerNameController.text.trim(),
                          receiptType: _receiptType,
                        );
                        Navigator.of(context).pop();
                        _showTicketDialog(sale);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Completar y Emitir Ticket', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTicketDialog(Sale sale) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Container(
            width: 340,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 50),
                const SizedBox(height: 12),
                const Text('¡Venta Exitosa!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                Text(sale.ticketNumber, style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                Divider(color: isDark ? AppColors.darkBorder : AppColors.border),
                ...sale.items.map((it) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${it.quantity.toInt()}x ${it.productName}', style: const TextStyle(fontSize: 12)),
                      Text('S/ ${it.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )),
                Divider(color: isDark ? AppColors.darkBorder : AppColors.border),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    Text('S/ ${sale.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOpen = widget.state.currentShift?.isOpen ?? false;

    // Screenshot 5: Abrir Jornada Card if shift is closed
    if (!isOpen) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 440,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Register Icon in blue circular box
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.point_of_sale_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title: Abrir Jornada
                Center(
                  child: Text(
                    'Abrir Jornada',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Abre la jornada para comenzar las operaciones del día.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(height: 24),

                // Monto inicial en caja (opcional)
                const Text(
                  'Monto inicial en caja (opcional)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _initialAmountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(hintText: '0.00'),
                ),
                const SizedBox(height: 16),

                // Notas de apertura (opcional)
                const Text(
                  'Notas de apertura (opcional)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _openingNotesController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Ej: Apertura normal'),
                ),
                const SizedBox(height: 24),

                // Blue Action Button
                ElevatedButton.icon(
                  onPressed: _openShift,
                  icon: const Icon(Icons.point_of_sale_rounded, size: 18),
                  label: const Text('Abrir Jornada'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // When shift IS open: Full POS Terminal
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    final filteredProducts = widget.state.products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_posSearchQuery.toLowerCase()) ||
          p.barcode.contains(_posSearchQuery);
      final matchesCategory = _selectedCategory == 'Todos' || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left: Catalog & Search
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Search and Close Shift bar
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (val) => setState(() => _posSearchQuery = val),
                              decoration: const InputDecoration(
                                hintText: 'Buscar producto por nombre o código de barras...',
                                prefixIcon: Icon(Icons.search_rounded, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: _showCloseShiftDialog,
                            icon: const Icon(Icons.lock_clock_outlined, size: 16, color: AppColors.danger),
                            label: const Text('Cerrar Jornada', style: TextStyle(color: AppColors.danger)),
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Category Chips Filter
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['Todos', ...widget.state.categories.map((c) => c.name)].map((cat) {
                            final isSel = _selectedCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(cat),
                                selected: isSel,
                                onSelected: (_) => setState(() => _selectedCategory = cat),
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
                                  color: isSel ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Products Grid
                      Expanded(
                        child: filteredProducts.isEmpty
                            ? const Center(
                                child: Text('No hay productos disponibles', style: TextStyle(color: AppColors.textMuted)),
                              )
                            : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.25,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: filteredProducts.length,
                                itemBuilder: (context, idx) {
                                  final prod = filteredProducts[idx];
                                  return InkWell(
                                    onTap: () => widget.state.addToCart(prod),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isDark ? AppColors.darkCard : AppColors.card,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFEFF6FF),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  prod.category,
                                                  style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              Text(
                                                'Stock: ${prod.stock.toInt()}',
                                                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            prod.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700,
                                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'S/ ${prod.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right: Cart Ticket
              Container(
                width: 360,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.card,
                  border: Border(
                    left: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                ),
                child: _buildCartPanel(isDark),
              ),
            ],
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _posSearchQuery = val),
                        decoration: const InputDecoration(
                          hintText: 'Buscar...',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.lock_clock_outlined, color: AppColors.danger),
                      onPressed: _showCloseShiftDialog,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(child: Text('No hay productos'))
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, idx) {
                          final prod = filteredProducts[idx];
                          return ListTile(
                            title: Text(prod.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('S/ ${prod.price.toStringAsFixed(2)} · Stock: ${prod.stock.toInt()}'),
                            trailing: ElevatedButton(
                              onPressed: () => widget.state.addToCart(prod),
                              child: const Icon(Icons.add_rounded, size: 16),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                height: 180,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.card,
                  border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ítems: ${widget.state.cartItemsCount}'),
                        Text('Total: S/ ${widget.state.cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.state.cart.isNotEmpty ? _showCheckoutDialog : null,
                        child: Text('Cobrar S/ ${widget.state.cartTotal.toStringAsFixed(2)}'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildCartPanel(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Cart Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Ticket Actual',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (widget.state.cart.isNotEmpty)
                TextButton(
                  onPressed: widget.state.clearCart,
                  child: const Text('Limpiar', style: TextStyle(fontSize: 12, color: AppColors.danger)),
                ),
            ],
          ),
        ),
        Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),

        // Cart Items
        Expanded(
          child: widget.state.cart.isEmpty
              ? const Center(
                  child: Text('El ticket está vacío', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: widget.state.cart.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                  itemBuilder: (context, idx) {
                    final item = widget.state.cart[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'S/ ${item.customPrice.toStringAsFixed(2)} c/u',
                                  style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline_rounded, size: 18),
                                onPressed: () => widget.state.updateCartQuantity(item.product.id, -1),
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                                onPressed: () => widget.state.updateCartQuantity(item.product.id, 1),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 65,
                            child: Text(
                              'S/ ${item.total.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        // Cart Footer Total & Checkout
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  Text('S/ ${widget.state.cartSubtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  Text(
                    'S/ ${widget.state.cartTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.state.cart.isNotEmpty ? _showCheckoutDialog : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Cobrar (S/ ${widget.state.cartTotal.toStringAsFixed(2)})',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
