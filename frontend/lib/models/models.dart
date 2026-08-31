class StoreInfo {
  final String id;
  final String name;
  final String businessName;
  final String businessType;
  final String branchName;
  final int branchCount;
  final String planName;

  const StoreInfo({
    this.id = 'a0000000-0000-0000-0000-000000000001',
    this.name = 'Prueba',
    this.businessName = 'Prueba',
    this.businessType = 'Minimarket · Perú',
    this.branchName = 'Prueba - Principal',
    this.branchCount = 1,
    this.planName = 'Gratis',
  });
}

class UserProfile {
  final String id;
  final String email;
  final String role;
  final String storeName;

  const UserProfile({
    this.id = 'b0000000-0000-0000-0000-000000000001',
    this.email = 'correo.para.pruebas.2005@gmail.com',
    this.role = 'Administrador',
    this.storeName = 'Prueba',
  });
}

class Category {
  final String id;
  final String name;
  final String colorHex;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    this.colorHex = '#2563EB',
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'colorHex': colorHex,
    'isActive': isActive,
  };

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    colorHex: json['colorHex'] as String? ?? '#2563EB',
    isActive: json['isActive'] as bool? ?? true,
  );
}

class Product {
  final String id;
  final String barcode;
  final String name;
  final String description;
  final bool printDescriptionOnTicket;
  final double price;
  final double cost;
  final String category;
  final String? brand;
  final String? supplier;
  final bool hasVariants;
  final bool trackInventory;
  final double stock;
  final double minStock;
  final String? imageUrl;
  final bool isActive;
  final bool isFavorite;
  final DateTime createdAt;

  Product({
    required this.id,
    this.barcode = '',
    required this.name,
    this.description = '',
    this.printDescriptionOnTicket = false,
    required this.price,
    this.cost = 0.0,
    this.category = '',
    this.brand,
    this.supplier,
    this.hasVariants = false,
    this.trackInventory = true,
    this.stock = 0.0,
    this.minStock = 0.0,
    this.imageUrl,
    this.isActive = true,
    this.isFavorite = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Product copyWith({
    String? id,
    String? barcode,
    String? name,
    String? description,
    bool? printDescriptionOnTicket,
    double? price,
    double? cost,
    String? category,
    String? brand,
    String? supplier,
    bool? hasVariants,
    bool? trackInventory,
    double? stock,
    double? minStock,
    String? imageUrl,
    bool? isActive,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      description: description ?? this.description,
      printDescriptionOnTicket: printDescriptionOnTicket ?? this.printDescriptionOnTicket,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      supplier: supplier ?? this.supplier,
      hasVariants: hasVariants ?? this.hasVariants,
      trackInventory: trackInventory ?? this.trackInventory,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'barcode': barcode,
    'name': name,
    'description': description,
    'printDescriptionOnTicket': printDescriptionOnTicket,
    'price': price,
    'cost': cost,
    'category': category,
    'brand': brand,
    'supplier': supplier,
    'hasVariants': hasVariants,
    'trackInventory': trackInventory,
    'stock': stock,
    'minStock': minStock,
    'imageUrl': imageUrl,
    'isActive': isActive,
    'isFavorite': isFavorite,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as String? ?? '',
    barcode: json['barcode'] as String? ?? '',
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    printDescriptionOnTicket: json['printDescriptionOnTicket'] as bool? ?? false,
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
    category: json['category'] as String? ?? '',
    brand: json['brand'] as String?,
    supplier: json['supplier'] as String?,
    hasVariants: json['hasVariants'] as bool? ?? false,
    trackInventory: json['trackInventory'] as bool? ?? true,
    stock: (json['stock'] as num?)?.toDouble() ?? 0.0,
    minStock: (json['minStock'] as num?)?.toDouble() ?? 0.0,
    imageUrl: json['imageUrl'] as String?,
    isActive: json['isActive'] as bool? ?? true,
    isFavorite: json['isFavorite'] as bool? ?? false,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
  );
}

class Shift {
  final String id;
  final DateTime openedAt;
  final DateTime? closedAt;
  final double initialAmount;
  final double finalAmount;
  final double expectedAmount;
  final double difference;
  final String openingNotes;
  final String closingNotes;
  final String status; // 'Abierta', 'Cerrada'

  Shift({
    required this.id,
    required this.openedAt,
    this.closedAt,
    this.initialAmount = 0.0,
    this.finalAmount = 0.0,
    this.expectedAmount = 0.0,
    this.difference = 0.0,
    this.openingNotes = '',
    this.closingNotes = '',
    this.status = 'Abierta',
  });

  bool get isOpen => status == 'Abierta';

  Map<String, dynamic> toJson() => {
    'id': id,
    'openedAt': openedAt.toIso8601String(),
    'closedAt': closedAt?.toIso8601String(),
    'initialAmount': initialAmount,
    'finalAmount': finalAmount,
    'expectedAmount': expectedAmount,
    'difference': difference,
    'openingNotes': openingNotes,
    'closingNotes': closingNotes,
    'status': status,
  };

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    id: json['id'] as String? ?? '',
    openedAt: json['openedAt'] != null ? DateTime.parse(json['openedAt']) : DateTime.now(),
    closedAt: json['closedAt'] != null ? DateTime.parse(json['closedAt']) : null,
    initialAmount: (json['initialAmount'] as num?)?.toDouble() ?? 0.0,
    finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0.0,
    expectedAmount: (json['expectedAmount'] as num?)?.toDouble() ?? 0.0,
    difference: (json['difference'] as num?)?.toDouble() ?? 0.0,
    openingNotes: json['openingNotes'] as String? ?? '',
    closingNotes: json['closingNotes'] as String? ?? '',
    status: json['status'] as String? ?? 'Abierta',
  );
}

class CartItem {
  final Product product;
  int quantity;
  double customPrice;

  CartItem({
    required this.product,
    this.quantity = 1,
    double? customPrice,
  }) : customPrice = customPrice ?? product.price;

  double get total => customPrice * quantity;
}

class SaleItem {
  final String productId;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double total;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'total': total,
  };

  factory SaleItem.fromJson(Map<String, dynamic> json) => SaleItem(
    productId: json['productId'] as String? ?? '',
    productName: json['productName'] as String? ?? '',
    quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
    unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
    total: (json['total'] as num?)?.toDouble() ?? 0.0,
  );
}

class Sale {
  final String id;
  final String ticketNumber;
  final String receiptType; // Ticket, Boleta, Factura
  final String paymentMethod; // Efectivo, Tarjeta, Yape, Plin, Transferencia
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final double amountPaid;
  final double changeGiven;
  final int itemsCount;
  final String customerName;
  final String notes;
  final DateTime createdAt;
  final List<SaleItem> items;

