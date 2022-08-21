class CreatePaymentErrorResponse {
  List<Errors> errors;
  _Payment payment;

  CreatePaymentErrorResponse({this.errors, this.payment});

  CreatePaymentErrorResponse.fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      errors = new List<Errors>();
      json['errors'].forEach((v) {
        errors.add(new Errors.fromJson(v));
      });
    }
    payment =
        json['payment'] != null ? new _Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.errors != null) {
      data['errors'] = this.errors.map((v) => v.toJson()).toList();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    return data;
  }
}

class Errors {
  String code;
  String detail;
  String category;

  Errors({this.code, this.detail, this.category});

  Errors.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    detail = json['detail'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['detail'] = this.detail;
    data['category'] = this.category;
    return data;
  }
}

class _Payment {
  String id;
  String createdAt;
  String updatedAt;
  _AmountMoney amountMoney;
  String status;
  String delayDuration;
  String sourceType;
  _CardDetails cardDetails;
  String locationId;
  String orderId;
  _AmountMoney totalMoney;
  String delayAction;
  String delayedUntil;

  _Payment(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.amountMoney,
      this.status,
      this.delayDuration,
      this.sourceType,
      this.cardDetails,
      this.locationId,
      this.orderId,
      this.totalMoney,
      this.delayAction,
      this.delayedUntil});

  _Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    amountMoney = json['amount_money'] != null
        ? new _AmountMoney.fromJson(json['amount_money'])
        : null;
    status = json['status'];
    delayDuration = json['delay_duration'];
    sourceType = json['source_type'];
    cardDetails = json['card_details'] != null
        ? new _CardDetails.fromJson(json['card_details'])
        : null;
    locationId = json['location_id'];
    orderId = json['order_id'];
    totalMoney = json['total_money'] != null
        ? new _AmountMoney.fromJson(json['total_money'])
        : null;
    delayAction = json['delay_action'];
    delayedUntil = json['delayed_until'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.amountMoney != null) {
      data['amount_money'] = this.amountMoney.toJson();
    }
    data['status'] = this.status;
    data['delay_duration'] = this.delayDuration;
    data['source_type'] = this.sourceType;
    if (this.cardDetails != null) {
      data['card_details'] = this.cardDetails.toJson();
    }
    data['location_id'] = this.locationId;
    data['order_id'] = this.orderId;
    if (this.totalMoney != null) {
      data['total_money'] = this.totalMoney.toJson();
    }
    data['delay_action'] = this.delayAction;
    data['delayed_until'] = this.delayedUntil;
    return data;
  }
}

class _AmountMoney {
  int amount;
  String currency;

  _AmountMoney({this.amount, this.currency});

  _AmountMoney.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    return data;
  }
}

class _CardDetails {
  String status;
  _Card card;
  String entryMethod;
  String cvvStatus;
  String avsStatus;
  List<Errors> errors;

  _CardDetails(
      {this.status,
      this.card,
      this.entryMethod,
      this.cvvStatus,
      this.avsStatus,
      this.errors});

  _CardDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    card = json['card'] != null ? new _Card.fromJson(json['card']) : null;
    entryMethod = json['entry_method'];
    cvvStatus = json['cvv_status'];
    avsStatus = json['avs_status'];
    if (json['errors'] != null) {
      errors = new List<Errors>();
      json['errors'].forEach((v) {
        errors.add(new Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    data['entry_method'] = this.entryMethod;
    data['cvv_status'] = this.cvvStatus;
    data['avs_status'] = this.avsStatus;
    if (this.errors != null) {
      data['errors'] = this.errors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class _Card {
  String cardBrand;
  String last4;
  int expMonth;
  int expYear;
  String fingerprint;
  String cardType;
  String bin;

  _Card(
      {this.cardBrand,
      this.last4,
      this.expMonth,
      this.expYear,
      this.fingerprint,
      this.cardType,
      this.bin});

  _Card.fromJson(Map<String, dynamic> json) {
    cardBrand = json['card_brand'];
    last4 = json['last_4'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    cardType = json['card_type'];
    bin = json['bin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card_brand'] = this.cardBrand;
    data['last_4'] = this.last4;
    data['exp_month'] = this.expMonth;
    data['exp_year'] = this.expYear;
    data['fingerprint'] = this.fingerprint;
    data['card_type'] = this.cardType;
    data['bin'] = this.bin;
    return data;
  }
}
