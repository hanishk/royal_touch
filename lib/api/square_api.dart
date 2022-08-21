import 'dart:convert';
import 'package:either_option/either_option.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:royaltouch/api/api_const.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/pages/payment/models/create_customer.dart';
import 'package:royaltouch/pages/payment/models/create_customer_card_failure_res.dart';
import 'package:royaltouch/pages/payment/models/create_customer_card_req.dart';
import 'package:royaltouch/pages/payment/models/create_customer_card_res.dart';
import 'package:royaltouch/pages/payment/models/create_customer_success_res.dart';
import 'package:royaltouch/pages/payment/models/create_pay_failure_res.dart';
import 'package:royaltouch/pages/payment/models/create_pay_success_res.dart';

class SquareApi {
  SquareApi() {
    const _sandboxAccessToken =
        'EAAAEFUiD1NSHjCj-_X-wjZZcGaf3mG83dtnjyv91WzTvEW5oaU0XxorDImQuckW';

    const _prodAccessToken =
        'EAAAELzeL5VqL0Sffhp_b_yiMbIyU7qqEOmTvxOBQUR1ryVU4rpznYNhWtlC4DbR';

    const String env = String.fromEnvironment('env', defaultValue: 'dev');

    if (env == 'prod') {
      _accessToken = _prodAccessToken;
    } else {
      _accessToken = _sandboxAccessToken;
    }
  }
  String _accessToken;

  final String _currency = 'USD';
  final String country = 'US';

  Future<Either<CreatePaymentErrorResponse, CreatePaymentSuccessResponse>>
      makeCharge({
    @required UserDetails userDetails,
    @required int amount,
    @required String idempotencyKey,
    @required String sourceId,
  }) async {
    CreatePaymentSuccessResponse createPaymentSuccessResponse;
    CreatePaymentErrorResponse createPaymentErrorResponse;
    final body = {
      'amount_money': {
        'currency': _currency,
        'amount': amount * 100,
      },
      'idempotency_key': idempotencyKey,
      'source_id': sourceId,
      'customer_id': userDetails.sqCustomer.customer.id,
    };
    await http.post(
      SqApiConst().sqCreatePayment(),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Square-Version': '2020-11-18',
        'Authorization': 'Bearer $_accessToken'
      },
    ).then((http.Response response) {
      if (response.statusCode == 200) {
        createPaymentSuccessResponse =
            CreatePaymentSuccessResponse.fromJson(jsonDecode(response.body));
      } else {
        createPaymentErrorResponse =
            CreatePaymentErrorResponse.fromJson(jsonDecode(response.body));
      }
    });
    if (createPaymentSuccessResponse != null) {
      return Right<CreatePaymentErrorResponse, CreatePaymentSuccessResponse>(
          createPaymentSuccessResponse);
    } else {
      return Left<CreatePaymentErrorResponse, CreatePaymentSuccessResponse>(
          createPaymentErrorResponse);
    }
  }

  Future<Either<CreateCustomerCardError, CreateCustomerCardResponse>>
      makeCustomerCard({
    @required CreateCustomerCardRequest cardRequest,
    @required String customerId,
  }) async {
    CreateCustomerCardResponse cardResponse;
    CreateCustomerCardError cardErrorResponse;
    await http.post(
      SqApiConst().sqCreateCustomerCard(customerId),
      body: jsonEncode(cardRequest.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Square-Version': '2020-11-18',
        'Authorization': 'Bearer $_accessToken'
      },
    ).then((http.Response response) {
      if (response.statusCode == 200) {
        cardResponse =
            CreateCustomerCardResponse.fromJson(jsonDecode(response.body));
      } else {
        cardErrorResponse =
            CreateCustomerCardError.fromJson(jsonDecode(response.body));
      }
    });
    if (cardResponse != null) {
      return Right<CreateCustomerCardError, CreateCustomerCardResponse>(
          cardResponse);
    } else {
      return Left<CreateCustomerCardError, CreateCustomerCardResponse>(
          cardErrorResponse);
    }
  }

  Future<CreateCustomerSuccessResponse> createCustomerSquare({
    @required CreateCustomer createCustomer,
  }) async {
    CreateCustomerSuccessResponse successResponse;
    await http.post(
      SqApiConst().sqCreateCustomer(),
      body: jsonEncode(createCustomer.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Square-Version': '2020-11-18',
        'Authorization': 'Bearer $_accessToken'
      },
    ).then((http.Response response) {
      if (response.statusCode == 200) {
        print('Created Square Customer');
        successResponse =
            CreateCustomerSuccessResponse.fromJson(jsonDecode(response.body));
      } else {
        print(response.body);
      }
    });
    return successResponse;
  }

  Future<void> deleteCustomerCard({@required UserDetails userDetails}) async {
    await http.delete(
      SqApiConst().sqDeleteCustomeCard(
        userDetails.sqCustomer.customer.id,
        userDetails.sqCardOnFile.card.id,
      ),
      headers: {
        'Content-Type': 'application/json',
        'Square-Version': '2020-11-18',
        'Authorization': 'Bearer $_accessToken'
      },
    );
  }
}
