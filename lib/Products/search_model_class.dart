class SearchModel {
  int? productId;
  String? productName;
  String? productImage;
  int? serviceId;
  String? serviceName;
  String? price;
  String? hPrice;
  SearchModel(
      {this.productId,
        this.productName,
        this.productImage,
        this.serviceId,
        this.serviceName,
        this.price});

  SearchModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    serviceId = json['service_id'];
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
    data['h_price'] = this.hPrice;
    return data;
  }
}