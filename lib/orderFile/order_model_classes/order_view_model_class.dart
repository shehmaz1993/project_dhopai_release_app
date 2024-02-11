class OrderViewModelClass {
  String? status;
  int? id;
  String? ordDate;
  String? ref;
  int? amount;
  Customer? customer;
  List<OrderItems>? orderItems;

  OrderViewModelClass(
      {this.status,
        this.id,
        this.ordDate,
        this.ref,
        this.amount,
        this.customer,
        this.orderItems});

  OrderViewModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    id = json['id'];
    ordDate = json['ord_date'];
    ref = json['ref'];
    amount = json['amount'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['id'] = this.id;
    data['ord_date'] = this.ordDate;
    data['ref'] = this.ref;
    data['amount'] = this.amount;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? fName;
  String? lName;
  Null? image;
  int? phone;
  Null? email;
  Null? phoneVerifiedAt;
  int? isVerify;
  int? active;
  String? createdAt;
  String? updatedAt;

  Customer(
      {this.id,
        this.fName,
        this.lName,
        this.image,
        this.phone,
        this.email,
        this.phoneVerifiedAt,
        this.isVerify,
        this.active,
        this.createdAt,
        this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    image = json['image'];
    phone = json['phone'];
    email = json['email'];
    phoneVerifiedAt = json['phone_verified_at'];
    isVerify = json['isVerify'];
    active = json['active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['isVerify'] = this.isVerify;
    data['active'] = this.active;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OrderItems {
  int? id;
  int? orderId;
  int? productId;
  int? serviceId;
  int? qtn;
  int? price;
  String? createdAt;
  String? updatedAt;

  OrderItems(
      {this.id,
        this.orderId,
        this.productId,
        this.serviceId,
        this.qtn,
        this.price,
        this.createdAt,
        this.updatedAt});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    serviceId = json['service_id'];
    qtn = json['qtn'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['service_id'] = this.serviceId;
    data['qtn'] = this.qtn;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}