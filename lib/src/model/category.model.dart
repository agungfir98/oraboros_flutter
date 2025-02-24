class Category {
  final int? id;
  final String name;
  final double amount;
  final DateTime? createdAt;

  Category({this.id, required this.name, required this.amount, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'created_at': createdAt,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      amount: (map['amount'] as num).toDouble(),
      createdAt: map['created_at'],
    );
  }
}
