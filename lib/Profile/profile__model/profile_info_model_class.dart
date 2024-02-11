class ProfileInfo {
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

  ProfileInfo(
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

  ProfileInfo.fromJson(Map<String, dynamic> json) {
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