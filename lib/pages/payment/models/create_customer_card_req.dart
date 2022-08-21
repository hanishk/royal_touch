class CreateCustomerCardRequest {
  String cardNonce;
  BillingAddress billingAddress;
  String cardholderName;

  CreateCustomerCardRequest(
      {this.cardNonce, this.billingAddress, this.cardholderName});

  CreateCustomerCardRequest.fromJson(Map<String, dynamic> json) {
    cardNonce = json['card_nonce'];
    billingAddress = json['billing_address'] != null
        ? new BillingAddress.fromJson(json['billing_address'])
        : null;
    cardholderName = json['cardholder_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card_nonce'] = this.cardNonce;
    if (this.billingAddress != null) {
      data['billing_address'] = this.billingAddress.toJson();
    }
    data['cardholder_name'] = this.cardholderName;
    return data;
  }
}

class BillingAddress {
  String addressLine1;
  String addressLine2;
  String locality;
  String administrativeDistrictLevel1;
  String postalCode;
  String country;

  BillingAddress(
      {this.addressLine1,
      this.addressLine2,
      this.locality,
      this.administrativeDistrictLevel1,
      this.postalCode,
      this.country});

  BillingAddress.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    locality = json['locality'];
    administrativeDistrictLevel1 = json['administrative_district_level_1'];
    postalCode = json['postal_code'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['locality'] = this.locality;
    data['administrative_district_level_1'] = this.administrativeDistrictLevel1;
    data['postal_code'] = this.postalCode;
    data['country'] = this.country;
    return data;
  }
}
