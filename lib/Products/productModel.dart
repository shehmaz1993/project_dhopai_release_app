class ProductModel {
  bool? success;
  List<Data>? data;
  String? message;

  ProductModel({this.success, this.data, this.message});

  ProductModel.fromJson(Map<String, dynamic> json) {
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
  int? productId;
  String? productName;
  String? productImage;
  int? serviceId;
  String? serviceName;
  int? price;
  int? hPrice;
  Data(
      {this.productId,
        this.productName,
        this.productImage,
        this.serviceId,
        this.serviceName,
        this.price,this.hPrice});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] as int;
    productName = json['product_name'];
    productImage = json['product_image'];
    serviceId = json['service_id'] as int;
    serviceName = json['service_name'];
    price = json['price'];
    hPrice = json['h_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['price'] = this.price;
    data['h_price'] =this.hPrice;
    return data;
  }
}