import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:royaltouch/pages/payment/models/create_pay_success_res.dart';

class AppointmentModel {
  Payment initialPayment, remainingPayment;
  String status;
  Service service;
  Technician technician;
  // CreatePaymentSuccessResponse squarePaymentResponse;
  String address;
  String phone;
  Timestamp createdAt;
  AppointmentDetails appointmentDetails;
  String docPath;
  AppointmentModel({
    this.initialPayment,
    this.status,
    this.service,
    this.technician,
    // this.squarePaymentResponse,
    this.address,
    this.appointmentDetails,
    this.phone,
    this.createdAt,
    this.docPath,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    docPath = json['doc_path'];
    initialPayment = json['initial_payment'] != null
        ? new Payment.fromJson(json['initial_payment'])
        : null;
    remainingPayment = json['remaining_payment'] != null
        ? new Payment.fromJson(json['remaining_payment'])
        : null;
    status = json['status'];

    service =
        json['service'] != null ? new Service.fromJson(json['service']) : null;
    technician = json['technician'] != null
        ? new Technician.fromJson(json['technician'])
        : null;
    appointmentDetails = json['appointment_details'] != null
        ? new AppointmentDetails.fromJson(json['appointment_details'])
        : null;
    // squarePaymentResponse = json['square_payment_response'] != null
    //     ? CreatePaymentSuccessResponse.fromJson(json['square_payment_response'])
    //     : null;
    address = json['address'];
    phone = json['phone'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.initialPayment != null) {
      data['initial_payment'] = this.initialPayment.toJson();
    }
    if (this.remainingPayment != null) {
      data['remaining_payment'] = this.remainingPayment.toJson();
    }
    data['status'] = this.status;
    if (this.service != null) {
      data['service'] = this.service.toJson();
    }
    if (this.technician != null) {
      data['technician'] = this.technician.toJson();
    }
    // data['square_payment_response'] = this.squarePaymentResponse;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Payment {
  int paid;
  Timestamp createdAt;

  Payment({this.paid, this.createdAt});

  Payment.fromJson(Map<String, dynamic> json) {
    paid = json['paid'].toInt() ?? null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paid'] = this.paid;
    return data;
  }
}

class Service {
  String name;
  double time;
  int price;
  String path;

  Service({this.name, this.time, this.price, this.path});

  Service.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    time = json['time'];
    price = json['price'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['time'] = this.time;
    data['price'] = this.price;
    data['path'] = this.path;
    return data;
  }
}

class AppointmentDetails {
  Timestamp date;
  TimeSlot timeslot;

  AppointmentDetails({this.date, this.timeslot});

  AppointmentDetails.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timeslot = json['timeslot'] != null
        ? new TimeSlot.fromJson(json['timeslot'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.timeslot != null) {
      data['timeslot'] = this.timeslot.toJson();
    }
    return data;
  }
}

class TimeSlot {
  Timestamp startTime;
  Timestamp endTime;

  TimeSlot({this.startTime, this.endTime});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}

class Technician {
  String name;
  String calendarId;
  String path;

  Technician({this.name, this.calendarId, this.path});

  Technician.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    calendarId = json['calendar_id'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['calendar_id'] = this.calendarId;
    data['path'] = this.path;
    return data;
  }
}
