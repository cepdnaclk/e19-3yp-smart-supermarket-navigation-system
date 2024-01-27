class Product {
  final String title;
  final String image;
  final String price;
  final String description;
  final String brand;
  final String promo_details;
  final String cell;
  final String promotion;
  final String id;

  Product({
    required this.title,
    required this.image,
    required this.price,
    required this.description,
    required this.brand,
    required this.promo_details,
    required this.cell,
    required this.promotion,
    required this.id,
  });

  // factory Product.fromJson(Map<String, dynamic> json) {
  //   return Product(
  //     name: json['name'],
  //     image: json['image'], 
  //     price: json['price'],
  //     description: json['description'],
  //     category: json['category'],
  //     brand: json['brand'],
  //     rating: json['rating'],
  //     numReviews: json['numReviews'],
  //     countInStock: json['countInStock'],
  //     id: json['_id'],
  //   );
  // }
}