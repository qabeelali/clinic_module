class Price {
  final int id;
  final String product_name;
  final String price;
final String productId;
  Price({required this.id, required this.product_name, required this.price, required this.productId});
  factory Price.fromJson(Map<String, dynamic>json){
    return Price(id: json['id'], product_name: json['product_name'], price: json['price'], productId: json['product_id']);
  }
}