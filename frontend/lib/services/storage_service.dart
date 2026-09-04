import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  static const String _keyProducts = 'sisfact_products';
  static const String _keyCategories = 'sisfact_categories';
  static const String _keyShift = 'sisfact_current_shift';
  static const String _keySales = 'sisfact_sales';
  static const String _keyCashRegisters = 'sisfact_cash_registers';
  static const String _keyDarkMode = 'sisfact_dark_mode';
  static const String _keyUser = 'sisfact_auth_user';

  // Load Auth User
  static Future<UserProfile?> loadAuthUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyUser);
    if (data == null || data.isEmpty) return null;
    try {
      return UserProfile.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveAuthUser(UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  static Future<void> clearAuthUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }

  // Load Products
  static Future<List<Product>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyProducts);
    if (data == null || data.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(data);
      return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(products.map((e) => e.toJson()).toList());
    await prefs.setString(_keyProducts, data);
  }

  // Load Categories
  static Future<List<Category>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyCategories);
    if (data == null || data.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> list = jsonDecode(data);
      return list.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(categories.map((e) => e.toJson()).toList());
    await prefs.setString(_keyCategories, data);
  }

  // Load Current Shift
  static Future<Shift?> loadCurrentShift() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyShift);
    if (data == null || data.isEmpty) return null;
    try {
      return Shift.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveCurrentShift(Shift? shift) async {
    final prefs = await SharedPreferences.getInstance();
    if (shift == null) {
      await prefs.remove(_keyShift);
    } else {
      await prefs.setString(_keyShift, jsonEncode(shift.toJson()));
    }
  }

  // Load Sales
  static Future<List<Sale>> loadSales() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keySales);
    if (data == null || data.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(data);
      return list.map((e) => Sale.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveSales(List<Sale> sales) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(sales.map((e) => e.toJson()).toList());
    await prefs.setString(_keySales, data);
  }

  // Load Cash Registers
  static Future<List<CashRegisterItem>> loadCashRegisters() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyCashRegisters);
    if (data == null || data.isEmpty) {
      return [
        CashRegisterItem(
          id: 'c0000000-0000-0000-0000-000000000001',
          name: 'Caja Principal',
          branchName: 'Prueba - Principal',
          isActive: true,
          sessionStatus: 'Cerrada',
          createdAt: DateTime.now().subtract(const Duration(days: 26)),
        ),
      ];
    }
    try {
      final List<dynamic> list = jsonDecode(data);
      return list.map((e) => CashRegisterItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveCashRegisters(List<CashRegisterItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_keyCashRegisters, data);
  }

  // Dark Mode Setting
  static Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  static Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDark);
  }
}
