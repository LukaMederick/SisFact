import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  static Future<bool> checkHealth() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/health')).timeout(const Duration(seconds: 2));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<List<Product>?> getProducts() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/products')).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return null;
  }

  static Future<Product?> createProduct(Product product) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      ).timeout(const Duration(seconds: 3));
      if (res.statusCode == 201 || res.statusCode == 200) {
        return Product.fromJson(jsonDecode(res.body));
      }
    } catch (_) {}
    return null;
  }

  static Future<Shift?> openShift(double initialAmount, String notes) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/shifts/open'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'initial_amount': initialAmount, 'opening_notes': notes}),
      ).timeout(const Duration(seconds: 3));
      if (res.statusCode == 201 || res.statusCode == 200) {
        return Shift.fromJson(jsonDecode(res.body));
      }
    } catch (_) {}
    return null;
  }

  static Future<Shift?> closeShift(double finalAmount, String notes) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/shifts/close'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'final_amount': finalAmount, 'closing_notes': notes}),
      ).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        return Shift.fromJson(jsonDecode(res.body));
      }
    } catch (_) {}
    return null;
  }

  static Future<Sale?> createSale(Sale sale) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/sales'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(sale.toJson()),
      ).timeout(const Duration(seconds: 3));
      if (res.statusCode == 201 || res.statusCode == 200) {
        return Sale.fromJson(jsonDecode(res.body));
      }
    } catch (_) {}
    return null;
  }
}
