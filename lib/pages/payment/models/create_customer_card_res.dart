class CreateCustomerCardResponse {
  Card card;

  CreateCustomerCardResponse({this.card});

  CreateCustomerCardResponse.fromJson(Map<String, dynamic> json) {
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    return data;
  }
}

class Card {
  String id;
  String cardBrand;
  String last4;
  int expMonth;
  int expYear;
  String cardholderName;
  BillingAddress billingAddress;

  Card(
      {this.id,
      this.cardBrand,
      this.last4,
      this.expMonth,
      this.expYear,
      this.cardholderName,
      this.billingAddress});

  Card.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardBrand = json['card_brand'];
    last4 = json['last_4'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    cardholderName = json['cardholder_name'];
    billingAddress = json['billing_address'] != null
        ? new BillingAddress.fromJson(json['billing_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['card_brand'] = this.cardBrand;
    data['last_4'] = this.last4;
    data['exp_month'] = this.expMonth;
    data['exp_year'] = this.expYear;
    data['cardholder_name'] = this.cardholderName;
    if (this.billingAddress != null) {
      data['billing_address'] = this.billingAddress.toJson();
    }
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
