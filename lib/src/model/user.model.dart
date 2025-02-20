class User {
  final String name;
  final double balance;
  final DateTime createdAt;

  User({
    required this.name,
    required this.balance,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'balance': balance,
      'created_at': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      balance: map['balance'],
      createdAt: map['created_at'],
    );
  }
}
