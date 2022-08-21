class CreatePaymentSuccessResponse {
  _Payment payment;

  CreatePaymentSuccessResponse({this.payment});

  CreatePaymentSuccessResponse.fromJson(Map<String, dynamic> json) {
    payment =
        json['payment'] != null ? new _Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
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
  _RiskEvaluation riskEvaluation;
  List<_ProcessingFee> processingFee;
  _AmountMoney totalMoney;
  String receiptNumber;
  String receiptUrl;
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
      this.riskEvaluation,
      this.processingFee,
      this.totalMoney,
      this.receiptNumber,
      this.receiptUrl,
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
    riskEvaluation = json['risk_evaluation'] != null
        ? new _RiskEvaluation.fromJson(json['risk_evaluation'])
        : null;
    if (json['processing_fee'] != null) {
      processingFee = new List<_ProcessingFee>();
      json['processing_fee'].forEach((v) {
        processingFee.add(new _ProcessingFee.fromJson(v));
      });
    }
    totalMoney = json['total_money'] != null
        ? new _AmountMoney.fromJson(json['total_money'])
        : null;
    receiptNumber = json['receipt_number'];
    receiptUrl = json['receipt_url'];
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
    if (this.riskEvaluation != null) {
      data['risk_evaluation'] = this.riskEvaluation.toJson();
    }
    if (this.processingFee != null) {
      data['processing_fee'] =
          this.processingFee.map((v) => v.toJson()).toList();
    }
    if (this.totalMoney != null) {
      data['total_money'] = this.totalMoney.toJson();
    }
    data['receipt_number'] = this.receiptNumber;
    data['receipt_url'] = this.receiptUrl;
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
  String statementDescription;

  _CardDetails(
      {this.status,
      this.card,
      this.entryMethod,
      this.cvvStatus,
      this.avsStatus,
      this.statementDescription});

  _CardDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    card = json['card'] != null ? new _Card.fromJson(json['card']) : null;
    entryMethod = json['entry_method'];
    cvvStatus = json['cvv_status'];
    avsStatus = json['avs_status'];
    statementDescription = json['statement_description'];
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
    data['statement_description'] = this.statementDescription;
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
  String prepaidType;
  String bin;

  _Card(
      {this.cardBrand,
      this.last4,
      this.expMonth,
      this.expYear,
      this.fingerprint,
      this.cardType,
      this.prepaidType,
      this.bin});

  _Card.fromJson(Map<String, dynamic> json) {
    cardBrand = json['card_brand'];
    last4 = json['last_4'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    cardType = json['card_type'];
    prepaidType = json['prepaid_type'];
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
    data['prepaid_type'] = this.prepaidType;
    data['bin'] = this.bin;
    return data;
  }
}

class _RiskEvaluation {
  String createdAt;
  String riskLevel;

  _RiskEvaluation({this.createdAt, this.riskLevel});

  _RiskEvaluation.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    riskLevel = json['risk_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['risk_level'] = this.riskLevel;
    return data;
  }
}

class _ProcessingFee {
  String effectiveAt;
  String type;
  _AmountMoney amountMoney;

  _ProcessingFee({this.effectiveAt, this.type, this.amountMoney});

  _ProcessingFee.fromJson(Map<String, dynamic> json) {
    effectiveAt = json['effective_at'];
    type = json['type'];
    amountMoney = json['amount_money'] != null
        ? new _AmountMoney.fromJson(json['amount_money'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['effective_at'] = this.effectiveAt;
    data['type'] = this.type;
    if (this.amountMoney != null) {
      data['amount_money'] = this.amountMoney.toJson();
    }
    return data;
  }
}
