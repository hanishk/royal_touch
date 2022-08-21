class CreateCustomerSuccessResponse {
  Customer customer;

  CreateCustomerSuccessResponse({this.customer});

  CreateCustomerSuccessResponse.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Customer {
  String id;
  String createdAt;
  String updatedAt;
  String givenName;
  String nickname;
  String emailAddress;
  Address address;
  String phoneNumber;
  Preferences preferences;
  String creationSource;

  Customer(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.givenName,
      this.nickname,
      this.emailAddress,
      this.address,
      this.phoneNumber,
      this.preferences,
      this.creationSource});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    givenName = json['given_name'];
    nickname = json['nickname'];
    emailAddress = json['email_address'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    phoneNumber = json['phone_number'];
    preferences = json['preferences'] != null
        ? new Preferences.fromJson(json['preferences'])
        : null;
    creationSource = json['creation_source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['given_name'] = this.givenName;
    data['nickname'] = this.nickname;
    data['email_address'] = this.emailAddress;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['phone_number'] = this.phoneNumber;
    if (this.preferences != null) {
      data['preferences'] = this.preferences.toJson();
    }
    data['creation_source'] = this.creationSource;
    return data;
  }
}

class Address {
  String addressLine1;
  String country;

  Address({this.addressLine1, this.country});

  Address.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['address_line_1'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line_1'] = this.addressLine1;
    data['country'] = this.country;
    return data;
  }
}

class Preferences {
  bool emailUnsubscribed;

  Preferences({this.emailUnsubscribed});

  Preferences.fromJson(Map<String, dynamic> json) {
    emailUnsubscribed = json['email_unsubscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_unsubscribed'] = this.emailUnsubscribed;
    return data;
  }
}
