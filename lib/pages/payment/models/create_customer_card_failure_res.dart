class CreateCustomerCardError {
  List<Errors> errors;

  CreateCustomerCardError({this.errors});

  CreateCustomerCardError.fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      errors = new List<Errors>();
      json['errors'].forEach((v) {
        errors.add(new Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.errors != null) {
      data['errors'] = this.errors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Errors {
  String code;
  String category;
  String detail;

  Errors({this.code, this.category, this.detail});

  Errors.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    category = json['category'] ?? '';
    detail = json['detail'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['category'] = this.category;
    data['detail'] = this.detail;
    return data;
  }
}
