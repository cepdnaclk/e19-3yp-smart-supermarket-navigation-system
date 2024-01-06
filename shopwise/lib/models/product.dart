class Product {
  final String name;
  final String image;
  final String price;
  final String description;
  final String category;
  final String brand;
  final String rating;
  final String numReviews;
  final String countInStock;
  final String id;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.category,
    required this.brand,
    required this.rating,
    required this.numReviews,
    required this.countInStock,
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