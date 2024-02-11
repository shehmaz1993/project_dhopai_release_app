class TopOrders {
  int? id;
  String? ordDate;
  String? ref;
  int? amount;
  String? status;

  TopOrders({this.id, this.ordDate, this.ref, this.amount, this.status});

  TopOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ordDate = json['ord_date'];
    ref = json['ref'];
    amount = json['amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ord_date'] = this.ordDate;
    data['ref'] = this.ref;
    data['amount'] = this.amount;
    data['status'] = this.status;
    return data;
  }
}