import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  // Navigation
  int currentTabIndex = 0; // 0: Inicio, 1: Inventario, 2: Vender, 3: Ventas, 4: Cajas
  String inventorySubTab = 'Productos';
  String cashRegisterSubTab = 'Cajas Registradoras';

  // Store & User Info
  final StoreInfo store = const StoreInfo();
  final UserProfile user = const UserProfile();

  // Dark Mode
  bool isDarkMode = false;

  // Selected Date Filter
  String dateFilterLabel = 'Hoy';
  DateTime selectedDate = DateTime(2026, 8, 30);
  DateTime startDate = DateTime(2026, 8, 30, 0, 0, 0);
  DateTime endDate = DateTime(2026, 8, 30, 23, 59, 59);

  // Entities
  List<Product> products = [];
  List<Category> categories = [];
  List<Sale> sales = [];
  List<CashRegisterItem> cashRegisters = [];
  Shift? currentShift;

  // POS Cart
  List<CartItem> cart = [];

  // Initial loading status
  bool isLoading = true;

  AppState() {
    _initData();
  }

  Future<void> _initData() async {
    isDarkMode = await StorageService.loadDarkMode();
    products = await StorageService.loadProducts();
    categories = await StorageService.loadCategories();
    currentShift = await StorageService.loadCurrentShift();
    sales = await StorageService.loadSales();
    cashRegisters = await StorageService.loadCashRegisters();
    isLoading = false;
    notifyListeners();
  }

  // Navigation handlers
  void setTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  void setInventorySubTab(String tab) {
    inventorySubTab = tab;
    notifyListeners();
  }

  void setCashRegisterSubTab(String tab) {
    cashRegisterSubTab = tab;
    notifyListeners();
  }

  // Dark Mode Toggle
  Future<void> toggleDarkMode() async {
    isDarkMode = !isDarkMode;
    await StorageService.saveDarkMode(isDarkMode);
    notifyListeners();
  }

  // Date Filter Selection
  void setDateFilter(String label, DateTime start, DateTime end, {DateTime? specificDate}) {
    dateFilterLabel = label;
    startDate = start;
    endDate = end;
    if (specificDate != null) {
      selectedDate = specificDate;
    } else {
      selectedDate = start;
    }
    notifyListeners();
  }

  String get formattedSelectedDate {
    return DateFormat('dd/MM/yyyy').format(selectedDate);
  }

  // Shift Management (Jornada)
  Future<void> openShift(double initialAmount, String notes) async {
    final newShift = Shift(
      id: const Uuid().v4(),
      openedAt: DateTime.now(),
      initialAmount: initialAmount,
      openingNotes: notes,
      status: 'Abierta',
    );
    currentShift = newShift;
    
    // Update cash register session status
    if (cashRegisters.isNotEmpty) {
      cashRegisters[0].sessionStatus = 'Abierta';
      await StorageService.saveCashRegisters(cashRegisters);
    }

    await StorageService.saveCurrentShift(currentShift);
    ApiService.openShift(initialAmount, notes);
    notifyListeners();
  }

  Future<void> closeShift(double finalAmount, String notes) async {
    if (currentShift != null) {
      currentShift = null;

      if (cashRegisters.isNotEmpty) {
        cashRegisters[0].sessionStatus = 'Cerrada';
        await StorageService.saveCashRegisters(cashRegisters);
      }

      await StorageService.saveCurrentShift(null);
      ApiService.closeShift(finalAmount, notes);
      notifyListeners();
    }
  }

  // Product Management
  Future<void> addProduct(Product product) async {
    products.insert(0, product);
    await StorageService.saveProducts(products);
    ApiService.createProduct(product);
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    products.removeWhere((p) => p.id == id);
    await StorageService.saveProducts(products);
    notifyListeners();
  }

  // Inventory KPI calculations
  int get totalProductsCount => products.length;
  int get activeProductsCount => products.where((p) => p.isActive).length;
  int get criticalProductsCount => products.where((p) => p.stock > 0 && p.stock <= p.minStock).length;
  int get outOfStockCount => products.where((p) => p.stock <= 0).length;

  // Cart Management
  void addToCart(Product product) {
    final index = cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cart[index].quantity++;
    } else {
      cart.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateCartQuantity(String productId, int delta) {
    final index = cart.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final newQty = cart[index].quantity + delta;
      if (newQty <= 0) {
        cart.removeAt(index);
      } else {
        cart[index].quantity = newQty;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  double get cartSubtotal => cart.fold(0.0, (sum, item) => sum + item.total);
  double get cartTotal => cartSubtotal;
  int get cartItemsCount => cart.fold(0, (sum, item) => sum + item.quantity);

  // Sales Management
  Future<Sale> completeSale({
    required String paymentMethod,
    required double amountPaid,
    String customerName = 'Cliente Varios',
    String receiptType = 'Ticket',
    String notes = '',
  }) async {
    final nextNumber = sales.length + 1;
    final ticketNumber = 'B001-${nextNumber.toString().padLeft(6, '0')}';
    
    final saleItems = cart.map((item) => SaleItem(
      productId: item.product.id,
      productName: item.product.name,
      quantity: item.quantity.toDouble(),
      unitPrice: item.customPrice,
      total: item.total,
    )).toList();

    final sale = Sale(
      id: const Uuid().v4(),
      ticketNumber: ticketNumber,
      receiptType: receiptType,
      paymentMethod: paymentMethod,
      subtotal: cartSubtotal,
      total: cartTotal,
      amountPaid: amountPaid,
      changeGiven: (amountPaid - cartTotal) > 0 ? (amountPaid - cartTotal) : 0.0,
      itemsCount: cartItemsCount,
      customerName: customerName,
      notes: notes,
      items: saleItems,
    );

    // Reduce inventory
    for (final item in cart) {
      final pIndex = products.indexWhere((p) => p.id == item.product.id);
      if (pIndex >= 0 && products[pIndex].trackInventory) {
        products[pIndex] = products[pIndex].copyWith(
          stock: products[pIndex].stock - item.quantity,
        );
      }
    }
    await StorageService.saveProducts(products);

    sales.insert(0, sale);
    await StorageService.saveSales(sales);
    ApiService.createSale(sale);

    clearCart();
    notifyListeners();
    return sale;
  }

  // Filtered Sales for selected period
  List<Sale> get filteredSales {
    return sales.where((s) {
      return s.createdAt.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
             s.createdAt.isBefore(endDate.add(const Duration(seconds: 1)));
    }).toList();
  }

  // Sales KPIs for selected period
  int get filteredTotalSales => filteredSales.length;
  double get filteredTotalRevenue => filteredSales.fold(0.0, (sum, s) => sum + s.total);
  double get filteredAverageTicket => filteredTotalSales > 0 ? filteredTotalRevenue / filteredTotalSales : 0.0;
  int get filteredProductsSold => filteredSales.fold(0, (sum, s) => sum + s.itemsCount);

  // Today specific revenues
  double get todayTotalRevenue {
    final now = selectedDate;
    final todaySales = sales.where((s) =>
      s.createdAt.year == now.year &&
      s.createdAt.month == now.month &&
      s.createdAt.day == now.day
    );
    return todaySales.fold(0.0, (sum, s) => sum + s.total);
  }

  double get todayCashRevenue {
    final now = selectedDate;
    final todaySales = sales.where((s) =>
      s.createdAt.year == now.year &&
      s.createdAt.month == now.month &&
      s.createdAt.day == now.day &&
      s.paymentMethod == 'Efectivo'
    );
    return todaySales.fold(0.0, (sum, s) => sum + s.total);
  }

  double get monthlyCashRevenue {
    final now = selectedDate;
    final monthlySales = sales.where((s) =>
      s.createdAt.year == now.year &&
      s.createdAt.month == now.month &&
      s.paymentMethod == 'Efectivo'
    );
    return monthlySales.fold(0.0, (sum, s) => sum + s.total);
  }

  // Top Sold Products
  Map<String, int> get topSoldProducts {
    final map = <String, int>{};
    for (final s in filteredSales) {
      for (final item in s.items) {
        map[item.productName] = (map[item.productName] ?? 0) + item.quantity.toInt();
      }
    }
    return map;
  }
}
