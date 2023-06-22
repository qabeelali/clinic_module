class RequestContainer {
  final String date;
  final List<Request> orders;

  RequestContainer({required this.date, required this.orders});

  factory RequestContainer.fromJson(Map<String, dynamic> json) {
    return RequestContainer(
        date: json['date'],
        orders: [...json['orders'].map((e) => Request.fromJson(e))]);
  }
}

class Request {
  final int id;
  final int type;
  final String typeName;
  final String fullName;
  final String image;
  String stateName;
  int state;
  final String date;
  final int? seriesNum;
  final String gander;
  final String? age;
  final String? address;
  final String bookingType;
  final String? paymentMethode;
  final String mobile;
  final int userId;
  final int isFamily;
  final int? updateId;

  Request(
      {required this.id,
      required this.type,
      required this.typeName,
      required this.fullName,
      required this.image,
      required this.stateName,
      required this.state,
      required this.date,
      required this.seriesNum,
      required this.gander,
      required this.age,
      required this.address,
      required this.bookingType,
      required this.isFamily,
      this.paymentMethode,
      required this.userId,
  this.updateId,
      required this.mobile});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
        id: json['id'],
        type: json['type'],
        typeName: json['type'] == 1 ? 'Booking' : 'consultation',
        fullName: json['full_name'],
        image: json['request_obj']['image'],
        stateName: json['state_name'],
        state: json['state'],
        date: json['date'],
        seriesNum: json['series_num'],
        gander: json['gender_name'],
        age: json['age'],
        address: json['address'],
        bookingType: json['family_name'],
        paymentMethode: json['payment_image'],
        userId: json['request_obj']['id'],
        isFamily: json['isFamily'],
        updateId: json['update_id'],
        mobile: json['country_key'] + json['mobile_without_prefix']);
  }
}
