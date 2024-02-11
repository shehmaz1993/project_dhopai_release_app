class DeliveryInfoModel {
  int? id;
  String? name;
  String? serviceAreaId;
  String? decription;
  String? amount;
  String? createdAt;
  String? updatedAt;

  DeliveryInfoModel(
      {this.id,
        this.name,
        this.serviceAreaId,
        this.decription,
        this.amount,
        this.createdAt,
        this.updatedAt});

  DeliveryInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serviceAreaId = json['service_area_id'];
    decription = json['decription'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['service_area_id'] = this.serviceAreaId;
    data['decription'] = this.decription;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}