  Sale({
    required this.id,
    required this.ticketNumber,
    this.receiptType = 'Ticket',
    this.paymentMethod = 'Efectivo',
    required this.subtotal,
    this.tax = 0.0,
    this.discount = 0.0,
    required this.total,
    this.amountPaid = 0.0,
    this.changeGiven = 0.0,
    required this.itemsCount,
    this.customerName = 'Cliente Varios',
    this.notes = '',
    DateTime? createdAt,
    required this.items,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'ticketNumber': ticketNumber,
    'receiptType': receiptType,
    'paymentMethod': paymentMethod,
    'subtotal': subtotal,
    'tax': tax,
    'discount': discount,
    'total': total,
    'amountPaid': amountPaid,
    'changeGiven': changeGiven,
    'itemsCount': itemsCount,
    'customerName': customerName,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
  };

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
    id: json['id'] as String? ?? '',
    ticketNumber: json['ticketNumber'] as String? ?? '',
    receiptType: json['receiptType'] as String? ?? 'Ticket',
    paymentMethod: json['paymentMethod'] as String? ?? 'Efectivo',
    subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
    discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    total: (json['total'] as num?)?.toDouble() ?? 0.0,
    amountPaid: (json['amountPaid'] as num?)?.toDouble() ?? 0.0,
    changeGiven: (json['changeGiven'] as num?)?.toDouble() ?? 0.0,
    itemsCount: json['itemsCount'] as int? ?? 0,
    customerName: json['customerName'] as String? ?? 'Cliente Varios',
    notes: json['notes'] as String? ?? '',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    items: (json['items'] as List<dynamic>?)
            ?.map((e) => SaleItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

class CashRegisterItem {
  final String id;
  final String name;
  final String branchName;
  bool isActive;
  String sessionStatus; // 'Abierta', 'Cerrada'
  final DateTime createdAt;

  CashRegisterItem({
    required this.id,
    required this.name,
    this.branchName = 'Prueba - Principal',
    this.isActive = true,
    this.sessionStatus = 'Cerrada',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().subtract(const Duration(days: 26));

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'branchName': branchName,
    'isActive': isActive,
    'sessionStatus': sessionStatus,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CashRegisterItem.fromJson(Map<String, dynamic> json) => CashRegisterItem(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? 'Caja Principal',
    branchName: json['branchName'] as String? ?? 'Prueba - Principal',
    isActive: json['isActive'] as bool? ?? true,
    sessionStatus: json['sessionStatus'] as String? ?? 'Cerrada',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
  );
}
