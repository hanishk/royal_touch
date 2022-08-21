class ApiConst {
  static String calendarFreeBusy =
      'https://www.googleapis.com/calendar/v3/freeBusy';

  static String calendarInsertEvents(String calId) =>
      'https://www.googleapis.com/calendar/v3/calendars/$calId/events';
}

class SqApiConst {
  SqApiConst() {
    const String sqSandboxBaseUrl = 'https://connect.squareupsandbox.com';
    const String sqProdBaseUrl = 'https://connect.squareup.com';
    const String env = String.fromEnvironment('env', defaultValue: 'dev');

    if (env == 'prod') {
      baseUrl = sqProdBaseUrl;
    } else {
      baseUrl = sqSandboxBaseUrl;
    }
  }
  String baseUrl;

  String sqCreatePayment() => '$baseUrl/v2/payments';

  String sqCreateCustomerCard(String customerId) =>
      '$baseUrl/v2/customers/$customerId/cards';

  String sqDeleteCustomeCard(String customerId, String cardId) =>
      '$baseUrl/v2/customers/$customerId/cards/$cardId';

  String sqCreateCustomer() => '$baseUrl/v2/customers';

  String sqDeleteCustomerCard(String customerId, String cardId) =>
      '$baseUrl/v2/customers/$customerId/cards/$cardId';
}
