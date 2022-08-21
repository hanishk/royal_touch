class CreateCustomer {
  String emailAddress;
  String givenName;
  String nickname;
  String phoneNumber;
  String idempotencyKey;
  Address address;

  CreateCustomer(
      {this.emailAddress,
      this.givenName,
      this.nickname,
      this.phoneNumber,
      this.idempotencyKey,
      this.address});

  CreateCustomer.fromJson(Map<String, dynamic> json) {
    emailAddress = json['email_address'];
    givenName = json['given_name'];
    nickname = json['nickname'];
    phoneNumber = json['phone_number'];
    idempotencyKey = json['idempotency_key'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_address'] = this.emailAddress;
    data['given_name'] = this.givenName;
    data['nickname'] = this.nickname;
    data['phone_number'] = this.phoneNumber;
    data['idempotency_key'] = this.idempotencyKey;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class Address {
  String addressLine1, postalCode;

  Address({this.addressLine1, this.postalCode});

  Address.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['address_line_1'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line_1'] = this.addressLine1;
    data['postal_code'] = this.postalCode;
    return data;
  }
}
