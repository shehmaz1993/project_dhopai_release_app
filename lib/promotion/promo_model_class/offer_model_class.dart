class OfferModelClass {
  bool? success;
  List<Data>? data;
  String? message;

  OfferModelClass({this.success, this.data, this.message});

  OfferModelClass.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? code;
  String? description;
  String? discountPrice;
  String? cartTotal;
  String? colorCode;

  Data({this.code, this.description, this.discountPrice, this.cartTotal});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    discountPrice = json['discount'];
    cartTotal = json['minimum_amount'];
    colorCode = json['c_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['description'] = this.description;
    data['discount'] = this.discountPrice;
    data['minimum_amount'] = this.cartTotal;
    data['c_code'] = this.colorCode;
    return data;
  }
}