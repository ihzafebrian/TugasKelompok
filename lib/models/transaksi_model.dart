class Transaksi {
  final int id;
  final String transactionCode;
  final int userId;
  final String totalPrice;
  final String paymentStatus;
  final String? paymentProof;
  final String paymentMethod;
  final String transactionDate;
  final int printStatus;
  final String? printedAt;
  final String createdAt;
  final String updatedAt;
  final List<TransactionDetail> details;

  Transaksi({
    required this.id,
    required this.transactionCode,
    required this.userId,
    required this.totalPrice,
    required this.paymentStatus,
    this.paymentProof,
    required this.paymentMethod,
    required this.transactionDate,
    required this.printStatus,
    this.printedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: int.tryParse(json['id'].toString()) ?? 0,
      transactionCode: json['transaction_code'] ?? '',
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      totalPrice: json['total_price'].toString(),
      paymentStatus: json['payment_status'] ?? '',
      paymentProof: json['payment_proof'],
      paymentMethod: json['payment_method'] ?? '',
      transactionDate: json['transaction_date'] ?? '',
      printStatus: int.tryParse(json['print_status'].toString()) ?? 0,
      printedAt: json['printed_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      details: (json['details'] as List<dynamic>)
          .map((e) => TransactionDetail.fromJson(e))
          .toList(),
    );
  }
}

class TransactionDetail {
  final int id;
  final int transactionId;
  final int productId;
  final int quantity;
  final String price;
  final String subtotal;
  final String createdAt;
  final String updatedAt;

  TransactionDetail({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      id: int.tryParse(json['id'].toString()) ?? 0,
      transactionId: int.tryParse(json['transaction_id'].toString()) ?? 0,
      productId: int.tryParse(json['product_id'].toString()) ??
          0, // <- kemungkinan error di sini
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      price: json['price'].toString(),
      subtotal: json['subtotal'].toString(),
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
    );  
  }
}
