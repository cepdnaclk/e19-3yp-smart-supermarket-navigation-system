class Customer {
  final String sub_uuid;
  final String email;
  final String hashcode;
  final String order_id;
  final DateTime shopping_date;

Customer({required this.sub_uuid, required this.email, required this.hashcode, required this.order_id, required this.shopping_date });

Customer copyWith({
    String? order_id,
    String? email,
    String? sub_uuid,
    String? hashcode,
    DateTime? shopping_date,
  }) {
    return Customer(
      order_id: order_id ?? this.order_id,
      email: email ?? this.email,
      sub_uuid: sub_uuid ?? this.sub_uuid,
      hashcode: hashcode ?? this.hashcode,
      shopping_date: shopping_date ?? this.shopping_date,
    );
  }

}