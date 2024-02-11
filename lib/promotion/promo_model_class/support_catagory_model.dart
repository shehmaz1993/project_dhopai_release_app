class SupportCatagoryModel {
  bool? success;
  List<Data>? data;
  String? message;

  SupportCatagoryModel({this.success, this.data, this.message});

  SupportCatagoryModel.fromJson(Map<String, dynamic> json) {
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
  String? cateId;
  String? title;
  String? description;

  Data({this.id, this.cateId, this.title, this.description});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cateId = json['cate_id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cate_id'] = this.cateId;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}