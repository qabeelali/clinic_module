class AvailedDate{
  final int id;
  final bool isValid;

  AvailedDate({ required this.id, required this.isValid});

  factory AvailedDate.fromJson(json){
    return AvailedDate(id: json['current_num'], isValid: json['isValid']);
  }
}