import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:royaltouch/bloc/make_appointments_bloc/appointments_bloc.dart';
import 'package:royaltouch/pages/payment/models/create_customer_card_res.dart';
import 'package:royaltouch/pages/payment/models/create_customer_success_res.dart';

class AllServices {
  AllServices({
    @required this.name,
    @required this.time,
    @required this.price,
    @required this.uuid,
    @required this.imageUrl,
    @required this.description,
    @required this.youtubeVideoUrl,
  });
  final String name, uuid, imageUrl, description, youtubeVideoUrl;
  final double time;
  final int price;

  static AllServices fromMap(Map map) => AllServices(
        time: double.parse(map['time'].toString()),
        price: map['price'],
        name: map['name'],
        uuid: map['id'],
        imageUrl: map['image_url'],
        description: map['description'],
        youtubeVideoUrl: map['youtube_video_url'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['time'] = time;
    data['price'] = price;
    data['uuid'] = uuid;
    data['image_url'] = imageUrl;
    data['description'] = description;
    data['youtube_video_url'] = youtubeVideoUrl;
    return data;
  }
}

class Technician {
  Technician({
    @required this.name,
    @required this.calendarId,
    @required this.docId,
  });
  final String name, calendarId, docId;

  static Technician fromMap(DocumentSnapshot snapshot) {
    final Map map = snapshot.data();
    return Technician(
      name: map['name'],
      calendarId: map['calendar_id'],
      docId: snapshot.id,
    );
  }
}

class UserDetails {
  UserDetails(
      {this.name,
      this.email,
      this.contact,
      this.address,
      this.location,
      this.sqCustomer,
      this.sqCardOnFile});
  String name, email, contact, address, location;
  CreateCustomerSuccessResponse sqCustomer;
  CreateCustomerCardResponse sqCardOnFile;
  static UserDetails fromMap(DocumentSnapshot snapshot) {
    final Map map = snapshot.data();
    return UserDetails(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      contact: map['phone'] ?? '',
      address: map['address'] ?? '',
      location: map['location'] ?? '',
      sqCustomer: map['sq_customer'] != null
          ? CreateCustomerSuccessResponse.fromJson(map['sq_customer']) ?? ''
          : null,
      sqCardOnFile: map['sq_card_on_file'] != null
          ? CreateCustomerCardResponse.fromJson(map['sq_card_on_file']) ?? ''
          : null,
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': contact,
      'address': address,
      'location': location,
    };
  }
}

class PaymentConfirmationModel {
  PaymentConfirmationModel({
    @required this.services,
    @required this.state,
  });
  final AllServices services;
  final MakeAppointmentsState state;
}

class TimeSlot {
  TimeSlot(this.startTime, this.endTime);
  final Timestamp startTime, endTime;
  Map<String, Timestamp> toMap() {
    return {
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
