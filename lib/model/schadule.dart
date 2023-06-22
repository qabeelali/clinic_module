class Order {
  final int id;
  final String full_name;
  final String image;
  final int? updateId;
  Order(
      {required this.id,
      required this.full_name,
      required this.image,
       this.updateId});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        full_name: json['full_name'],
        image: json['received_obj']['image'],
        updateId: json['update_id']);
  }
}

class OrderContainer {
  final List<Order?> orders;
  final String startTime;
  final String endTime;
  OrderContainer({
    required this.orders,
    required this.startTime,
    required this.endTime,
  });

  factory OrderContainer.fromJson(Map<String, dynamic> json){
    return OrderContainer(orders: [...json['order'].map((e)=>Order.fromJson(e))]  , startTime: json['start_time'], endTime: json['end_time']);
  }
}
