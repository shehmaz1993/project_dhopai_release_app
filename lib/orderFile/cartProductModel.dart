class CartProductModel {
  bool? success;
  List<Data>? data;
  int? message;

  CartProductModel({this.success, this.data, this.message});

  CartProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( new Data.fromJson(v));
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
  int? id;
  String? customerId;
  String? productId;
  String? serviceId;
  String? quantity;
  String? price;
  String? hPrice;
  String? createdAt;
  String? updatedAt;
  Product? product;
  Service? service;

  Data(
      {this.id,
        this.customerId,
        this.productId,
        this.serviceId,
        this.quantity,
        this.price,
        this.hPrice,
        this.createdAt,
        this.updatedAt,
        this.product,
        this.service});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ;
    customerId = json['customer_id']  ;
    productId = json['product_id'] ;
    serviceId = json['service_id'] ;
    quantity = json['quantity'] ;
    price = json['price'];
    hPrice = json['h_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    service =
    json['service'] != null ? new Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['product_id'] = this.productId;
    data['service_id'] = this.serviceId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['h_price'] = this.hPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? slug;
  String? sku;
  String? imagePath;
  String? categoryId;
  String? active;
  String? deleteStatus;
  String? priceId;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
        this.name,
        this.slug,
        this.sku,
        this.imagePath,
        this.categoryId,
        this.active,
        this.deleteStatus,
        this.priceId,
        this.createdAt,
        this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    sku = json['sku'];
    imagePath = json['image_path'];
    categoryId = json['category_id'];
    active = json['active'];
    deleteStatus = json['delete_status'];
    priceId = json['price_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['sku'] = this.sku;
    data['image_path'] = this.imagePath;
    data['category_id'] = this.categoryId;
    data['active'] = this.active;
    data['delete_status'] = this.deleteStatus;
    data['price_id'] = this.priceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Service {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Service({this.id, this.name, this.createdAt, this.updatedAt});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}