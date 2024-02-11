
class UserModel {
  String? token;
  int? customerId;
  String? phone;


  UserModel({this.token, this.customerId, this.phone});

  UserModel.fromJson(Map<String, dynamic> json) {

    token = json['token'];
    customerId = json['customer_id'];
    phone = json['phone'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['customer_id'] = this.customerId;
    data['phone'] = this.phone;
    return data;
  }
}