import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/open_shift_drawer.dart';
import '../widgets/free_product_drawer.dart';

class PosScreen extends StatefulWidget {
  final AppState state;

  const PosScreen({super.key, required this.state});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  // Search & Category Filter
  final TextEditingController _searchController = TextEditingController();
  String _posSearchQuery = '';
  String _selectedCategory = 'Todos';

  // Pagination
  int _currentPage = 1;
  static const int _itemsPerPage = 12;

  // Checkout modal state
  String _selectedPaymentMethod = 'Efectivo';
  final _amountPaidController = TextEditingController();
  final _customerNameController = TextEditingController(text: 'Cliente Varios');
  String _receiptType = 'Ticket';

  @override
  void dispose() {
    _searchController.dispose();
    _amountPaidController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  // Quick "Producto Libre" side drawer (Image 1)
  void _showCustomProductDrawer() {
    FreeProductDrawer.show(context, widget.state);
  }

  // Payment checkout flow
  void _handleProcessSale() {
    if (widget.state.cart.isEmpty) return;

    // If shift is not open, offer to open shift
    if (widget.state.currentShift == null || !widget.state.currentShift!.isOpen) {
      _showOpenShiftPrompt();
      return;
    }

    _showCheckoutModal();
  }

  void _showOpenShiftPrompt() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Jornada Cerrada', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
          'Para registrar y cuadrar las ventas en caja necesitas abrir una jornada de operaciones.',
          style: TextStyle(fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              OpenShiftDrawer.show(context, widget.state, onShiftOpened: () {
                _showCheckoutModal();
              });
            },
            child: const Text('Abrir Jornada Ahora'),
          ),
        ],
      ),
    );
  }

  void _showCheckoutModal() {
    _amountPaidController.text = widget.state.cartTotal.toStringAsFixed(2);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final total = widget.state.cartTotal;
            final amountPaid = double.tryParse(_amountPaidController.text) ?? total;
            final change = (amountPaid - total) > 0 ? (amountPaid - total) : 0.0;

            final paymentMethods = [
              {'name': 'Efectivo', 'icon': Icons.payments_outlined},
              {'name': 'Yape', 'icon': Icons.phone_android_rounded},
              {'name': 'Plin', 'icon': Icons.qr_code_rounded},
              {'name': 'Tarjeta', 'icon': Icons.credit_card_rounded},
              {'name': 'Transferencia', 'icon': Icons.account_balance_outlined},
            ];

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                top: 20,
                left: 24,
                right: 24,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cobrar Venta',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Total Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total a pagar:', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            'S/ ${total.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Method selector
                    const Text('Método de Pago', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: paymentMethods.map((pm) {
                        final isSel = _selectedPaymentMethod == pm['name'];
                        return InkWell(
                          onTap: () => setModalState(() => _selectedPaymentMethod = pm['name'] as String),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? AppColors.primary
                                  : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  pm['icon'] as IconData,
                                  size: 16,
                                  color: isSel ? Colors.white : (isDark ? AppColors.darkTextPrimary : const Color(0xFF334155)),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  pm['name'] as String,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel ? Colors.white : (isDark ? AppColors.darkTextPrimary : const Color(0xFF334155)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Cash calculation
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
                                  height: 46,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
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

                    // Customer & Receipt
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
                                decoration: const InputDecoration(hintText: 'Nombre o DNI/RUC'),
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
                                initialValue: _receiptType,
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
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        final sale = await widget.state.completeSale(
                          paymentMethod: _selectedPaymentMethod,
                          amountPaid: amountPaid,
                          customerName: _customerNameController.text.trim(),
                          receiptType: _receiptType,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(ctx);
                        _showTicketDialog(sale);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Container(
            width: 320,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 48),
                const SizedBox(height: 10),
                const Text('¡Venta Exitosa!', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                Text(sale.ticketNumber, style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 14),
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
                    const Text('TOTAL:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    // Filter products
    final filteredProducts = widget.state.products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_posSearchQuery.toLowerCase()) ||
          p.barcode.contains(_posSearchQuery);
      final matchesCategory = _selectedCategory == 'Todos' || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    // Pagination
    final totalPages = (filteredProducts.length / _itemsPerPage).ceil().clamp(1, 999);
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, filteredProducts.length);
    final displayedProducts = (startIndex < filteredProducts.length)
        ? filteredProducts.sublist(startIndex, endIndex)
        : <Product>[];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left 65%: Catalog, Search Bar, Categories (Image 5)
                Expanded(
                  flex: 65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Search + Producto libre + Pagination (Image 5)
                      _buildTopBar(isDark, totalPages),
                      const SizedBox(height: 14),

                      // Category Pills (Image 5)
                      _buildCategoryRow(isDark),
                      const SizedBox(height: 20),

                      // Products Grid or Empty State (Image 5)
                      Expanded(
                        child: displayedProducts.isEmpty
                            ? _buildEmptyState(isDark)
                            : _buildProductsGrid(displayedProducts, isDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // Right 35%: Cart Ticket Panel (Image 5)
                Expanded(
                  flex: 35,
                  child: _buildCartCard(isDark),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildTopBar(isDark, totalPages),
                  const SizedBox(height: 12),
                  _buildCategoryRow(isDark),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 380,
                    child: displayedProducts.isEmpty
                        ? _buildEmptyState(isDark)
                        : _buildProductsGrid(displayedProducts, isDark),
                  ),
                  const SizedBox(height: 16),
                  _buildCartCard(isDark),
                ],
              ),
            ),
    );
  }

  // Top Bar matching Image 5: Search Input + [ Producto libre ] + [ < ] [ > ]
  Widget _buildTopBar(bool isDark, int totalPages) {
    return Row(
      children: [
        // Search Input: "Escanea código de barras o busca productos..."
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  Icons.search_rounded,
                  size: 19,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _posSearchQuery = val;
                        _currentPage = 1;
                      });
                    },
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Escanea código de barras o busca productos...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (_posSearchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _posSearchQuery = '';
                        _currentPage = 1;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),

        // "Producto libre" button (Image 5 & Image 1 Drawer)
        OutlinedButton.icon(
          onPressed: _showCustomProductDrawer,
          icon: const Icon(Icons.all_inbox_outlined, size: 16),
          label: const Text('Producto libre', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
            side: BorderSide(
              color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 10),

        // Pagination buttons < > (Image 5)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: _currentPage > 1
                  ? () => setState(() => _currentPage--)
                  : null,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                  ),
                ),
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                  color: _currentPage > 1
                      ? (isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B))
                      : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                ),
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: _currentPage < totalPages
                  ? () => setState(() => _currentPage++)
                  : null,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                  ),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: _currentPage < totalPages
                      ? (isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B))
                      : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Category Pills matching Image 5
  Widget _buildCategoryRow(bool isDark) {
    final categories = ['Todos', ...widget.state.categories.map((c) => c.name)];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSel = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() {
                _selectedCategory = cat;
                _currentPage = 1;
              }),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSel
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSel
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : Colors.transparent),
                  ),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    color: isSel
                        ? Colors.white
                        : (isDark ? AppColors.darkTextSecondary : const Color(0xFF475569)),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Empty State matching Image 5: "No se encontraron productos"
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.all_inbox_outlined,
            size: 56,
            color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 12),
          Text(
            'No se encontraron productos',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // Products Grid
  Widget _buildProductsGrid(List<Product> products, bool isDark) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.35,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, idx) {
        final prod = products[idx];
        return InkWell(
          onTap: () => widget.state.addToCart(prod),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              ),
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
                        color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        prod.category.isNotEmpty ? prod.category : 'General',
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
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
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
    );
  }

  // Right Cart Panel matching Image 5
  Widget _buildCartCard(bool isDark) {
    final cart = widget.state.cart;
    final total = widget.state.cartTotal;
    final subtotal = widget.state.cartSubtotal;
    final itemsCount = widget.state.cartItemsCount;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: [ 🛒 ] Carrito (X)
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 18,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Carrito ($itemsCount)',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                if (cart.isNotEmpty)
                  InkWell(
                    onTap: widget.state.clearCart,
                    child: const Text(
                      'Vaciar',
                      style: TextStyle(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9)),

          // Cart Center Body: Empty State (Image 5) or Item List
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 46,
                          color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Carrito vacío',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Agrega productos para comenzar',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(14),
                    itemCount: cart.length,
                    separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9)),
                    itemBuilder: (context, idx) {
                      final item = cart[idx];
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
                                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
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
                              mainAxisSize: MainAxisSize.min,
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
          Divider(height: 1, color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9)),

          // Cart Summary Footer (Image 5): Subtotal + Total + [ 💳 Procesar Venta ]
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal:',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      'S/ ${subtotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'S/ ${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Blue Button: [ 💳 Procesar Venta ] (Image 5)
                SizedBox(
                  height: 46,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: cart.isNotEmpty ? _handleProcessSale : null,
                    icon: const Icon(Icons.payment_rounded, size: 18),
                    label: const Text(
                      'Procesar Venta',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
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
