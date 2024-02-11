class SupportModelClass {
  bool? success;
  List<Data>? data;
  String? message;

  SupportModelClass({this.success, this.data, this.message});

  SupportModelClass.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? cateName;
  String? colorCode;

  Data({this.id, this.cateName, this.colorCode});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cateName = json['cate_name'];
    colorCode = json['color_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cate_name'] = this.cateName;
    data['color_code'] = this.colorCode;
    return data;
  }
}