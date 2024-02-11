class CartModel{

  int? id;
  String? name;
  int? productId;
  int? serviceId;
  String? serviceName;
  int quantity=0;
  int? price;
  String? createdAt;
  String? updatedAt;

  CartModel({this.id,this.name,this.productId, this.serviceId,this.serviceName,required this.quantity, this.price, this.createdAt, this.updatedAt});
  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name= json['name'];
    productId= json['product_id'];
    serviceId= json['service_id'];
    serviceName= json['service_name'];
    quantity = json['quantity'];
    price= json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name']=this.name;
    data['product_id'] = this.productId;
    data['service_id']=this.serviceId;
    data['service_name']=this.serviceName;
    data['quantity']=this.quantity;
    data['price']=this.price;
    data['created_at']=this.createdAt;
    data['updated_at']=this.updatedAt;
    return data;
  }
}